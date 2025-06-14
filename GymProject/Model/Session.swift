import SwiftyJSON
import Foundation

struct Session {
    let finishedTime: Date?
    let object: Object

    init(json: JSON) {
        object = Object(json: json) // Pass the whole JSON for common fields
        let details = json["objectDetails"]
        if let finishedString = details["Finished"].string, !finishedString.isEmpty {
            finishedTime = ISO8601DateFormatter().date(from: finishedString)
        } else {
            finishedTime = nil
        }
    }

    var toJSON: JSON {
        var dict = object.toJSON.dictionaryObject ?? [:]
        var details: [String: Any] = [:]
        if let finishedTime = finishedTime {
            details["Finished"] = ISO8601DateFormatter().string(from: finishedTime)
        }
        dict["details"] = details
        return JSON(dict)
    }
}
