import Foundation
class SessionViewModel {
    private var equipments: [Equipment] = []
    private var sessionService = SessionService()
    init() {
        sessionService.getAllFreeEquipments { result in
            switch result {
            case .success(let equipments):
                print("Received \(equipments.count) equipments")
                self.equipments = equipments
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    func getEquipments() -> [Equipment] {
            return equipments
    }
        
    func getFreeEquipmentsCount() -> Int {
        return equipments.filter { $0.object.status.lowercased() == "free" }.count
    }

    func getFreeEquipments(at index: Int) -> Equipment {
        return equipments[index]
    }
    func chooseActivity(){
        
    }
}
