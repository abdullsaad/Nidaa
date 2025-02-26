import SwiftUI

struct DirectImageViewer: View {
    let url: URL
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
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
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
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .offset(offset)
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                scale = value.magnitude
                            }
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                offset = value.translation
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
            loadImage()
        }
    }
    
    private func loadImage() {
        isLoading = true
        errorMessage = nil
        
        // Print the URL for debugging
        print("Attempting to load image from: \(url.absoluteString)")
        
        // Use a simple synchronous approach for reliability
        if let data = try? Data(contentsOf: url),
           let loadedImage = UIImage(data: data) {
            print("Successfully loaded image: \(data.count) bytes")
            self.image = loadedImage
            self.isLoading = false
        } else {
            print("Failed to load image from: \(url.absoluteString)")
            self.errorMessage = "Could not load image from storage"
            self.isLoading = false
        }
    }
} 