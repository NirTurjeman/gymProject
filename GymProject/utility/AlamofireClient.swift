import Alamofire
import Foundation

class ApiService {
    private let baseUrl = "http://localhost:8080"

    // MARK: - GET with query parameters
    func get(path: String, parameters: Parameters? = nil, completion: @escaping (Result<Data?, AFError>) -> Void) {
        let url = "\(baseUrl)\(path)"
        AF.request(url, parameters: parameters)
            .response { response in
                completion(response.result)
            }
    }

    // MARK: - Generic request supporting both JSON body and query parameters
    func request<T: Encodable>(
        path: String,
        method: HTTPMethod,
        query: Parameters? = nil,
        body: T,
        completion: @escaping (Result<Data?, AFError>) -> Void
    ) {
        let url = "\(baseUrl)\(path)"
        var urlRequest = try! URLRequest(url: url, method: method)

        // Encode query parameters in URL
        if let query = query {
            urlRequest = try! URLEncoding.default.encode(urlRequest, with: query)
        }

        // Encode JSON body
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        AF.request(urlRequest)
            .response { response in
                completion(response.result)
            }
    }

    // MARK: - DELETE without body
    func delete(path: String, parameters: Parameters? = nil, completion: @escaping (Result<Data?, AFError>) -> Void) {
        let url = "\(baseUrl)\(path)"
        AF.request(url, method: .delete, parameters: parameters)
            .response { response in
                completion(response.result)
            }
    }
}
