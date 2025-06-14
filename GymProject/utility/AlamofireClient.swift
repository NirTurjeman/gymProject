import Alamofire
import SwiftyJSON
import Foundation

class APIClient {
    static let shared = APIClient()

    let baseURL = "http://192.168.1.126:8081"
    let session: Alamofire.Session

    private init() {
        session = Alamofire.Session()
    }

    func request(
        path: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        encoding: ParameterEncoding? = nil,
        completion: @escaping (Result<JSON, AFError>) -> Void
    ) {
        let url = "\(baseURL)/\(path)"

        let chosenEncoding: ParameterEncoding = encoding ?? {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()

        session.request(url, method: method, parameters: parameters, encoding: chosenEncoding, headers: headers)
            .validate()
            .response { response in
                if let request = response.request {
                        print("🌐 Full URL: \(request.url?.absoluteString ?? "N/A")")
                    }
                if let statusCode = response.response?.statusCode {
                    print("🔹 Response status code: \(statusCode)")
                }

                switch response.result {
                case .success(let data):
                    if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                        print("✅ Raw JSON response: \(jsonString)")
                        let json = JSON(data)
                        completion(.success(json))
                    } else {
                        print("⚠️ No valid data received")
                        completion(.failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)))
                    }
                case .failure(let error):
                    print("❌ Request failed: \(error)")
                    completion(.failure(error))
                }
            }
    }
}
