import Foundation
class SessionViewModel {
    private var equipments: [Equipment] = []
    private var sessionService = SessionService()
    private let systemID = UserDefaults.standard.string(forKey: "userSystemID") ?? ""
    private let userEmail = UserDefaults.standard.string(forKey: "userEmail") ?? ""
    private let trinee = UserDefaults.standard.string(forKey: "userTrainee") ?? ""
    init(completion: @escaping () -> Void) {
        self.getAllFreeEquipments(userSystemId: systemID, userEmail: userEmail, completion: completion)
        
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
    func getFreeEquipments(at index: Int) -> Equipment {
        return equipments[index]
    }
}
