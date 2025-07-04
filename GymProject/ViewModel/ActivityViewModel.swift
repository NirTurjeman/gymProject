import Foundation
import Alamofire

class ActivityViewModel {
    private var service: SessionService
    private let email: String
    private let systemID: String
    private var currentActivity: Activity?
    
    init(
        activityName: String,
        sessionID: String,
        equipmentID: String,
        equipmentName: String
    ) {
        self.service = SessionService()
        self.email = UserDefaults.standard.string(forKey: "userEmail") ?? ""
        self.systemID = UserDefaults.standard.string(forKey: "userSystemID") ?? ""
        self.currentActivity = nil
        
        service.startActivity(
            email: email,
            systemID: systemID,
            sessionID: sessionID,
            equipmentID: equipmentID,
            equipmentName: equipmentName
        ) { [weak self] result in
            if case .success(let activity) = result {
                self?.currentActivity = activity
                print("currentActivity: \(String(describing: self?.currentActivity))")
            }
        }
    }
    func refreshActivity(completion: @escaping (Result<Activity, Error>) -> Void) {
        let activityID = currentActivity?.object.id["objectId"] ?? ""
        print("currentActivity(refresh): \(String(describing: currentActivity))")
        print("activityID: \(activityID)")
        service.refreshActivity(email: email, systemID: systemID,activityID: currentActivity?.object.id["objectId"] ?? "") { [weak self] result in
            switch result {
            case .success(let activity):
                self?.currentActivity = activity
                completion(.success(activity))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getCurrentActivity() -> Activity? {
        return currentActivity
    }
    func finishActivity() {
        service.finishActivity(email: self.email, systemID: self.systemID, sessionID: "", activityID: self.currentActivity?.object.id["objectId"] ?? "")
    }
}
