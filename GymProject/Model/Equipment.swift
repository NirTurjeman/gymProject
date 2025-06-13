struct Equipment: Codable {
    let weightKg: Int
    let location: String
    let manufacturer: String
    let activitiesSupported: [String]?
    let object: Object

    enum CodingKeys: String, CodingKey {
        case weightKg
        case location
        case manufacturer
        case activitiesSupported = "activitiesSupported"
        case object
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        weightKg = try container.decode(Int.self, forKey: .weightKg)
        location = try container.decode(String.self, forKey: .location)
        manufacturer = try container.decode(String.self, forKey: .manufacturer)
        activitiesSupported = try container.decodeIfPresent([String].self, forKey: .activitiesSupported)
        object = try container.decode(Object.self, forKey: .object)
    }
}
