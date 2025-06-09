import Foundation
import Alamofire

class AuthService {
    static let shared = AuthService()
    let api = APIClient.shared
    private init() {
        
    }
    
    func login(email: String, password: String, completion: @escaping (Result<Bool, AFError>) -> Void) {
        api.request(path: "/login", method: .get) { (result: Result<Data, AFError>) in
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(let error):
                completion(.success(false))
            }
        }
    }
}
