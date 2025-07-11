import UIKit
import CoreNFC
class SessionViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,NFCNDEFReaderSessionDelegate {
    @IBOutlet weak var finishSessionButton: UIButton!
    @IBOutlet weak var scanEquipment: UIView!
    @IBOutlet weak var tableView: UITableView!
    private var viewModel: SessionViewModel!
    var nfcSession: NFCNDEFReaderSession?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScanEquipment()
        tableView.dataSource = self
        tableView.delegate = self
        self.viewModel = SessionViewModel(){
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
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
           tableView.backgroundColor = .white
           view.addSubview(tableView)

           NSLayoutConstraint.activate([
               tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
               tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
               tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
               tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
           ])
       }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.getEquipments().count
        print("count: \(count)")
        return count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "equipmentCell", for: indexPath)
        let eqipment = viewModel.getFreeEquipments(at: indexPath.row)
        let alias = eqipment.object.alias
        let title = "\(indexPath.row + 1). \(alias)"
        let subtitle = "Loction: \(eqipment.location)"

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

        cell.imageView?.image = UIImage(systemName: "dumbbell")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEqipment = viewModel.getFreeEquipments(at: indexPath.row)
        showAlertForEquipment(selectedEqipment)
    }

    func showAlertForEquipment(_ equipment: Equipment) {
        let alias = equipment.object.alias
        let alert = UIAlertController(title: "Connect to Equipment:",
                                      message: "Are you sure you want to connect to \(alias)?",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Connect", style: .default, handler: { _ in
            print("Connecting to \(alias)")
            self.showExerciseSelection(for: equipment)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    func showExerciseSelection(for equipment: Equipment) {
        let alert = UIAlertController(title: "Select Exercise",
                                      message: "Choose an exercise to perform:",
                                      preferredStyle: .alert)

        for exercise in equipment.activitiesSupported {
            alert.addAction(UIAlertAction(title: exercise, style: .default, handler: { _ in
                print("Selected exercise: \(exercise)")
                self.startActivity(exercise: exercise,equipment: equipment)
            }))
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }
    func startActivity(exercise: String, equipment: Equipment) {
        print("Starting activity: \(exercise)")
        print("equipment: \(equipment)")

        let storyboard = UIStoryboard(name: "Session", bundle: nil)
        if let sessionVC = storyboard.instantiateViewController(withIdentifier: "ActivityViewController") as? ActivityViewController {
            sessionVC.activityName = exercise
            sessionVC.sessionID = viewModel.getSession()?.object.id["objectId"] ?? ""
            sessionVC.equipmentID = equipment.object.id["objectId"]
            sessionVC.equipmentName = equipment.object.alias
            sessionVC.modalPresentationStyle = .popover
            self.present(sessionVC, animated: true, completion: nil)
        }
    }
    @IBAction func finishButtonTap(_ sender: Any) {
        if presentingViewController != nil {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func connectEquipButton(_ sender: Any) {
        startScanning()
    }
    @IBAction func startScanning() {
        nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        nfcSession?.alertMessage = "Put your iPhone near the equipment to read it"
        nfcSession?.begin()
    }
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("Equipment connection invalidated: \(error.localizedDescription)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            for record in message.records {
                if let equipID = String(data: record.payload, encoding: .utf8) {
                    let cleanedEquipID = equipID.trimmingCharacters(in: .controlCharacters)
                    print("equipID: \(cleanedEquipID)")
                    if let equipment = viewModel.getEquipmentByID(cleanedEquipID) {
                        print("equipment: \(String(describing: equipment))")
                        DispatchQueue.main.async {
                            self.showAlertForEquipment(equipment)
                        }
                    }
                }
            }
        }
    }
}
