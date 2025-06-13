import SwiftyJSON

struct UserBoundary {
    let userId: UserId
    let role: String
    let userName: String
    let avatar: String

    init(json: JSON) {
        userId = UserId(json: json["userId"])
        role = json["role"].stringValue
        userName = json["userName"].stringValue
        avatar = json["avatar"].stringValue
    }

    var toJSON: JSON {
        return JSON([
            "userId": userId.toJSON.dictionaryObject ?? [:],
            "role": role,
            "userName": userName,
            "avatar": avatar
        ])
    }
}
