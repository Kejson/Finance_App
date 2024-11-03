import SwiftUI
import FirebaseFirestore

struct AddExpenseView: View {
    var userId: String
    @State private var amount: String = ""
    @State private var category: String = ""
    @State private var note: String = ""
    @State private var date: Date = Date()
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String?

    var body: some View {
        Form {
            Section(header: Text("Add Expense")) {
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)

                TextField("Category", text: $category)

                TextField("Note", text: $note)

                DatePicker("Date", selection: $date, displayedComponents: .date)
            }

            Button("Submit") {
                if let amountDouble = Double(amount) {
                    let newExpense = Expense(userId: userId, amount: Int(amountDouble), category: category, note: note.isEmpty ? nil : note, date: date)
                    addExpense(expense: newExpense)
                } else {
                    errorMessage = "Please enter a valid amount."
                    showErrorAlert = true
                }
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
            }
        }
        .navigationTitle("New Expense")
    }

    private func addExpense(expense: Expense) {
        let db = Firestore.firestore()
        db.collection("Expenses").addDocument(data: expense.toDictionary()) { error in
            if let error = error {
                print("Error adding expense: \(error.localizedDescription)")
                errorMessage = "Failed to save expense."
                showErrorAlert = true
            } else {
                // Reset fields after submission
                amount = ""
                category = ""
                note = ""
                date = Date()
            }
        }
    }
}
