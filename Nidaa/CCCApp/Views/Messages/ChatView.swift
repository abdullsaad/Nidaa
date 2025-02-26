import SwiftUI
import SwiftData
import PhotosUI

struct ChatView: View {
    let otherUser: User
    @Environment(\.modelContext) private var modelContext
    
    // Use shared instances directly without @StateObject
    private let messageManager = MessageManager.shared
    private let userManager = UserManager.shared
    private let authManager = AuthenticationManager.shared
    
    @State private var messageText = ""
    @State private var showingAttachmentOptions = false
    @State private var showingCamera = false
    @State private var photoSelection: PhotosPickerItem? = nil
    @State private var attachments: [Attachment] = []
    
    @Query(sort: \Message.timestamp, order: .forward) private var messages: [Message]
    
    @State private var activeCall: Call?
    
    init(otherUser: User) {
        self.otherUser = otherUser
        
        // Capture IDs as local constants
        let currentUserId = AuthenticationManager.shared.currentUserId
        let otherUserId = otherUser.id
        
        let predicate = #Predicate<Message> { message in
            (message.senderId == currentUserId && message.recipientId == otherUserId) ||
            (message.senderId == otherUserId && message.recipientId == currentUserId)
        }
        
        _messages = Query(filter: predicate, sort: \Message.timestamp, order: .forward)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(messages) { message in
                        MessageBubble(message: message)
                    }
                }
                .padding()
            }
            
            Divider()
            
            ChatInputView(
                text: $messageText,
                attachments: $attachments,
                onSend: sendMessage,
                onAttach: { showingAttachmentOptions = true },
                onCamera: { showingCamera = true }
            )
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                ChatNavigationHeader(
                    recipient: otherUser,
                    onVoiceCall: startVoiceCall,
                    onVideoCall: startVideoCall
                )
            }
        }
        .photosPicker(
            isPresented: $showingAttachmentOptions,
            selection: $photoSelection,
            matching: .images
        )
        .onChange(of: photoSelection) { _, newItem in
            if let newItem {
                handleImageSelection(newItem)
            }
        }
        .sheet(isPresented: $showingCamera) {
            ImagePicker(image: $selectedImage, sourceType: .camera)
        }
        .fullScreenCover(item: $activeCall) { call in
            ActiveCallView(call: call)
        }
    }
    
    @State private var selectedImage: UIImage? = nil
    
    private func handleImageSelection(_ item: PhotosPickerItem) {
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                // Create a temporary URL for the image
                let temporaryDirectoryURL = FileManager.default.temporaryDirectory
                let imageURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString + ".jpg")
                
                try? data.write(to: imageURL)
                
                let attachment = Attachment(
                    type: .image,
                    url: imageURL,
                    name: "Image \(Date())",
                    size: Int64(data.count),
                    mimeType: "image/jpeg"
                )
                
                await MainActor.run {
                    attachments.append(attachment)
                    photoSelection = nil // Clear selection
                }
            }
        }
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        
        let message = Message(
            id: UUID(),
            senderId: authManager.currentUserId,
            recipientId: otherUser.id,
            content: messageText,
            messageType: .text,
            attachments: attachments,
            status: .sent,
            timestamp: Date()
        )
        
        modelContext.insert(message)
        try? modelContext.save()
        
        messageText = ""
        attachments.removeAll()
    }
    
    private func markMessagesAsRead() {
        for message in messages where message.senderId == otherUser.id 
            && message.recipientId == authManager.currentUserId 
            && message.status != .read {
            message.status = .read
            message.readTimestamp = Date()
        }
        
        try? modelContext.save()
    }
    
    private func startVoiceCall() {
        let call = Call(
            initiatorId: AuthenticationManager.shared.currentUserId,
            recipientId: otherUser.id,
            type: .voice
        )
        activeCall = call
    }
    
    private func startVideoCall() {
        let call = Call(
            initiatorId: AuthenticationManager.shared.currentUserId,
            recipientId: otherUser.id,
            type: .video
        )
        activeCall = call
    }
}

// Chat Input
struct ChatInputView: View {
    @Binding var text: String
    @Binding var attachments: [Attachment]
    let onSend: () -> Void
    let onAttach: () -> Void
    let onCamera: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: onCamera) {
                Image(systemName: "camera.fill")
                    .font(.title3)
                    .foregroundColor(.accentColor)
            }
            
            Button(action: onAttach) {
                Image(systemName: "photo.fill")
                    .font(.title3)
                    .foregroundColor(.accentColor)
            }
            
            TextField("Message", text: $text)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.send)
                .onSubmit(onSend)
            
            Button(action: onSend) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundColor((text.isEmpty && attachments.isEmpty) ? .gray : .accentColor)
            }
            .disabled(text.isEmpty && attachments.isEmpty)
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

// Multiple Image Picker
struct MultipleImagePicker: UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 10 // Allow up to 10 images
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: MultipleImagePicker
        
        init(_ parent: MultipleImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.dismiss()
            
            guard !results.isEmpty else { return }
            
            let dispatchGroup = DispatchGroup()
            var selectedImages: [UIImage] = []
            
            for result in results {
                dispatchGroup.enter()
                
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                        if let image = image as? UIImage {
                            selectedImages.append(image)
                        }
                        dispatchGroup.leave()
                    }
                } else {
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.parent.images = selectedImages
            }
        }
    }
}

// Image Viewer with Zoom
struct ImageViewer: View {
    let url: URL
    let onDismiss: () -> Void
    
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var uiImage: UIImage? = nil
    @State private var isLoading = true
    @State private var loadError: Error? = nil
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)
            } else if let error = loadError {
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.yellow)
                    
                    Text("Failed to load image")
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    Text(error.localizedDescription)
                        .foregroundColor(.gray)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button("Try Again") {
                        loadImage()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            } else if let image = uiImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .offset(offset)
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                let delta = value / lastScale
                                lastScale = value
                                scale *= delta
                            }
                            .onEnded { _ in
                                lastScale = 1.0
                            }
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                offset = CGSize(
                                    width: lastOffset.width + value.translation.width,
                                    height: lastOffset.height + value.translation.height
                                )
                            }
                            .onEnded { _ in
                                lastOffset = offset
                            }
                    )
                    .gesture(
                        TapGesture(count: 2)
                            .onEnded {
                                if scale > 1 {
                                    scale = 1
                                    offset = .zero
                                    lastOffset = .zero
                                } else {
                                    scale = 2
                                }
                            }
                    )
            }
            
            // Close button
            VStack {
                HStack {
                    Spacer()
                    Button {
                        onDismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                    .padding()
                }
                Spacer()
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        isLoading = true
        loadError = nil
        
        Task {
            do {
                // Create a local copy of the file URL to avoid any potential issues
                let fileURL = url
                print("Loading image from URL: \(fileURL.absoluteString)")
                
                // Load the image data
                let data = try Data(contentsOf: fileURL)
                print("Successfully loaded \(data.count) bytes of image data")
                
                // Create UIImage from data
                if let image = UIImage(data: data) {
                    print("Successfully created UIImage from data")
                    await MainActor.run {
                        self.uiImage = image
                        self.isLoading = false
                    }
                } else {
                    print("Failed to create UIImage from data")
                    throw NSError(domain: "ImageViewer", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not create image from data"])
                }
            } catch {
                print("Error loading image: \(error.localizedDescription)")
                await MainActor.run {
                    self.loadError = error
                    self.isLoading = false
                }
            }
        }
    }
}

// Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    let sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.image = selectedImage
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
} 
