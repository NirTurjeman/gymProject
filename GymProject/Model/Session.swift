import Foundation
struct CreatedBy: Codable {
    let userId: UserId
}
struct Session: Codable {
    let finishedTime: Date?
    let object: Object

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case alias
        case status
        case active
        case creationTimestamp
        case createdBy
        case objectDetails
    }

    enum ObjectDetailsKeys: String, CodingKey {
        case Finished
    }

    // MARK: - Decodable
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let id = try container.decode([String: String].self, forKey: .id)
        let type = try container.decode(String.self, forKey: .type)
        let alias = try container.decode(String.self, forKey: .alias)
        let status = try container.decode(String.self, forKey: .status)
        let active = try container.decode(Bool.self, forKey: .active)
        let creationTimestamp = try container.decode(Date.self, forKey: .creationTimestamp)
        let createdBy = try container.decode(UserId.self, forKey: .createdBy)

        self.object = Object(
            id: id,
            type: type,
            alias: alias,
            status: status,
            active: active,
            creationTimestamp: creationTimestamp,
            createdBy: createdBy
        )

        if let objectDetailsContainer = try? container.nestedContainer(keyedBy: ObjectDetailsKeys.self, forKey: .objectDetails) {
            finishedTime = try? objectDetailsContainer.decodeIfPresent(Date.self, forKey: .Finished)
        } else {
            finishedTime = nil
        }
    }

    // MARK: - Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(object.id, forKey: .id)
        try container.encode(object.type, forKey: .type)
        try container.encode(object.alias, forKey: .alias)
        try container.encode(object.status, forKey: .status)
        try container.encode(object.active, forKey: .active)
        try container.encode(object.creationTimestamp, forKey: .creationTimestamp)

        try container.encode(CreatedBy(userId: object.createdBy), forKey: .createdBy)

        var objectDetailsContainer = container.nestedContainer(keyedBy: ObjectDetailsKeys.self, forKey: .objectDetails)
        try objectDetailsContainer.encodeIfPresent(finishedTime, forKey: .Finished)
    }
}
