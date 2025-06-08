import Alamofire

class AlamofireClient {
    static let shared = AlamofireClient()
    let baseURL = "https://api.example.com/ambient-intelligence/users"
    let session: Session

    private init() {
        session = Session()
    }
}
