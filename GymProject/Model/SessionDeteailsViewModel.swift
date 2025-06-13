import Foundation
class SessionDeteailsViewModel {
    private let session: Session
    private var activities: [Activity] = []
    private let sessionService = SessionService.shared

    init(session: Session) {
        self.session = session
    }

    func getSessionActivities(completion: @escaping () -> Void) {
        guard let sessionId = session.object.id.first?.value else {
            print("Invalid session ID")
            completion()
            return
        }
        guard let userSystemId = session.object.createdBy.systemID else {
            print("Invalid user system ID")
            completion()
            return
        }
        let userEmail = session.object.createdBy.email

        sessionService.getAllSessionActivities(sessionId: sessionId, userSystemId: userSystemId, userEmail: userEmail) { result in
            switch result {
            case .success(let activities):
                self.activities = activities
            case .failure(let error):
                print("Error fetching activities: \(error)")
                self.activities = []
            }
            completion()
        }
    }
    func getSession() -> Session {
        return session
    }
    func getActivities() -> [Activity] {
        return self.activities
    }
}
