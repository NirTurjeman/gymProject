import Foundation
struct Activity: Codable {
    let finished: Date
    var reps: Int
    let equipment: Equipment
    let object: Object
}
//struct ActivityDetails: Codable {
//    let finished: Date?
//    let reps: Int
//    let equipment: Equipment
//}
