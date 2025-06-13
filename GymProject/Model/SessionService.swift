import Alamofire
import Foundation

class SessionService {
    static let shared = SessionService()
    let api = APIClient.shared
    init(){}
    func getAllFreeEquipments(completion: @escaping (Result<[Equipment], Error>) -> Void) {
        api.request(path: "/freeEquesment", method: .get) { (result: Result<Data, AFError>) in
            switch result {
            case .success(let data):
                do {
                    let equipments = try JSONDecoder().decode([Equipment].self, from: data)
                    completion(.success(equipments))
                } catch {
                    print("Decoding error: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(.failure(error))
            }
        }
    }

    func getAllSessionActivities(sessionId: String, userSystemId: String, userEmail: String, completion: @escaping (Result<[Activity], Error>) -> Void) {
        let path = "/ambient-intelligence/objects/\(sessionId)/\(sessionId)/children"
        let parameters: [String: String] = [
            "userSystemId": userSystemId,
            "userEmail": userEmail
        ]
        api.request(path: path, method: .get, parameters: parameters) { (result: Result<Data, AFError>) in
            switch result {
            case .success(let data):
                do {
                    let activities = try JSONDecoder().decode([Activity].self, from: data)
                    completion(.success(activities))
                } catch {
                    print("Decoding error: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(.failure(error))
            }
        }
    }

}
