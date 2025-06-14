import Foundation
import Alamofire
class ActivityViewModel{
    private var service:SessionService!
    private let email = UserDefaults.standard.string(forKey: "userEmail") ?? ""
    private let systemID = UserDefaults.standard.string(forKey: "userSystemID") ?? ""
    init(activityName: String,
         sessionID: String,
         equipmentID: String,
         equipmentName: String,
         completion: @escaping (Result<Activity, AFError>) -> Void)
    {
        service.startActivity(
            email: email,
            systemID: systemID,
            sessionID: sessionID,
            equipmentID: equipmentID,
            equipmentName: equipmentName
        ) { result in
            completion(result)
        }
    }

}
