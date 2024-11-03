import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode // Used to dismiss the view
    @Binding var isLoggedIn: Bool // Binding to track the logged-in status

    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Button(action: {
                // Attempt to log out
                do {
                    try Auth.auth().signOut()
                    print("User logged out")
                    isLoggedIn = false // Update the login state
                    presentationMode.wrappedValue.dismiss() // Dismiss the settings view
                } catch {
                    print("Error signing out: \(error.localizedDescription)")
                }
            }) {
                Text("Log Out")
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding(.top, 50)

            Spacer()
        }
    }
}
