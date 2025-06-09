import UIKit
import Lottie
import CoreNFC

class DashboardViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var startSessionView: UIView!
    @IBOutlet weak var startSessionLBL: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var scanAnimationView: LottieAnimationView?
    private var viewModel : DashboardViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStartSession()
    }
    
    private func setupStartSession() {
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

        let backgroundAnimation = LottieAnimationView(name: "dots")
        backgroundAnimation.translatesAutoresizingMaskIntoConstraints = false
        backgroundAnimation.contentMode = .scaleAspectFit
        backgroundAnimation.loopMode = .loop
        backgroundAnimation.backgroundBehavior = .pauseAndRestore
        backgroundAnimation.alpha = 0.2
        backgroundAnimation.play()
        startSessionView.addSubview(backgroundAnimation)

        NSLayoutConstraint.activate([
            backgroundAnimation.centerXAnchor.constraint(equalTo: startSessionView.centerXAnchor),
            backgroundAnimation.centerYAnchor.constraint(equalTo: startSessionView.centerYAnchor),
            backgroundAnimation.widthAnchor.constraint(equalTo: startSessionView.widthAnchor, multiplier: 0.9),
            backgroundAnimation.heightAnchor.constraint(equalTo: startSessionView.heightAnchor, multiplier: 0.9)
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapStartSession))
        startSessionView.isUserInteractionEnabled = true
        startSessionView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapStartSession() {
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let storyboard = UIStoryboard(name: "Session", bundle: nil)
            if let sessionVC = storyboard.instantiateViewController(withIdentifier: "SessionViewController") as? SessionViewController {
                sessionVC.modalPresentationStyle = .fullScreen
                self.present(sessionVC, animated: true, completion: nil)
            }
        }
    }
    private func setupTableView(){
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getSessionHistoryCount()
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SessionCell", for: indexPath)
        let date = viewModel.getSessionHistory(at: indexPath.row).object.creationTimestamp
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let timeString = timeFormatter.string(from: date)

        let title = "\(indexPath.row + 1). Date: \(dateString)"
        let subtitle = "Time: \(timeString)"

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
}
