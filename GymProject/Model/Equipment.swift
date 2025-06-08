struct Equipment: Codable {
    let weightKg : Int
    let location: String
    let manufacturer: String
    let activitiesSupoorted: [String]
    let object: Object
}
