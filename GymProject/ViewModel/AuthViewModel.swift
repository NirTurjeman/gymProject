import Foundation

class AuthViewModel {
    private let authService: AuthService

    init(authService: AuthService = .shared) {
        self.authService = authService
    }

    func checkLogIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        authService.login(email: email, password: password) { result in
            switch result {
            case .success(let data):
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
}
