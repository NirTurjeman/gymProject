import Foundation
struct Activity: Codable {
    let finished: Date
    var reps: Int
    let equipment: Equipment
    let object: Object
}
