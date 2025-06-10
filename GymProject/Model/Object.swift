import Foundation
struct Object: Codable {
    let id: [String: String]
    let type: String
    let alias: String
    let status: String
    let active: Bool
    let creationTimestamp: Date
    let createdBy: UserId
}

struct UserId: Codable {
    let email: String
    let systemID: String? 
}
