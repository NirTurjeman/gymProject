import SwiftyJSON
import Foundation

struct Activity {
    let object: Object
    let finished: Date?
    let reps: Int?
    let equipment: Equipment?

    init(json: JSON) {
        object = Object(json: json)
        let details = json["details"]
        if let finishedString = details["Finished"].string, !finishedString.isEmpty {
            finished = ISO8601DateFormatter().date(from: finishedString)
        } else {
            finished = nil
        }
        reps = details["reps"].int
        equipment = details["equipment"].exists() ? Equipment(json: details["equipment"]) : nil
    }

    var toJSON: JSON {
        var dict = object.toJSON.dictionaryObject ?? [:]
        var details: [String: Any] = [:]
        if let finished = finished {
            details["Finished"] = ISO8601DateFormatter().string(from: finished)
        }
        if let reps = reps {
            details["reps"] = reps
        }
        if let equipment = equipment {
            details["equipment"] = equipment.toJSON.dictionaryObject ?? [:]
        }
        dict["details"] = details
        return JSON(dict)
    }
}
