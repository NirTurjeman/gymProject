import Alamofire
import SwiftyJSON
import Foundation

class SessionService {
    static let shared = SessionService()
    let api = APIClient.shared
    init(){}

    func getAllFreeEquipments(userSystemId: String, userEmail: String,completion: @escaping (Result<[Equipment], Error>) -> Void) {
        let parameters: [String: String] = [
            "userEmail": userEmail,
            "userSystemID": userSystemId
        ]
        let path = "ambient-intelligence/objects/search/byTypeAndStatus/equipment/FREE"
        print("Fetching free equipments with parameters: \(parameters)")
        

        api.request(path: path, method: .get,parameters: parameters) { result in
            switch result {
            case .success(let json):
                let equipments = json.arrayValue.map { Equipment(json: $0) }
                completion(.success(equipments))
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(.failure(error))
            }
        }
    }

    func getAllSessionActivities(sessionId: String, userSystemId: String, userEmail: String, completion: @escaping (Result<[Activity], Error>) -> Void) {
        let path = "ambient-intelligence/objects/\(userSystemId)/\(sessionId)/children"
        let parameters: [String: String] = [
            "userEmail": userEmail,
            "userSystemID": userSystemId
        ]
        api.request(path: path, method: .get, parameters: parameters, encoding: URLEncoding.default) { result in
            switch result {
            case .success(let json):
                let activities = json.arrayValue.map { Activity(json: $0) }
                completion(.success(activities))
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(.failure(error))
            }
        }
    }
    func startActivity(
        email: String,
        systemID: String,
        sessionID: String,
        equipmentID: String,
        equipmentName: String,
        completion: @escaping (Result<Activity, AFError>) -> Void
    ) {
        let params: [String: Any] = [
            "command": "start-activity",
            "invokedBy": [
                    "email": email,
                    "systemID": systemID
            ],
            "targetObject": [
                "objectId": sessionID,
                "systemID": systemID
            ],
            "commandAttributes": [
                "equipmentId": equipmentID,
                "activityName": equipmentName 
            ]
        ]

        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]

        api.request(
            path: "ambient-intelligence/commands",
            method: .post,
            parameters: params,
            headers: headers,
            encoding: JSONEncoding.default
        ) { (result: Result<JSON, AFError>) in
            switch result {
            case .success(let json):
                if let activityJson = json.array?.first {
                    let activity = Activity(json: activityJson)
                    completion(.success(activity))
                } else {
                    completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func finishActivity(email: String, systemID: String, sessionID: String, activityID: String) {
        let params: [String: Any] = [
            "command": "finish-activity",
            "invokedBy": [
                    "email": email,
                    "systemID": systemID
            ],
            "targetObject": [
                "objectId": activityID,
                "systemID": systemID
            ],
            "commandAttributes": [:]
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        print("parameters: \(params)")
        api.request(
            path: "ambient-intelligence/commands",
            method: .post,
            parameters: params,
            headers: headers,
            encoding: JSONEncoding.default
        ) { (result: Result<JSON, AFError>) in
            
        }
    }
    func startSession(
        email: String,
        systemID: String,
        traineeID: String,
        completion: @escaping (Result<Session, AFError>) -> Void
    ) {
        let params: [String: Any] = [
            "command": "start-session",
            "invokedBy": [
                "email": email,
                "systemID": systemID
            ],
            "targetObject": [
                "objectId": traineeID,
                "systemID": systemID
            ],
            "commandAttributes": [:]
        ]
        print("parms: \(params)")
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        api.request(
            path: "ambient-intelligence/commands",
            method: .post,
            parameters: params,
            headers: headers,
            encoding: JSONEncoding.default
        ) { (result: Result<JSON, AFError>) in
            switch result {
            case .success(let json):
                if let first = json.array?.first {
                    let session = Session(json: first)
                    completion(.success(session))
                } else {
                    print("❌ No session returned")
                    completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(.failure(error))
            }
        }
    }

}
