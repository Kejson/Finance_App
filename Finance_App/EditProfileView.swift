import SwiftUI
import Firebase
import FirebaseFirestore

struct EditProfileView: View {
    // Declare userEmail as a @State property for binding
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var bio: String = ""
    var userEmail: String // This should be a parameter for the initializer
    @State private var errorMessage: String?
    @State private var successMessage: String?

    // Initializer to accept userEmail
    init(userEmail: String) {
        self.userEmail = userEmail
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Edit Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                // Name input field
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // Age input field
                TextField("Age", text: $age)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // Bio input field
                TextField("Bio", text: $bio)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // Save button
                Button(action: saveProfile) {
                    Text("Save")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()

                // Display error or success messages
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .bold()
                }

                if let successMessage = successMessage {
                    Text(successMessage)
                        .foregroundColor(.green)
                        .bold()
                }
            }
            .padding()
            .navigationBarBackButtonHidden(false)
            .onAppear(perform: loadProfileData)
        }
    }

    func loadProfileData() {
        // Load user data from Firestore when the view appears
        let db = Firestore.firestore()
        db.collection("users").document(userEmail).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                name = data?["name"] as? String ?? ""
                age = data?["age"] as? String ?? ""
                bio = data?["bio"] as? String ?? ""
            } else {
                print("Document does not exist")
            }
        }
    }

    func saveProfile() {
        // Save updated user data to Firestore
        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "name": name,
            "age": age,
            "bio": bio
        ]

        db.collection("users").document(userEmail).setData(userData) { error in
            if let error = error {
                errorMessage = "Failed to save profile: \(error.localizedDescription)"
                successMessage = nil
            } else {
                successMessage = "Profile updated successfully!"
                errorMessage = nil
            }
        }
    }
}

#Preview {
    EditProfileView(userEmail: "test@example.com")
}
