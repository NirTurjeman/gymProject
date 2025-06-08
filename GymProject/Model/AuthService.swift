import Alamofire
import Foundation

class AuthService {
    static let shared = AuthService()
        private init() {}
    
    
    func login(email: String, password: String, completion: @escaping (Result<Data?, AFError>) -> Void) {
        
        let url = "\(AlamofireClient.shared.baseURL)/login/\(password)/\(email)"
        
        AlamofireClient.shared.session.request(url, method: .get, encoding: JSONEncoding.default)
            .validate()
            .response { response in
                completion(response.result)
            }
    }
}
