import FirebaseFirestore

class FirestoreManager: ObservableObject {
    private var db = Firestore.firestore()

    func fetchUserProfile(email: String, completion: @escaping (UserProfile?) -> Void) {
        db.collection("users").document(email).getDocument { document, error in
            guard let document = document, document.exists, error == nil else {
                completion(nil)
                return
            }
            let profile = try? document.data(as: UserProfile.self)
            completion(profile)
        }
    }

    func updateUserProfile(profile: UserProfile) {
        do {
            try db.collection("users").document(profile.id).setData(from: profile)
        } catch {
            print("Failed to update profile: \(error.localizedDescription)")
        }
    }
}
