
struct Equipment: Codable {
    let weightKg: Int
    let location: String
    let manufacturer: String
    let activitiesSupoorted: [String]
    let object: Object

    enum CodingKeys: String, CodingKey {
        case weightKg
        case location
        case manufacturer
        case activitiesSupoorted
        case object
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        weightKg = try container.decode(Int.self, forKey: .weightKg)
        location = try container.decode(String.self, forKey: .location)
        manufacturer = try container.decode(String.self, forKey: .manufacturer)
        activitiesSupoorted = try container.decode([String].self, forKey: .activitiesSupoorted)
        object = try container.decode(Object.self, forKey: .object)
    }
}
