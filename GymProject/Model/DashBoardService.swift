import Alamofire
import Foundation

class DashBoardService {
    static let shared = DashBoardService()
    let api = APIClient.shared
     init() {}

    func getAllSessionHistory(userSystemID: String, userEmail: String, size: Int = 100, page: Int = 0, completion: @escaping (Result<[Session], AFError>) -> Void) {
        
        let queryParams: Parameters = [
            "userSystemID": userSystemID,
            "userEmail": userEmail,
            "size": size,
            "page": page
        ]

        api.getDecodable(path: "/ambient-intelligence/objects/search/byType/session", parameters: queryParams) { (result: Result<[Session], AFError>) in
            switch result {
            case .success(let sessions):
                print("Received \(sessions.count) sessions for user")
                completion(.success(sessions))
            case .failure(let error):
                print("Error fetching sessions: \(error)")
                completion(.failure(error))
            }
        }
    }
}
