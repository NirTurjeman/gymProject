import UIKit
//struct Exercise {
//    let name: String
//    let reps: String
//}
struct History {
    let date : String
    let workoutTime : String
}
class SessionViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var scanEquipment: UIView!
    @IBOutlet weak var tableView: UITableView!

//    private let exercises: [Exercise] = [
//        Exercise(name: "לחיצת חזה", reps: "3 × 12"),
//        Exercise(name: "חתירה", reps: "3 × 10"),
//        Exercise(name: "סקוואט", reps: "4 × 8"),
//        Exercise(name: "מתח", reps: "3 × מקסימום")
//    ]
    private let history: [History] = [
        History(date: "10.9", workoutTime: "13:00"),
        History(date: "11.9", workoutTime: "19:00"),
        History(date: "14.9", workoutTime: "15:30"),
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScanEquipment()
        tableView.dataSource = self
        tableView.delegate = self
    }
    private func setupScanEquipment() {
        scanEquipment.layer.cornerRadius = 20
        scanEquipment.layer.masksToBounds = true
        scanEquipment.backgroundColor = UIColor.systemGray3
        NSLayoutConstraint.activate([
            scanEquipment.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanEquipment.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -220)
        ])
    }
    private func setupTableView() {
           view.backgroundColor = UIColor.systemGroupedBackground

           tableView.translatesAutoresizingMaskIntoConstraints = false
           tableView.dataSource = self
           tableView.delegate = self
           tableView.separatorStyle = .none
           tableView.rowHeight = 80

           view.addSubview(tableView)

           NSLayoutConstraint.activate([
               tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
               tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
               tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
               tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
           ])
       }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        let history = history[indexPath.row]

        let title = "Date: \(history.date)"
        let subtitle = "Time: \(history.workoutTime)"

        let attributedTitle = NSMutableAttributedString(string: title, attributes: [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.label
        ])

        let attributedSubtitle = NSAttributedString(string: "\n\(subtitle)", attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.systemGray
        ])

        attributedTitle.append(attributedSubtitle)

        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.attributedText = attributedTitle
        cell.detailTextLabel?.text = nil

        // ✅ הוספת אייקון משקולת (System Symbol)
        cell.imageView?.image = UIImage(systemName: "dumbbell")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)

        return cell
    }

    }
