import SwiftUI
import CoreLocation
import SwiftData

struct EmergencyResponseView: View {
    let alert: EmergencyAlert
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject private var userManager = UserManager.shared
    @StateObject private var messageManager = MessageManager.shared
    
    @State private var responseText = ""
    @State private var isLoading = false
    @State private var showingConfirmation = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Alert details
                VStack(spacing: 16) {
                    // Alert icon
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.red)
                    
                    // Alert message
                    Text(alert.details)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    
                    // Alert location
                    if let location = alert.location {
                        Text("Location: \(location)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Alert sender
                    if let sender = getSender() {
                        Text("From: \(sender.fullName)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Alert time
                    Text("Sent: \(alert.timestamp, formatter: dateFormatter)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(12)
                .padding()
                
                Divider()
                
                // Response section
                VStack(spacing: 16) {
                    Text("Your Response")
                        .font(.headline)
                    
                    TextEditor(text: $responseText)
                        .frame(minHeight: 100)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                    HStack {
                        Button("Cancel") {
                            dismiss()
                        }
                        .buttonStyle(.bordered)
                        
                        Spacer()
                        
                        Button("Send Response") {
                            sendResponse()
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(responseText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
                .padding()
            }
            .navigationTitle("Emergency Alert")
            .navigationBarTitleDisplayMode(.inline)
            .disabled(isLoading)
            .overlay {
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.2))
                }
            }
            .alert("Response Sent", isPresented: $showingConfirmation) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your response has been sent to the alert sender.")
            }
        }
    }
    
    private func getSender() -> User? {
        do {
            // Fetch all users first
            let users = try modelContext.fetch(FetchDescriptor<User>())
            
            // Then filter manually
            return users.first { user in
                user.id == alert.initiatorId
            }
        } catch {
            print("Error fetching alert sender: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func sendResponse() {
        isLoading = true
        
        // Get current user
        guard let currentUser = userManager.getCurrentUser() else {
            isLoading = false
            return
        }
        
        // Create response message
        let message = Message(
            senderId: currentUser.id,
            recipientId: alert.initiatorId,
            content: "ALERT RESPONSE: \(responseText)",
            attachments: [],
            status: .sent,
            timestamp: Date()
        )
        
        // Save to database
        modelContext.insert(message)
        
        do {
            try modelContext.save()
            
            // Show confirmation
            isLoading = false
            showingConfirmation = true
        } catch {
            print("Error sending response: \(error.localizedDescription)")
            isLoading = false
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
}

struct EmergencyAlertBadge: View {
    let alert: EmergencyAlert
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(alertColor)
                .frame(width: 8, height: 8)
            
            Text(alert.details)
                .font(.headline)
        }
        .padding()
        .background(alertColor.opacity(0.1))
        .cornerRadius(10)
    }
    
    private var alertColor: Color {
        switch alert.type {
        case .medical:
            return .red
        case .security:
            return .blue
        case .critical:
            return .orange
        }
    }
}

// Add other supporting views... 