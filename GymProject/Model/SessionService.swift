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

}
