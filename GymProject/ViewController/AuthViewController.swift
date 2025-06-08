import UIKit
class AuthViewController : UIViewController {
    @IBOutlet weak var email_Input: UITextField!
    @IBOutlet weak var sysID_Input: UITextField!
    @IBOutlet weak var login_Button: UIButton!
    private let emailAdress: String = "nir@test.com"
    private let sysID: String = "123456"
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func loginTapped(_ sender: Any) {
//        if validInput() {
//            print("Login successful")

            let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
            if let dashboardVC = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as? DashboardViewController {
                dashboardVC.modalPresentationStyle = .fullScreen
                self.present(dashboardVC, animated: true, completion: nil)
            }
//        }

    }
    private func validInput() -> Bool {
        if email_Input.text == emailAdress && sysID_Input.text == sysID {
            return true
        }
        return false
    }

}
