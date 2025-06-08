import Foundation
struct Object: Codable {
    let id: [String: String]
    let type: String
    let alias: String
    let status: String
    let active: Bool
    let creationTimestamp: Date
    let createdBy: userId
}

struct userId: Codable {
    let email: String
    let systemId: String
}
