import Alamofire
import Foundation

class DashBoardService {
    static let shared = DashBoardService()
    let api = APIClient.shared
    private init() {}

    func getAllSessionHistory(parentSystemID: String, parentObjectId: String, userSystemId: String, userEmail: String = "", completion: @escaping (Result<[Session], AFError>) -> Void) {
        api.request(path: "()", method: .get) { (result: Result<Data, AFError>) in
            switch result {
            case .success(let data):
                do {
                    let sessions = try JSONDecoder().decode([Session].self, from: data)
                    completion(.success(sessions))
                } catch {
                    completion(.success([])) 
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
