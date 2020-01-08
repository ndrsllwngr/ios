import Foundation
import Combine

class SignUpViewModel: ObservableObject {
    // input
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var passwordAgain = ""
    
    // output
    @Published var usernameMessage = ""
    @Published var emailMessage = ""
    @Published var passwordMessage = ""
    @Published var isValid = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    // USERNAME
    private var isUsernameValidPublisher: AnyPublisher<Bool, Never> {
        $username
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return input.count >= 3
        }
        .eraseToAnyPublisher()
    }
    
    // EMAIL
    private var isEmailEmptyPublisher: AnyPublisher<Bool, Never> {
        $email
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { email in
                return email == ""
        }
        .eraseToAnyPublisher()
    }
    
    private func isValidEmail(emailID:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailID)
    }
    
    private var isEmailValidEmailAddrPublisher: AnyPublisher<Bool, Never> {
        $email
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map {
                email in
                return self.isValidEmail(emailID: email)
        }
        .eraseToAnyPublisher()
    }
    
    enum EmailCheck {
        case valid
        case empty
        case notValid
    }
    
    private var isEmailValidPublisher: AnyPublisher<EmailCheck, Never> {
        Publishers.CombineLatest(isEmailEmptyPublisher, isEmailValidEmailAddrPublisher)
            .map { emailIsEmpty, emailIsValid in
                if (emailIsEmpty) {
                    return .empty
                }
                else if (!emailIsValid) {
                    return .notValid
                }
                else {
                    return .valid
                }
        }
        .eraseToAnyPublisher()
    }
    
    // PASSWORD
    private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                return password == ""
        }
        .eraseToAnyPublisher()
    }
    
    private var isPasswordMinLengthPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                return password.count >= 6
        }
        .eraseToAnyPublisher()
    }
    
    private var arePasswordsEqualPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($password, $passwordAgain)
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .map { password, passwordAgain in
                return password == passwordAgain
        }
        .eraseToAnyPublisher()
    }
    
    enum PasswordCheck {
        case valid
        case notLongEnough
        case empty
        case noMatch
    }
    
    private var isPasswordValidPublisher: AnyPublisher<PasswordCheck, Never> {
        Publishers.CombineLatest3(isPasswordEmptyPublisher, isPasswordMinLengthPublisher, arePasswordsEqualPublisher)
            .map { passwordIsEmpty, passwordIsMinLength, passwordsAreEqual in
                if (passwordIsEmpty) {
                    return .empty
                }
                else if (!passwordIsMinLength) {
                    return .notLongEnough
                }
                else if (!passwordsAreEqual) {
                    return .noMatch
                }
                else {
                    return .valid
                }
        }
        .eraseToAnyPublisher()
    }
    
    // TOTAL VALID CHECK
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(isUsernameValidPublisher, isEmailValidPublisher, isPasswordValidPublisher)
            .map { userNameIsValid, emailIsValid, passwordIsValid in
                return userNameIsValid && (emailIsValid == .valid) && (passwordIsValid == .valid)
        }
        .eraseToAnyPublisher()
    }
    
    init() {
        isUsernameValidPublisher
            .receive(on: RunLoop.main)
            .map { valid in
                valid ? "" : "User name must at least have 3 characters"
        }
        .assign(to: \.usernameMessage, on: self)
        .store(in: &cancellableSet)
        
        isEmailValidPublisher
            .receive(on: RunLoop.main)
            .map { emailCheck in
                switch emailCheck {
                case .empty:
                    return "Email must not be empty"
                case .notValid:
                    return "Email must be a valid email address"
                default:
                    return ""
                }
        }
        .assign(to: \.emailMessage, on: self)
        .store(in: &cancellableSet)
        
        isPasswordValidPublisher
            .receive(on: RunLoop.main)
            .map { passwordCheck in
                switch passwordCheck {
                case .empty:
                    return "Password must not be empty"
                case .notLongEnough:
                    return "Password must be at least 6 characters long"
                case .noMatch:
                    return "Passwords don't match"
                default:
                    return ""
                }
        }
        .assign(to: \.passwordMessage, on: self)
        .store(in: &cancellableSet)
        
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
    }
    
}
