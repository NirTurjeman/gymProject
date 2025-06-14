import UIKit

class ActivityViewController: UIViewController {
    @IBOutlet weak var finishActivityButton: UIButton!
    @IBOutlet weak var refreshRepsButoon: UIButton!
    @IBOutlet weak var repsLBL: UILabel!
    @IBOutlet weak var timeLBL: UILabel!
    @IBOutlet weak var activityLBL: UILabel!
    private var viewModel: ActivityViewModel!
    // Parm
    var activityName: String!
    var sessionID: String!
    var equipmentID: String!
    var equipmentName: String!

    // Timer properties
    private var timer: Timer?
    private var secondsElapsed: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ActivityViewModel(
            activityName: activityName,
            sessionID: sessionID,
            equipmentID: equipmentID,
            equipmentName: equipmentName
        )
        startOrResumeStopwatch()
    }

    private func setupView() {
        self.activityLBL.text = activityName
    }

    func startOrResumeStopwatch() {
        // Prevent multiple timers from being scheduled
        guard timer == nil else { return }

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.secondsElapsed += 1
            let minutes = self.secondsElapsed / 60
            let seconds = self.secondsElapsed % 60
            self.timeLBL.text = String(format: "%02d:%02d", minutes, seconds)
        }
    }

    deinit {
        timer?.invalidate()
    }
    
    @IBAction func onRefreshTap(_ sender: Any) {
        if let reps = viewModel.getCurrentActivity()?.reps {
            repsLBL.text = String(reps)
        } else {
            repsLBL.text = "0"
        }
    }
    @IBAction func onFinishActivityTap(_ sender: Any) {
        viewModel.finishActivity()
        if presentingViewController != nil {
            dismiss(animated: true)
        } else {
            // If pushed in a navigation controller
            navigationController?.popViewController(animated: true)
        }
    }
}
