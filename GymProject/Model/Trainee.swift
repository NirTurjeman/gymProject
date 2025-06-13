import SwiftyJSON

struct Trainee {
    let age: Int
    let gender: String
    let heightCm: Int
    let weightKg: Int
    let object: Object

    init(json: JSON) {
        object = Object(json: json)
        let details = json["details"]
        age = details["age"].intValue
        gender = details["gender"].stringValue
        heightCm = details["heightCm"].intValue
        weightKg = details["weightKg"].intValue
    }

    var toJSON: JSON {
        var dict = object.toJSON.dictionaryObject ?? [:]
        let details: [String: Any] = [
            "age": age,
            "gender": gender,
            "heightCm": heightCm,
            "weightKg": weightKg
        ]
        dict["details"] = details
        return JSON(dict)
    }
}
