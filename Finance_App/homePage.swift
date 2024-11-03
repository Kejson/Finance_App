import SwiftUI

struct HomePage: View {
    var userEmail: String
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String?
    @State private var isLoggedIn: Bool = true // Track login state
    @State private var isUserLoggedOut: Bool = false // Track if user is logged out

    var body: some View {
        NavigationStack {
            VStack {
                if isUserLoggedOut {
                    // Show the ContentView when the user is logged out
                    ContentView() // Replace with your actual ContentView initializer
                } else {
                    VStack {
                        Text("Welcome, \(userEmail)!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding()

                        Spacer() // Pushes content to the top

                        // Buttons to navigate to different views
                        VStack(spacing: 20) {
                            // Add Expense button
                            NavigationLink(destination: AddExpenseView(userId: userEmail)) {
                                Text("Add Expense")
                                    .foregroundColor(.white)
                                    .frame(width: 200, height: 50)
                                    .background(Color.green)
                                    .cornerRadius(10)
                            }

                            // View Expenses button
                            NavigationLink(destination: ViewExpensesView(userId: userEmail)) {
                                Text("View Expenses")
                                    .foregroundColor(.white)
                                    .frame(width: 200, height: 50)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.bottom, 50) // Space before the bottom navigation bar

                        // Bottom navigation bar
                        HStack {
                            // My Profile button
                            NavigationLink(destination: MyProfileView(userEmail: userEmail)) {
                                VStack {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                    Text("My Profile")
                                        .font(.caption)
                                }
                            }
                            .padding()

                            Spacer() // Spacing between buttons

                            // Edit Profile button
                            NavigationLink(destination: EditProfileView(userEmail: userEmail)) {
                                VStack {
                                    Image(systemName: "pencil")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                    Text("Edit Profile")
                                        .font(.caption)
                                }
                            }
                            .padding()

                            Spacer() // Spacing between buttons

                            // Settings button
                            NavigationLink(destination: SettingsView(isLoggedIn: $isLoggedIn)) {
                                VStack {
                                    Image(systemName: "gear")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                    Text("Settings")
                                        .font(.caption)
                                }
                            }
                            .padding()
                        }
                        .padding()
                        .background(Color(UIColor.systemGray6)) // Background color for the navigation bar
                    }
                    .alert(isPresented: $showErrorAlert) {
                        Alert(title: Text("Error"), message: Text(errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
                    }
                    .onChange(of: isLoggedIn) { loggedIn in
                        if !loggedIn {
                            isUserLoggedOut = true // Set to true when user logs out
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomePage(userEmail: "test@example.com")
}
