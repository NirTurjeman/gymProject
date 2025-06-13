import Alamofire
import SwiftyJSON
import Foundation

class SessionService {
    static let shared = SessionService()
    let api = APIClient.shared
    init(){}

    func getAllFreeEquipments(completion: @escaping (Result<[Equipment], Error>) -> Void) {
        api.request(path: "/freeEquesment", method: .get) { result in
            switch result {
            case .success(let json):
                let equipments = json.arrayValue.map { Equipment(json: $0) }
                completion(.success(equipments))
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(.failure(error))
            }
        }
    }

    func getAllSessionActivities(sessionId: String, userSystemId: String, userEmail: String, completion: @escaping (Result<[Activity], Error>) -> Void) {
        let path = "ambient-intelligence/objects/\(userSystemId)/\(sessionId)/children"
        let parameters: [String: String] = [
            "userEmail": userEmail,
            "userSystemID": userSystemId
        ]
        api.request(path: path, method: .get, parameters: parameters, encoding: URLEncoding.default) { result in
            switch result {
            case .success(let json):
                let activities = json.arrayValue.map { Activity(json: $0) }
                completion(.success(activities))
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(.failure(error))
            }
        }
    }
}
