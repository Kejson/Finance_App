import SwiftUI
import FirebaseFirestore

struct ViewExpensesView: View {
    var userId: String
    @State private var expenses: [Expense] = []
    @State private var showDeleteAlert = false // To show confirmation alert
    @State private var expenseToDelete: Expense? // Track the selected expense for deletion

    var body: some View {
        List {
            ForEach(expenses) { expense in
                HStack {
                    VStack(alignment: .leading) {
                        Text(expense.category)
                        if let note = expense.note {
                            Text("Note: \(note)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Text("Date: \(expense.date, formatter: dateFormatter)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text("\(Double(expense.amount), specifier: "%.2f")")
                        .font(.headline)
                }
                .swipeActions { // Swipe action to delete
                    Button(role: .destructive) {
                        showDeleteAlert = true
                        expenseToDelete = expense
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            .onDelete(perform: deleteExpenses) // For built-in deletion using list editing
        }
        .navigationTitle("Your Expenses")
        .onAppear(perform: loadExpenses)
        .alert(isPresented: $showDeleteAlert) { // Show confirmation alert
            Alert(
                title: Text("Delete Expense"),
                message: Text("Are you sure you want to delete this expense?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let expense = expenseToDelete {
                        deleteExpense(expense)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }

    private func loadExpenses() {
        let db = Firestore.firestore()
        db.collection("Expenses").whereField("userId", isEqualTo: userId).getDocuments { snapshot, error in
            if let error = error {
                print("Error loading expenses: \(error.localizedDescription)")
                return
            }
            expenses = snapshot?.documents.compactMap { doc in
                Expense(id: doc.documentID, data: doc.data())
            } ?? []
        }
    }

    private func deleteExpense(_ expense: Expense) {
        let db = Firestore.firestore()
        db.collection("Expenses").document(expense.id).delete { error in
            if let error = error {
                print("Error deleting expense: \(error.localizedDescription)")
            } else {
                // Remove from local list if deletion succeeds
                expenses.removeAll { $0.id == expense.id }
            }
        }
    }

    private func deleteExpenses(at offsets: IndexSet) {
        for index in offsets {
            let expense = expenses[index]
            deleteExpense(expense)
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()
