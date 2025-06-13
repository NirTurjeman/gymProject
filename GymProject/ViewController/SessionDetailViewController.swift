import Foundation
import UIKit

class SessionDetailViewController: UIViewController, UITableViewDataSource {

    private var viewModel: SessionDeteailsViewModel!
    @IBOutlet weak var sessionTitle: UILabel!
    @IBOutlet weak var ActivityTable: UITableView!
    @IBOutlet weak var sessionDate: UILabel!

    func configure(with viewModel: SessionDeteailsViewModel) {
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ActivityTable.dataSource = self

        // Set session title
        sessionTitle.text = viewModel.getSession().object.alias

        // Set session date
        let creationDate = viewModel.getSession().object.creationTimestamp
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        sessionDate.text = formatter.string(from: creationDate)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getActivities().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ActivityCell")
        let activity = viewModel.getActivities()[indexPath.row]

        let title = "\(indexPath.row + 1) : Equipment \(activity.equipment.object.alias)"
        let subtitle = "Reps : \(activity.reps) | Weight: \(activity.equipment.weightKg) kg"

        cell.textLabel?.text = title
        cell.detailTextLabel?.text = subtitle
        cell.imageView?.image = UIImage(systemName: "dumbbell.fill")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)

        return cell
    }
}
