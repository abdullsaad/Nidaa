import SwiftUI

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            TabView {
                OnboardingPage(
                    title: "Welcome to Nidaa",
                    description: "Your medical team communication platform",
                    imageName: "doc.text.image"
                )
                
                OnboardingPage(
                    title: "Team Communication",
                    description: "Stay connected with your medical team in real-time",
                    imageName: "bubble.left.and.bubble.right.fill"
                )
                
                OnboardingPage(
                    title: "Patient Care",
                    description: "Manage patient care efficiently and effectively",
                    imageName: "heart.text.square.fill"
                )
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Get Started") {
                        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                        dismiss()
                    }
                }
            }
        }
    }
}

struct OnboardingPage: View {
    let title: String
    let description: String
    let imageName: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: imageName)
                .font(.system(size: 80))
                .foregroundColor(.accentColor)
            
            Text(title)
                .font(.title)
                .bold()
            
            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding()
    }
} 