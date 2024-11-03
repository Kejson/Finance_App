import Foundation
import FirebaseFirestore

struct Expense: Identifiable {
    var id: String // Firestore document ID
    var userId: String
    var amount: Int // Change from Double to Int
    var category: String
    var note: String?
    var date: Date

    // Initializer for creating a new Expense
    init(id: String = UUID().uuidString, userId: String, amount: Int, category: String, note: String? = nil, date: Date = Date()) {
        self.id = id
        self.userId = userId
        self.amount = amount
        self.category = category
        self.note = note
        self.date = date
    }

    // Create a dictionary representation for Firestore
    func toDictionary() -> [String: Any] {
        return [
            "userId": userId,
            "amount": amount, // This will now be an Int
            "category": category,
            "note": note as Any,
            "date": Timestamp(date: date)
        ]
    }

    // Initialize from Firestore data
    init?(id: String, data: [String: Any]) {
        guard let userId = data["userId"] as? String,
              let amount = data["amount"] as? Int, // Adjust here for Int
              let category = data["category"] as? String,
              let date = (data["date"] as? Timestamp)?.dateValue() else {
            return nil
        }
        self.id = id
        self.userId = userId
        self.amount = amount
        self.category = category
        self.note = data["note"] as? String
        self.date = date
    }
}
