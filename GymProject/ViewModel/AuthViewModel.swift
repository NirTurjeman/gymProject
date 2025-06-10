import Foundation

class AuthViewModel {
    private let authService: AuthService

    init(authService: AuthService = .shared) {
        self.authService = authService
    }

    func checkLogIn(email: String, systemID: String, completion: @escaping (Bool) -> Void) {
        authService.login(email: email, systemID: systemID) { result in
            switch result {
            case .success(let data):
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
}
