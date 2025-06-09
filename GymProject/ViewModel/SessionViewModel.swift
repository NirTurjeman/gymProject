import Foundation
class SessionViewModel {
    private var equipments: [Equipment] = []
    let equipment1: Equipment
    let equipment2: Equipment
    init() {
            equipment1 = Equipment(
                weightKg: 150,
                location: "Gym Floor A",
                manufacturer: "TechnoGym",
                activitiesSupoorted: ["Bench Press", "Chest Fly"],
                object: Object(
                    id: ["objectId": "EQ001", "systemId": "SYS01"],
                    type: "Equipment",
                    alias: "Bench Press Machine",
                    status: "free",
                    active: true,
                    creationTimestamp: Date(),
                    createdBy: userId(email: "admin@gym.com", systemId: "SYS01")
                )
            )

            equipment2 = Equipment(
                weightKg: 80,
                location: "Gym Floor B",
                manufacturer: "LifeFitness",
                activitiesSupoorted: ["Leg Curl", "Leg Extension"],
                object: Object(
                    id: ["objectId": "EQ002", "systemId": "SYS02"],
                    type: "Equipment",
                    alias: "Leg Curl Machine",
                    status: "free",
                    active: false,
                    creationTimestamp: Date().addingTimeInterval(-86400),
                    createdBy: userId(email: "maintenance@gym.com", systemId: "SYS02")
                )
            )

            equipments = [equipment1, equipment2]
        }
    
    func getEquipments() -> [Equipment] {
        
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
