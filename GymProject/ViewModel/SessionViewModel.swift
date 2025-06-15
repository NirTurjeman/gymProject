import Foundation
import SwiftyJSON
class SessionViewModel {
    private var equipments: [Equipment] = []
    private var sessionService = SessionService()
    private let systemID = UserDefaults.standard.string(forKey: "userSystemID") ?? ""
    private let userEmail = UserDefaults.standard.string(forKey: "userEmail") ?? ""
    private let trainee: Trainee?
    private var currentSession: Session?
    init(completion: @escaping () -> Void) {
        if let jsonString = UserDefaults.standard.string(forKey: "userTrainee"),
           let data = jsonString.data(using: .utf8),
           let json = try? JSON(data: data) {
            self.trainee = Trainee(json: json)
        } else {
            self.trainee = nil
        }

        self.getAllFreeEquipments(userSystemId: systemID, userEmail: userEmail) {
            self.startSession {
                completion()
            }
        }
    }


    private func getAllFreeEquipments(userSystemId: String, userEmail: String, completion: @escaping () -> Void){
        sessionService.getAllFreeEquipments(userSystemId: self.systemID,userEmail: self.userEmail) { result in
            switch result {
            case .success(let equipments):
                print("Received \(equipments.count) equipments")
                self.equipments = equipments
                completion()
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    func getEquipments() -> [Equipment] {
        return equipments
    }
    func getEquipmentByID(_ id: String) -> Equipment? {
        return equipments.first { $0.object.id["objectId"] == id }
    }
    func getFreeEquipments(at index: Int) -> Equipment {
        return equipments[index]
    }
    func startSession(completion: @escaping () -> Void) {
        guard let traineeID = trainee?.object.id["objectId"] else {
            completion()
            return
        }
        sessionService.startSession(email: userEmail, systemID: systemID, traineeID: traineeID) { result in
            switch result {
            case .success(let session):
                print("✅ Received session: \(session)")
                self.currentSession = session
            case .failure(let error):
                print("❌ Error starting session: \(error)")
            }
            completion()
        }
    }

    func getSession() -> Session? {
        return currentSession
    }
}
