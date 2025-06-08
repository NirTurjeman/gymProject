import UIKit
import Lottie
import CoreNFC

class DashboardViewController: UIViewController {
    @IBOutlet weak var startSessionView: UIView!
    @IBOutlet weak var startSessionLBL: UILabel!
    private var scanAnimationView: LottieAnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStartSession()
    }
    
    private func setupStartSession() {
        startSessionView.layer.cornerRadius = startSessionView.frame.width / 2
        startSessionView.layer.masksToBounds = false

        NSLayoutConstraint.activate([
            startSessionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startSessionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        startSessionView.backgroundColor = .systemGray3
        startSessionView.layer.shadowColor = UIColor.black.cgColor
        startSessionView.layer.shadowOpacity = 0.2
        startSessionView.layer.shadowOffset = CGSize(width: 0, height: 4)
        startSessionView.layer.shadowRadius = 8

        startSessionLBL.numberOfLines = 2
        startSessionLBL.textAlignment = .center
        startSessionLBL.textColor = .white
        startSessionLBL.font = UIFont.boldSystemFont(ofSize: 35)
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
        startSessionLBL.font = .systemFont(ofSize: 18, weight: .medium)
        startSessionLBL.isHidden = false

        NSLayoutConstraint.activate([
            startSessionLBL.centerYAnchor.constraint(equalTo: animationView.centerYAnchor, constant: 70),
            startSessionLBL.centerXAnchor.constraint(equalTo: animationView.centerXAnchor)
        ])
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let storyboard = UIStoryboard(name: "Session", bundle: nil)
            if let sessionVC = storyboard.instantiateViewController(withIdentifier: "SessionViewController") as? SessionViewController {
                sessionVC.modalPresentationStyle = .fullScreen
                self.present(sessionVC, animated: true, completion: nil)
            }
        }
    }
}
