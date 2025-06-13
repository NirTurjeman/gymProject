import Alamofire
import Foundation

class APIClient {
    static let shared = APIClient()

    let baseURL = "http://192.168.68.104:8081"
    let session: Alamofire.Session

    private init() {
        session = Alamofire.Session()
    }
    func getDecodable<T: Decodable>(path: String, parameters: Parameters? = nil, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = "\(baseURL)\(path)"
        print("url: \(url)")
        print("parameters: \(String(describing: parameters))")
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
        encoding: ParameterEncoding? = nil, // הוספתי פרמטר encoding אופציונלי
        completion: @escaping (Result<T, AFError>) -> Void
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

                // 🔹 הדפסת סטטוס קוד מהשרת
                if let statusCode = response.response?.statusCode {
                    print("🔹 Response status code: \(statusCode)")
                }

                switch response.result {
                case .success(let data):
                    // 🔹 הדפסת התגובה הגולמית לפני פענוח
                    if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                        print("✅ Raw JSON response: \(jsonString)")
                    } else {
                        print("⚠️ No valid data received")
                    }

                    // 🔹 בדיקה האם ניתן לפענח את הנתונים
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data!)
                        print("✅ Successfully decoded data: \(decodedData)")
                        completion(.success(decodedData))
                    } catch {
                        print("❌ JSON Decoding Error: \(error)")
                        completion(.failure(AFError.responseSerializationFailed(reason: .decodingFailed(error: error))))
                    }

                case .failure(let error):
                    print("❌ Request failed: \(error)")
                    completion(.failure(error))
                }
            }
    }


}
