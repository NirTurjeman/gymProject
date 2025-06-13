import SwiftyJSON
import Foundation

struct Object {
    let id: [String: String]
    let type: String
    let alias: String
    let status: String
    let active: Bool
    let creationTimestamp: Date
    let createdBy: UserId

    init(json: JSON) {
        id = json["id"].dictionaryObject as? [String: String] ?? [:]
        type = json["type"].stringValue
        alias = json["alias"].stringValue
        status = json["status"].stringValue
        active = json["active"].boolValue
        let dateString = json["creationTimestamp"].stringValue
        creationTimestamp = ISO8601DateFormatter().date(from: dateString) ?? Date()
        createdBy = UserId(json: json["createdBy"])
    }

    var toJSON: JSON {
        return JSON([
            "id": id,
            "type": type,
            "alias": alias,
            "status": status,
            "active": active,
            "creationTimestamp": ISO8601DateFormatter().string(from: creationTimestamp),
            "createdBy": createdBy.toJSON.dictionaryObject ?? [:]
        ])
    }
}

struct UserId {
    let email: String
    let systemID: String?

    init(json: JSON) {
        email = json["email"].stringValue
        systemID = json["systemID"].string
    }

    var toJSON: JSON {
        var dict: [String: Any] = ["email": email]
        if let systemID = systemID {
            dict["systemID"] = systemID
        }
        return JSON(dict)
    }
}
