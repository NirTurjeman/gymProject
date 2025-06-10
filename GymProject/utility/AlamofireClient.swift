import Alamofire
import Foundation

class APIClient {
    static let shared = APIClient()

    let baseURL = "http://localhost:8081"
    let session: Alamofire.Session

    private init() {
        session = Alamofire.Session()
    }
    func getDecodable<T: Decodable>(path: String, parameters: Parameters? = nil, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = "\(baseURL)\(path)"
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        decoder.dateDecodingStrategy = .formatted(formatter)

        AF.request(url, parameters: parameters)
            .validate()
            .responseDecodable(of: T.self, decoder: decoder) { response in
                if let data = response.data {
                            print("Raw JSON Response:")
                            print(String(data: data, encoding: .utf8) ?? "Cannot decode data to string")
                        }
                completion(response.result)
            }
    }


    func request<T: Decodable>(
        path: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<T, AFError>) -> Void
    ) {
        let url = "\(baseURL)/\(path)"
        session.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                completion(response.result)
            }
    }
}
