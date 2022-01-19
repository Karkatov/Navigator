import UIKit
import MapKit

final class TransportTypeViewController: UIViewController {
    
    public var completion: ((MKDirectionsTransportType?) -> Void)?
    
    private let setWalkingTypeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "figure.walk"),
                     for: .normal)
        btn.addTarget(self,
                      action: #selector(setWalking), for: .touchUpInside)
        return btn
    }()
    @objc private func setWalking() {
        completion?(MKDirectionsTransportType.walking)
        dismiss(animated: true, completion: nil)
    }
    private let setCarTypeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "car.fill"),
                     for: .normal)
        btn.addTarget(self,
                      action: #selector(setCar), for: .touchUpInside)
        return btn
    }()
    @objc private func setCar() {
        completion?(MKDirectionsTransportType.automobile)
        dismiss(animated: true, completion: nil)
    }
    
    private let transportTypeStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.backgroundColor = .clear
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.layer.borderColor = UIColor.black.cgColor
        stack.layer.cornerRadius = 8
        stack.layer.borderWidth = 1
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        transportTypeStackView.addArrangedSubview(setWalkingTypeButton)
        transportTypeStackView.addArrangedSubview(setCarTypeButton)
        view.addSubview(transportTypeStackView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        transportTypeStackView.center = view.center
        transportTypeStackView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        transportTypeStackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
}
