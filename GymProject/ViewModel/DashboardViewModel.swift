import Foundation
import Alamofire

class DashboardViewModel {
    private var sessionHistory: [Session] = []
    private let dashboardService = DashBoardService()
    init(userSystemID: String, userEmail: String = "", completion: @escaping ([Session]) -> Void) {
        getAllSessionHistory(userSystemID: userSystemID, userEmail: userEmail) { sessions in
            completion(sessions)
        }
    }
    private func getAllSessionHistory(userSystemID: String, userEmail: String = "", completion: @escaping ([Session]) -> Void) {
        dashboardService.getAllSessionHistory(userSystemID: userSystemID, userEmail: userEmail) { result in
            switch result {
            case .success(let sessions):
                print("sessions fetched successfully\n")
                print("1. \(sessions.count)")
                self.sessionHistory = sessions
                completion(sessions)
            case .failure(let error):
                print("Error fetching session history: \(error)")
                completion([])
            }
        }
    }
    func getSessionHistoryCount() -> Int {
        return sessionHistory.count
    }
    func getSessionHistory(at index: Int) -> Session {
        guard index >= 0, index < sessionHistory.count else {
            fatalError("Index out of bounds in sessionHistory")
        }
        return sessionHistory[index]
    }
}
