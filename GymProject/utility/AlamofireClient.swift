import Alamofire

class APIClient {
    static let shared = APIClient()

    let baseURL = "https://api.example.com"
    let session: Alamofire.Session

    private init() {
        session = Alamofire.Session()
    }

    func request<T: Decodable>(
        path: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<T, AFError>) -> Void
    ) {
        let url = "\(baseURL)\(path)"
        session.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                completion(response.result)
            }
    }
}
