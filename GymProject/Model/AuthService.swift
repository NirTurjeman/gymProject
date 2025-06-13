import Foundation
import Alamofire
class AuthService {
    static let shared = AuthService()
    let api = APIClient.shared
    init() {}
    func login(email: String, systemID: String, completion: @escaping (Result<Bool, AFError>) -> Void) {
        api.request(path: "ambient-intelligence/users/login/\(systemID)/\(email)", method: .get) { (result: Result<UserBoundary, AFError>) in
            switch result {
            case .success(let user):
                print("User logged in: \(user)")
                completion(.success(true))
            case .failure(let error):
                print("Login failed: \(error)")
                completion(.failure(error))
            }
        }
    }
}
