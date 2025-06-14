import UIKit
import SwiftyJSON
class AuthViewController : UIViewController {
    @IBOutlet weak var systemID_Input: UITextField!
    @IBOutlet weak var email_input: UITextField!
    @IBOutlet weak var error: UILabel!
    @IBOutlet weak var login_Button: UIButton!
    
    var viewModel = AuthViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func loginTapped(_ sender: Any) {
        if let email = email_input.text, let systemID = systemID_Input.text {
            print("email: \(email), systemID: \(systemID)")
            viewModel.checkLogIn(email: email, systemID: systemID) { trainee in
                if trainee {
                    UserDefaults.standard.set(self.systemID_Input.text, forKey: "userSystemID")
                    UserDefaults.standard.set(self.email_input.text, forKey: "userEmail")
                    UserDefaults.standard.set(trainee,forKey: "trainee")
                    let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                    if let dashboardVC = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as? DashboardViewController {
                        dashboardVC.modalPresentationStyle = .fullScreen
                        self.present(dashboardVC, animated: true, completion: nil)
                    }
                } else {
                    self.error.text = "Failed to fetch trainee data."
                    self.error.isHidden = false
                }
            }
        } else {
            self.error.text = "Login failed. Please check your credentials."
            self.error.isHidden = false
        }
    }
}
