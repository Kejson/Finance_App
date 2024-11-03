import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessages: String? = nil
    @State private var isUserRegistered = false
    @State private var userEmail: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .foregroundStyle(.linearGradient(colors: [.red, .white], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 980, height: 500)
                    .rotationEffect(.degrees(140))
                    .offset(y: -350)
                
                VStack(spacing: 20) {
                    Text("Welcome")
                        .foregroundColor(.white)
                        .font(.system(size: 45, weight: .bold, design: .rounded))
                        .offset(x: -85, y: -100)
                    
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
                        register() // Call the register function
                    } label: {
                        Text("Sign up")
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
                    
                    NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
                        Text("Already have an account? Login")
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1))
                    }
                    .offset(y: 100)
                }
                .frame(width: 400)
                
                // Navigation link for home page with the user email
                NavigationLink(destination: HomePage(userEmail: userEmail).navigationBarBackButtonHidden(true), isActive: $isUserRegistered) {
                    EmptyView()
                }
            }
            .ignoresSafeArea()
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                let errorCode = AuthErrorCode(rawValue: error._code)
                
                switch errorCode {
                case .emailAlreadyInUse:
                    self.errorMessages = "The email is already registered. Please try logging in."
                case .invalidEmail:
                    self.errorMessages = "Invalid email format"
                case .weakPassword:
                    self.errorMessages = "Password is too weak"
                    
                default:
                    self.errorMessages = error.localizedDescription
                }
            } else {
                self.errorMessages = nil
                self.isUserRegistered = true
                self.userEmail = email // Set user email for homePage
            }
        }
    }
}

#Preview {
    ContentView()
}

extension View {
    func placeholder<Content: View>(
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
