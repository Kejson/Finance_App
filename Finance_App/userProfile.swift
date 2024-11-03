import Foundation

struct UserProfile: Codable, Identifiable {
    var id: String
    var name: String
    var age: String
    var bio: String
}
