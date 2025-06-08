import Foundation
import Alamofire

class DashboardViewModel {
    private var sessionHistory: [Session] = []
    private let api = ApiService()  // initialize it!

    func getAllSessionHistory(
        parentSystemID: String,
        parentObjectId: String,
        userSystemId: String,
        userEmail: String = "",
        completion: @escaping ([Session]) -> Void
    ) {
        let path = "/ambient-intelligence/objects/\(parentSystemID)/\(parentObjectId)/children"
        let params: Parameters = [
            "userSystemId": userSystemId,
            "userEmail": userEmail,
            "size": 10,
            "page": 0
        ]

        api.get(path: path, parameters: params) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    do {
                        let sessions = try JSONDecoder().decode([Session].self, from: data)
                        self.sessionHistory = sessions
                        completion(sessions)
                    } catch {
                        print("Decoding failed:", error)
                        completion([])
                    }
                } else {
                    completion([])
                }
            case .failure(let error):
                print("API error:", error)
                completion([])
            }
        }
    }
    func getSessionHistoryCount() -> Int {
        return sessionHistory.count
    }
    func getSessionHistory(at index: Int) -> Session {
        return sessionHistory[index]
    }
}
