import Foundation
import UIKit

class SessionDetailViewController: UIViewController, UITableViewDataSource {

    private var viewModel: SessionDeteailsViewModel!
    @IBOutlet weak var tableView: UITableView!
    
    func configure(with viewModel: SessionDeteailsViewModel) {
        self.viewModel = viewModel
        // Fetch activities and reload table view when done
        viewModel.getSessionActivities { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Rows: \(viewModel?.getActivities().count ?? -1)")
        return viewModel.getActivities().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ActivityCell")
        let activity = viewModel.getActivities()[indexPath.row]
        print("Activity: \(activity)")
        if let equipment = activity.equipment {
            let title = "\(indexPath.row + 1) : Equipment \(equipment.object.alias)"
            let repsText = activity.reps != nil ? "\(activity.reps!)" : "N/A"
            let subtitle = "Reps : \(repsText) | Weight: \(equipment.weightKg) kg"
            cell.textLabel?.text = title
            cell.detailTextLabel?.text = subtitle
        } else {
            cell.textLabel?.text = "\(indexPath.row + 1) : No Equipment"
            cell.detailTextLabel?.text = "Reps : \(activity.reps ?? 0) | Weight: N/A"
        }
        cell.imageView?.image = UIImage(systemName: "dumbbell.fill")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        return cell
    }
}
