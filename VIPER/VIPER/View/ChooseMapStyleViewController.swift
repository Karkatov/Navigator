import UIKit
import MapKit

final class ChooseMapStyleViewController: UIViewController {
    
    public var completion: (((MKMapType)?) -> Void)?

    private let standardButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Standard", for: .normal)
        btn.addTarget(self,
                      action: #selector(setStandardStyle), for: .touchUpInside)
        btn.setTitleColor(.label, for: .normal)
        return btn
    }()
    @objc private func setStandardStyle(){
        completion?(MKMapType.standard)
        dismiss(animated: true, completion: nil)
    }
    private let hybridButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Hybrid", for: .normal)
        btn.setTitleColor(.label, for: .normal)
        btn.addTarget(self,
                      action: #selector(setHybridStyle), for: .touchUpInside)
        return btn
    }()
    @objc private func setHybridStyle(){
        completion?(MKMapType.hybrid)
        dismiss(animated: true, completion: nil)
    }
    private let hybridFlyoverButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.label, for: .normal)
        btn.setTitle("Hybrid Flyover", for: .normal)
        btn.addTarget(self,
                      action: #selector(setHybridFlyOverStyle), for: .touchUpInside)
        return btn
    }()
    @objc private func setHybridFlyOverStyle(){
        completion?(MKMapType.hybridFlyover)
        dismiss(animated: true, completion: nil)
    }
    private let mutedStandardButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.label, for: .normal)
        btn.setTitle("Muted Standard", for: .normal)
        btn.addTarget(self,
                      action: #selector(setMutedStandardStyle), for: .touchUpInside)
        return btn
    }()
    @objc private func setMutedStandardStyle(){
        completion?(MKMapType.mutedStandard)
        dismiss(animated: true, completion: nil)
    }
    private let satelliteButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.label, for: .normal)
        btn.setTitle("Satellite", for: .normal)
        btn.addTarget(self,
                      action: #selector(setSatteliteStyle), for: .touchUpInside)
        return btn
    }()
    @objc private func setSatteliteStyle(){
        completion?(MKMapType.satellite)
        dismiss(animated: true, completion: nil)
    }
    private let satelliteFlyoverButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.label, for: .normal)
        btn.setTitle("Satellite Flyover", for: .normal)
        btn.addTarget(self,
                      action: #selector(setSatteliteFlyOverStyle), for: .touchUpInside)
        return btn
    }()
    @objc private func setSatteliteFlyOverStyle(){
        completion?(MKMapType.satelliteFlyover)
        dismiss(animated: true, completion: nil)
    }
    private let viewStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
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
        viewStack.addArrangedSubview(standardButton)
        viewStack.addArrangedSubview(hybridButton)
        viewStack.addArrangedSubview(hybridFlyoverButton)
        viewStack.addArrangedSubview(satelliteButton)
        viewStack.addArrangedSubview(satelliteFlyoverButton)
        viewStack.addArrangedSubview(mutedStandardButton)
        view.addSubview(viewStack)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewStack.center = view.center
        viewStack.widthAnchor.constraint(equalToConstant: 200).isActive = true
        viewStack.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
}
