import SwiftUI
import FirebaseAuth
import Firebase

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessages: String? = nil
    @State private var isLoggedIn = false
    @State private var userEmail: String = ""
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .foregroundStyle(.linearGradient(colors: [.red, .white], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 980, height: 500)
                    .rotationEffect(.degrees(140))
                    .offset(y: -350)
                
                VStack(spacing: 20) {
                    Text("Login")
                        .foregroundColor(.white)
                        .font(.system(size: 45, weight: .bold, design: .rounded))
                        .offset(x: -115, y: -100)
                    
                    TextField("", text: $email)
                        .textFieldStyle(.plain)
                        .foregroundColor(.white)
                        .bold()
                        .padding(.leading, 25)
                        .font(.system(size: 20))
                        .placeholder(shouldShow: email.isEmpty) {
                            Text("Email")
                                .offset(x: 25, y: 0)
                                .foregroundColor(.white)
                                .bold()
                                .font(.system(size: 24))
                        }
                    
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundColor(.white)
                    
                    SecureField("", text: $password)
                        .textFieldStyle(.plain)
                        .foregroundColor(.white)
                        .padding(.leading, 25)
                        .font(.system(size: 20))
                        .placeholder(shouldShow: password.isEmpty) {
                            Text("Password")
                                .foregroundColor(.white)
                                .bold()
                                .offset(x: 25, y: 0)
                                .font(.system(size: 24))
                        }
                    
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundColor(.white)
                    
                    Button {
                        login() // Call the login function
                    } label: {
                        Text("Log in")
                            .frame(width: 220, height: 45)
                            .foregroundColor(.black)
                            .background(
                                RoundedRectangle(cornerRadius: 50)
                                    .fill(.linearGradient(colors: [.red, .white], startPoint: .topLeading, endPoint: .trailing))
                            )
                            .offset(y: 35)
                            .bold()
                    }
                    
                    if let errorMessage = errorMessages {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .bold()
                            .padding()
                            .offset(y: 40)
                    }
                    
                    NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) { // Navigate to ContentView for sign-up
                        Text("Don't have an account? Sign up")
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1))
                    }
                    .offset(y: 100)
                }
                .frame(width: 400)
                
                // Navigation after successful login
                NavigationLink(destination: HomePage(userEmail: userEmail).navigationBarBackButtonHidden(true), isActive: $isLoggedIn) {
                    EmptyView()
                }
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                let errorCode = AuthErrorCode(rawValue: error._code)
                
                switch errorCode {
                case .userNotFound:
                    self.errorMessages = "No user found with this email. Please register."
                case .wrongPassword:
                    self.errorMessages = "Incorrect password. Please try again."
                case .invalidEmail:
                    self.errorMessages = "Invalid email format. Please check and try again."
                default:
                    self.errorMessages = error.localizedDescription
                }
            } else {
                self.errorMessages = nil
                self.isLoggedIn = true // Navigate to HomePage
                self.userEmail = email
            }
        }
    }
}

#Preview {
    LoginView()
}

extension View {
    func placeholder1<Content: View>(
        shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
