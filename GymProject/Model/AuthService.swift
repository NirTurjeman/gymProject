import Foundation
import Alamofire

class AuthService {
    static let shared = AuthService()
    let api = APIClient.shared
    init() {}
    func login(email: String, systemID: String, completion: @escaping (Result<Bool, AFError>) -> Void) {
        api.request(path: "/ambient-intelligence/users/login/\(systemID)/\(email)", method: .get) { (result: Result<Data, AFError>) in
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(_):
                completion(.success(false))
            }
        }
    }
}
