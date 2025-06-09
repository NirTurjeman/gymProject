import Foundation
import Alamofire

class DashboardViewModel {
    private var sessionHistory: [Session] = []
    private let dashboardService: DashBoardService
    
    init(dashboardService: DashBoardService = .shared) {
        self.dashboardService = dashboardService
    }
    
    func getAllSessionHistory(parentSystemID:String,parentObjectId:String,userSystemId:String,userEmail:String="",
                              completion: @escaping ([Session]) -> Void) {
        dashboardService.getAllSessionHistory(parentSystemID: parentSystemID, parentObjectId: parentObjectId, userSystemId: userSystemId, userEmail: userEmail) { result in
            switch result {
            case .success(let sessions):
                self.sessionHistory = sessions
                completion(sessions)
            case .failure(let error):
                print("Error fetching session history: \(error)")
                completion([])
            }
            
        }
        func getSessionHistoryCount() -> Int {
            return sessionHistory.count
        }
        func getSessionHistory(at index: Int) -> Session {
            return sessionHistory[index]
        }
    }
}
