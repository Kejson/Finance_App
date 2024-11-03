import SwiftUI
import Firebase
import FirebaseFirestore

struct MyProfileView: View {
    var userEmail: String
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var bio: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("My Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                Text("Name: \(name)")
                    .font(.title2)
                    .padding()

                Text("Age: \(age)")
                    .font(.title2)
                    .padding()

                Text("Bio: \(bio)")
                    .font(.title2)
                    .padding()

                // Navigation Link to EditProfileView
                NavigationLink(destination: EditProfileView(userEmail: userEmail)) {
                    Text("Edit Profile")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                }
            }
            .onAppear(perform: loadProfileData)
            .navigationBarBackButtonHidden(false)
        }
    }

    func loadProfileData() {
        // Load user data from Firestore when the view appears
        let db = Firestore.firestore()
        db.collection("users").document(userEmail).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                name = data?["name"] as? String ?? "No Name"
                age = data?["age"] as? String ?? "No Age"
                bio = data?["bio"] as? String ?? "No Bio"
            } else {
                print("Document does not exist")
            }
        }
    }
}

#Preview {
    MyProfileView(userEmail: "test@example.com")
}
