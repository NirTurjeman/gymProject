import SwiftyJSON

struct Equipment {
    let object: Object
    let weightKg: Int
    let location: String
    let manufacturer: String
    let activitiesSupported: [String]

    init(json: JSON) {
        object = Object(json: json)
        let details = json["details"]
        weightKg = details["WeightKg"].intValue
        location = details["location"].stringValue
        manufacturer = details["manufacturer"].stringValue
        activitiesSupported = details["activitiesSupported"].arrayValue.map { $0.stringValue }
    }

    var toJSON: JSON {
        var dict = object.toJSON.dictionaryObject ?? [:]
        let details: [String: Any] = [
            "weightKg": weightKg,
            "location": location,
            "manufacturer": manufacturer,
            "activitiesSupported": activitiesSupported
        ]
        dict["details"] = details
        return JSON(dict)
    }
}
