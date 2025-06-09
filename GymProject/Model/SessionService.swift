import Alamofire
import Foundation

class SessionService {
    static let shared = SessionService()
    let api = APIClient.shared
    private init() {}
    
    func getAllFreeEquesment(){
        api.request(path: "/freeEquesment", method: .get) { (result: Result<Data, AFError>) in
            switch result {
            case .success(let data):
                do {
                    let sessions = try JSONDecoder().decode([Equipment].self, from: data)
                    // Handle the decoded sessions as needed
                } catch {
                    // Handle decoding error
                    print("Decoding error: \(error)")
                }
            case .failure(let error):
                // Handle request failure
                print("Request failed with error: \(error)")
            }
            
        }
        
    }
}
