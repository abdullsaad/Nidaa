import SwiftUI

struct RobustImageViewer: View {
    let attachment: Attachment
    let onDismiss: () -> Void
    
    @State private var image: UIImage? = nil
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    
    // For zooming
    @State private var scale: CGFloat = 1.0
    @State private var offset = CGSize.zero
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            if isLoading {
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
            } else if let errorMessage = errorMessage {
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.yellow)
                    
                    Text("Error loading image")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(errorMessage)
                        .font(.body)
                        .foregroundColor(.gray)
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
            } else if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(scale)
                    .offset(offset)
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                scale = max(1, min(5, value.magnitude))
                            }
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                offset = value.translation
                            }
                            .onEnded { _ in
                                withAnimation {
                                    if scale <= 1 {
                                        offset = .zero
                                    }
                                }
                            }
                    )
                    .gesture(
                        TapGesture(count: 2)
                            .onEnded {
                                withAnimation {
                                    if scale > 1 {
                                        scale = 1
                                        offset = .zero
                                    } else {
                                        scale = 2
                                    }
                                }
                            }
                    )
            }
            
            // Close button
            VStack {
                HStack {
                    Spacer()
                    Button(action: onDismiss) {
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
            print("RobustImageViewer appeared for attachment: \(attachment.id)")
            loadImage()
        }
    }
    
    private func loadImage() {
        isLoading = true
        errorMessage = nil
        
        print("Starting to load image for attachment: \(attachment.id)")
        
        // Method 1: Try to load from ImageStore using imageID
        if let imageID = attachment.imageID {
            print("Trying to load image with ID: \(imageID)")
            if let storedImage = ImageStore.shared.getImage(id: imageID) {
                print("Successfully loaded image from ImageStore with ID: \(imageID)")
                self.image = storedImage
                self.isLoading = false
                return
            } else {
                print("Failed to load image from ImageStore with ID: \(imageID)")
            }
        } else {
            print("No imageID found in attachment")
        }
        
        // Method 2: Try to extract ID from URL and use ImageStore
        if let urlString = attachment.url.absoluteString.components(separatedBy: "://").last {
            print("Extracted ID from URL: \(urlString)")
            if let extractedImage = ImageStore.shared.getImage(id: urlString) {
                print("Successfully loaded image using ID extracted from URL: \(urlString)")
                self.image = extractedImage
                self.isLoading = false
                return
            } else {
                print("Failed to load image using ID extracted from URL: \(urlString)")
            }
        }
        
        // Method 3: Try loading from URL directly
        print("Trying to load image directly from URL: \(attachment.url)")
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let data = try Data(contentsOf: attachment.url)
                print("Successfully loaded \(data.count) bytes from URL")
                
                if let loadedImage = UIImage(data: data) {
                    print("Successfully created UIImage from URL data")
                    DispatchQueue.main.async {
                        self.image = loadedImage
                        self.isLoading = false
                    }
                } else {
                    print("Failed to create UIImage from URL data")
                    DispatchQueue.main.async {
                        self.errorMessage = "Could not create image from data"
                        self.isLoading = false
                    }
                }
            } catch {
                print("Error loading from URL: \(error.localizedDescription)")
                
                // Method 4: Last resort - try to use the image from the ImageAttachmentView
                DispatchQueue.main.async {
                    self.errorMessage = "Could not load image. Please try again."
                    self.isLoading = false
                }
            }
        }
    }
} 