import UIKit
class ActivityViewController: UIViewController {
    @IBOutlet weak var finishActivityButton: UIButton!
    @IBOutlet weak var refreshRepsButoon: UIButton!
    @IBOutlet weak var repsLBL: UILabel!
    @IBOutlet weak var timeLBL: UILabel!
    @IBOutlet weak var activityLBL: UILabel!
    private var viewModel: ActivityViewModel!
    //Parm
    var activityName: String!
    var sessionID: String!
    var equipmentID: String!
    var equipmentName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ActivityViewModel(activityName: activityName, sessionID: sessionID, equipmentID: equipmentID, equipmentName: equipmentName){ res in
            
            
        }
    }
    private func setupView(){
        
    }
}
