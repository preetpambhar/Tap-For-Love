import SwiftUI

struct QRCodeView: View {
    let url: URL
    let quizTitle: String
    @Environment(\.dismiss) var dismiss
    @State private var qrImage: UIImage?
    @State private var showCopiedToast = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.purple.opacity(0.1), Color.pink.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Text("Your Quiz is Ready! 🎉")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(quizTitle)
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    VStack(spacing: 20) {
                        if let qrImage = qrImage {
                            Image(uiImage: qrImage)
                                .interpolation(.none)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250, height: 250)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(20)
                                .shadow(color: .purple.opacity(0.2), radius: 15, x: 0, y: 8)
                        } else {
                            ProgressView()
                                .frame(width: 250, height: 250)
                        }
                        
                        Text("Scan with any camera app")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 12) {
                        Button(action: copyLink) {
                            HStack {
                                Image(systemName: showCopiedToast ? "checkmark" : "doc.on.doc")
                                    .font(.system(size: 16, weight: .semibold))
                                Text(showCopiedToast ? "Copied!" : "Copy Link")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        
                        ShareLink(item: url, subject: Text("Take my quiz!"), message: Text("I made a quiz for you 💖")) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Share via...")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [.purple, .pink],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        
                        Button(action: saveQRCode) {
                            HStack {
                                Image(systemName: "square.and.arrow.down")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Save QR Code")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white)
                            .foregroundColor(.purple)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.purple, lineWidth: 2)
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Share Quiz")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            generateQRCode()
        }
    }
    
    private func generateQRCode() {
        DispatchQueue.global(qos: .userInitiated).async {
            let qrImage = QRCodeGenerator.generate(from: url.absoluteString)
            DispatchQueue.main.async {
                self.qrImage = qrImage
            }
        }
    }
    
    private func copyLink() {
        UIPasteboard.general.url = url
        
        withAnimation {
            showCopiedToast = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showCopiedToast = false
            }
        }
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    private func saveQRCode() {
        guard let qrImage = qrImage else { return }
        
        UIImageWriteToSavedPhotosAlbum(qrImage, nil, nil, nil)
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

// Preview
#Preview {
    QRCodeView(
        url: URL(string: "https://tap-for-love-web.vercel.app/?q=test123")!,
        quizTitle: "How Well Do You Know Me? 💘"
    )
}
