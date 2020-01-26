import Foundation
import Combine

class ProfileSettingsViewModel: ObservableObject {
    // INPUT
    // 1)
    @Published var newUserName: String = ""
    //2)
    @Published var newEmail: String = ""
    @Published var currentPasswordChangeEmail: String = ""
    // 3)
    @Published var newPassword: String = ""
    @Published var currentPasswordChangePassword: String = ""
    // 4)
    @Published var currentPasswordDeleteAccount: String = ""
    
    // OUTPUT
    // 1)
    @Published var usernameMessage = ""
    @Published var isValidUsername = false
    // 2)
    @Published var emailMessage = ""
    @Published var isValidEmail = false
    // 3)
    @Published var passwordMessage = ""
    @Published var isValidPassword = false
    // 4)
    @Published var deleteAccMessage = ""
    @Published var isValidDeleteAcc = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    // 1) USERNAME
    private var isUsernameEmptyPublisher: AnyPublisher<Bool, Never> {
        $newUserName
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { username in
                return username == ""
        }
        .eraseToAnyPublisher()
    }
    
    private var isUsernameMinLengthPublisher: AnyPublisher<Bool, Never> {
        $newUserName
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { username in
                return username.count >= 3
        }
        .eraseToAnyPublisher()
    }
    
    enum UsernameCheck {
        case valid
        case notLongEnough
        case empty
    }
    
    private var isUsernameValidPublisher: AnyPublisher<UsernameCheck, Never> {
        Publishers.CombineLatest(isUsernameEmptyPublisher, isUsernameMinLengthPublisher)
            .map { usernameIsEmpty, usernameIsMinLength in
                if (usernameIsEmpty) {
                    return .empty
                }
                else if (!usernameIsMinLength) {
                    return .notLongEnough
                }
                else {
                    return .valid
                }
        }
        .eraseToAnyPublisher()
    }
    
    // 2) EMAIL
    private var isEmailEmptyPublisher: AnyPublisher<Bool, Never> {
        $newEmail
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
        $newEmail
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
    
    // 2) PASSWORD of EMAIL CHANGE
    private var isPasswordOfEmailEmptyPublisher: AnyPublisher<Bool, Never> {
        $currentPasswordChangeEmail
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                return password == ""
        }
        .eraseToAnyPublisher()
    }
    
    private var isPasswordOfEmailMinLengthPublisher: AnyPublisher<Bool, Never> {
        $currentPasswordChangeEmail
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                return password.count >= 6
        }
        .eraseToAnyPublisher()
    }
    
    enum PasswordOfEmailCheck {
        case valid
        case notLongEnough
        case empty
    }
    
    private var isPasswordOfEmailValidPublisher: AnyPublisher<PasswordOfEmailCheck, Never> {
        Publishers.CombineLatest(isPasswordOfEmailEmptyPublisher, isPasswordOfEmailMinLengthPublisher)
            .map { passwordIsEmpty, passwordIsMinLength in
                if (passwordIsEmpty) {
                    return .empty
                }
                else if (!passwordIsMinLength) {
                    return .notLongEnough
                }
                else {
                    return .valid
                }
        }
        .eraseToAnyPublisher()
    }
    
    private var totalValidityCheckChangeEmail: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isEmailValidPublisher, isPasswordOfEmailValidPublisher)
            .map { emailIsValid, pwdIsValid in
                return emailIsValid == .valid && pwdIsValid == .valid
        }
        .eraseToAnyPublisher()
    }
    
    // 3) PASSWORD CHANGE
    private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
        $newPassword
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                return password == ""
        }
        .eraseToAnyPublisher()
    }
    
    private var isPasswordMinLengthPublisher: AnyPublisher<Bool, Never> {
        $newPassword
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                return password.count >= 6
        }
        .eraseToAnyPublisher()
    }
    
    private var arePasswordsEqualPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($newPassword, $currentPasswordChangePassword)
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .map { password, currentPassword in
                return password == currentPassword
        }
        .eraseToAnyPublisher()
    }
    
    enum PasswordCheck {
        case valid
        case notLongEnough
        case empty
        case match
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
                else if (passwordsAreEqual) {
                    return .match
                }
                else {
                    return .valid
                }
        }
        .eraseToAnyPublisher()
    }
    
    // 4) DELETE ACCOUNT
    private var isPasswordOfDeleteAccountEmptyPublisher: AnyPublisher<Bool, Never> {
        $currentPasswordDeleteAccount
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                return password == ""
        }
        .eraseToAnyPublisher()
    }
    
    private var isPasswordOfDeleteAccountMinLengthPublisher: AnyPublisher<Bool, Never> {
        $currentPasswordDeleteAccount
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                return password.count >= 6
        }
        .eraseToAnyPublisher()
    }
    
    enum PasswordOfDeleteAccountCheck {
        case valid
        case notLongEnough
        case empty
    }
    
    private var isPasswordOfDeleteAccountValidPublisher: AnyPublisher<PasswordOfDeleteAccountCheck, Never> {
        Publishers.CombineLatest(isPasswordOfDeleteAccountEmptyPublisher, isPasswordOfDeleteAccountMinLengthPublisher)
            .map { passwordIsEmpty, passwordIsMinLength in
                if (passwordIsEmpty) {
                    return .empty
                }
                else if (!passwordIsMinLength) {
                    return .notLongEnough
                }
                else {
                    return .valid
                }
        }
        .eraseToAnyPublisher()
    }
    
    
    init() {
        // 1)
        isUsernameValidPublisher
            .receive(on: RunLoop.main)
            .map { usernameCheck in
                switch usernameCheck {
                case .empty:
                    return ""
                case .notLongEnough:
                    return "Username must at least have 3 characters"
                default:
                    return ""
                }
        }
        .assign(to: \.usernameMessage, on: self)
        .store(in: &cancellableSet)
        
        isUsernameValidPublisher
            .receive(on: RunLoop.main)
            .map { usernameCheck in
                switch usernameCheck {
                case .valid:
                    return true
                default:
                    return false
                }
        }
        .assign(to: \.isValidUsername, on: self)
        .store(in: &cancellableSet)
        
        // 2)
        isEmailValidPublisher
            .receive(on: RunLoop.main)
            .map { emailCheck in
                switch emailCheck {
                case .empty:
                    return ""
                case .notValid:
                    return "Email must be a valid email address"
                default:
                    return ""
                }
        }
        .assign(to: \.emailMessage, on: self)
        .store(in: &cancellableSet)
        
        totalValidityCheckChangeEmail
            .receive(on: RunLoop.main)
            .map { emailAndPwdCheck in
                return emailAndPwdCheck
        }
        .assign(to: \.isValidEmail, on: self)
        .store(in: &cancellableSet)
        
        // 3)
        isPasswordValidPublisher
            .receive(on: RunLoop.main)
            .map { passwordCheck in
                switch passwordCheck {
                case .empty:
                    return ""
                //                    return "Password must not be empty"
                case .notLongEnough:
                    return "Password must be at least 6 characters long"
                case .match:
                    return "New password is old password"
                default:
                    return ""
                }
        }
        .assign(to: \.passwordMessage, on: self)
        .store(in: &cancellableSet)
        
        isPasswordValidPublisher
            .receive(on: RunLoop.main)
            .map { pwdCheck in
                switch pwdCheck {
                case .valid:
                    return true
                default:
                    return false
                }
        }
        .assign(to: \.isValidPassword, on: self)
        .store(in: &cancellableSet)
        
        // 4)
        isPasswordOfDeleteAccountValidPublisher
            .receive(on: RunLoop.main)
            .map { passwordCheck in
                switch passwordCheck {
                case .empty:
                    return ""
                //                    return "Password must not be empty"
                case .notLongEnough:
                    return "Password must be at least 6 characters long"
                default:
                    return ""
                }
        }
        .assign(to: \.deleteAccMessage, on: self)
        .store(in: &cancellableSet)
        
        isPasswordOfDeleteAccountValidPublisher
            .receive(on: RunLoop.main)
            .map { pwdCheck in
                switch pwdCheck {
                case .valid:
                    return true
                default:
                    return false
                }
        }
        .assign(to: \.isValidDeleteAcc, on: self)
        .store(in: &cancellableSet)
    }
}
