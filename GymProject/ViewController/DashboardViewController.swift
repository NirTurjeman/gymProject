import UIKit
import Lottie
import CoreNFC

class DashboardViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NFCNDEFReaderSessionDelegate {
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var startSessionView: UIView!
    @IBOutlet weak var startSessionLBL: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private let systemID = UserDefaults.standard.string(forKey: "userSystemID") ?? ""
    private let userEmail = UserDefaults.standard.string(forKey: "userEmail") ?? ""
    private var scanAnimationView: LottieAnimationView?
    private var viewModel: DashboardViewModel!
    var nfcSession: NFCNDEFReaderSession?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DashboardViewModel(userSystemID: systemID, userEmail: userEmail) { [weak self] sessions in
              DispatchQueue.main.async {
                  self?.tableView.reloadData()
              }
          }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        setupStartSession()
    }
    
    private func setupStartSession() { //צריכים לקשר בין מתאמן לבין session בשרת
        startSessionView.layer.cornerRadius = 100
        startSessionView.layer.masksToBounds = false
        startSessionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startSessionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startSessionView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 280),
            startSessionView.widthAnchor.constraint(equalToConstant: 200),
            startSessionView.heightAnchor.constraint(equalToConstant: 200)
        ])

        startSessionView.backgroundColor = .systemGray3
        startSessionView.layer.shadowColor = UIColor.black.cgColor
        startSessionView.layer.shadowOpacity = 0.2
        startSessionView.layer.shadowOffset = CGSize(width: 0, height: 4)
        startSessionView.layer.shadowRadius = 8

        startSessionLBL.numberOfLines = 2
        startSessionLBL.textAlignment = .center
        startSessionLBL.textColor = .white
        startSessionLBL.font = UIFont.boldSystemFont(ofSize: 30)
        startSessionLBL.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            startSessionLBL.centerXAnchor.constraint(equalTo: startSessionView.centerXAnchor),
            startSessionLBL.centerYAnchor.constraint(equalTo: startSessionView.centerYAnchor),
        ])
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapStartSession))
        startSessionView.isUserInteractionEnabled = true
        startSessionView.addGestureRecognizer(tapGesture)
    }
    private func connectBetweenSessionToTrenee(){}//מתי שהמשתמש סרק את ה nfc
    
    @objc private func didTapStartSession() {
        let storyboard = UIStoryboard(name: "Session", bundle: nil)
        if let sessionVC = storyboard.instantiateViewController(withIdentifier: "SessionViewController") as? SessionViewController {
            sessionVC.modalPresentationStyle = .fullScreen
            self.present(sessionVC, animated: true, completion: nil)
        }
        startSessionLBL.isHidden = true

        scanAnimationView = LottieAnimationView(name: "scanNFC")
        guard let animationView = scanAnimationView else { return }

        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.play()
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: startSessionView.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: startSessionView.centerYAnchor),
            animationView.widthAnchor.constraint(equalTo: startSessionView.widthAnchor, multiplier: 0.9),
            animationView.heightAnchor.constraint(equalTo: startSessionView.heightAnchor, multiplier: 0.9)
        ])

        startSessionLBL.text = "Scan NFC to Start"
        startSessionLBL.font = .systemFont(ofSize: 15, weight: .medium)
        startSessionLBL.isHidden = false

        NSLayoutConstraint.activate([
            startSessionLBL.centerYAnchor.constraint(equalTo: animationView.centerYAnchor, constant: 70),
            startSessionLBL.centerXAnchor.constraint(equalTo: animationView.centerXAnchor)
        ])
        startScanning()
    }
    @IBAction func startScanning() {
        nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        nfcSession?.alertMessage = "Put your iPhone near the card to read it"
        nfcSession?.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("Session invalidated: \(error.localizedDescription)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            for record in message.records {
                if let payload = String(data: record.payload, encoding: .utf8) { print("payload:\(payload), type: \(type(of: payload))")
                    let cleanedPayload = payload.trimmingCharacters(in: .controlCharacters)
                    print("Cleaned payload: \(cleanedPayload)")
                    if cleanedPayload == "123" {
                        print("success")
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                           let storyboard = UIStoryboard(name: "Session", bundle: nil)
                           if let sessionVC = storyboard.instantiateViewController(withIdentifier: "SessionViewController") as? SessionViewController {
                               sessionVC.modalPresentationStyle = .fullScreen
                               self.present(sessionVC, animated: true, completion: nil)
                           }
                        }
                    } else {
                        print("failed")
                    }
                }
            }
        }
    }
        
    private func showSuccessAlert(with message: String) {
        let alert = UIAlertController(title: "NFC Success", message: "תוכן התג: \(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.getSessionHistoryCount()
        return count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "SessionCell")
        
        let date = viewModel.getSessionHistory(at: indexPath.row).object.creationTimestamp

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let timeString = timeFormatter.string(from: date)

        let title = "\(indexPath.row + 1). Date: \(dateString)"
        let subtitle = "Start Time: \(timeString)"

        cell.textLabel?.text = title
        cell.detailTextLabel?.text = subtitle

        cell.imageView?.image = UIImage(systemName: "dumbbell.fill")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("row selected: \(indexPath.row)")
            let session = viewModel.getSessionHistory(at: indexPath.row)
            print("Session.object (Dashboard): \(session)")
            let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
            if let detailVC = storyboard.instantiateViewController(withIdentifier: "SessionDetailsViewController") as? SessionDetailViewController {
                let detailVM = SessionDeteailsViewModel(session: session) { activities in
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                detailVC.configure(with: detailVM)
                detailVC.modalPresentationStyle = .fullScreen
                self.present(detailVC, animated: true, completion: nil)
            }
        }

}
