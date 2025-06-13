import Foundation
import UIKit
class SessionDeteailsViewModel {
    private let session: Session
    private var activities: [Activity] = []
    private let sessionService = SessionService.shared
    init(session: Session, completion: @escaping ([Activity]) -> Void) {
        self.session = session
 
        getSessionActivities { activities in
            completion(self.activities)
        }
    }
    func getSessionActivities(completion: @escaping ([Activity]) -> Void) {
        
        guard let sessionId = session.object.id["objectId"] else {
            print("Invalid session ID")
            completion([])
            return
        }
        guard let userSystemId = session.object.id["systemID"] else {
            print("Invalid user system ID")
            completion([])
            return
        }
        let userEmail = UserDefaults.standard.string(forKey: "userEmail") ?? ""
        
        

        sessionService.getAllSessionActivities(sessionId: sessionId, userSystemId: userSystemId, userEmail: userEmail) { result in
            switch result {
            case .success(let activities):
                self.activities = activities
                completion(activities)
            case .failure(let error):
                print("Error fetching activities: \(error)")
                self.activities = []
                completion([])
            }
        }
    }

    func getSession() -> Session {
        return session
    }
    func getActivities() -> [Activity] {
        return self.activities
    }
}
