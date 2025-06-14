import Foundation
import SwiftyJSON
import Alamofire

class AuthService {
    static let shared = AuthService()
    let api = APIClient.shared
    init() {}

    func login(email: String, systemID: String, completion: @escaping (Result<Trainee, AFError>) -> Void){
        let params: [String: Any] = [
            "command": "login",
            "invokedBy": [
                    "email": "\(email)",
                    "systemID": "\(systemID)"
            ],
            "targetObject": NSNull(),
            "commandAttributes": [:]
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]

        api.request(path: "ambient-intelligence/commands", method: .post,parameters: params,headers: headers,
                    encoding: JSONEncoding.default) { (result: Result<JSON, AFError>) in
            switch result {
                  case .success(let json):
                      // אם זה מערך, קח את הראשון
                      if let traineeJson = json.array?.first {
                          let trainee = Trainee(json: traineeJson)
                          completion(.success(trainee))
                      } else {
                          completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                      }
                  case .failure(let error):
                      completion(.failure(error))
                  }
              }
        }
    }

