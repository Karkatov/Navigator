import Foundation
import UIKit



extension ViewController {
    func setGesturePolitics() {
        let gesture = UILongPressGestureRecognizer(target: self,
                                                   action: #selector(tap))
        locationButton.addGestureRecognizer(gesture)
        gesture.minimumPressDuration = 0 
    }
    @objc private func tap(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            locationButton.alpha = 1.0
            mapView.centerToLocation()
        } else {
            locationButton.alpha = 0.5
        }
    }
    func setGesturePolitics1() {
        let gesture = UILongPressGestureRecognizer(target: self,
                                                   action: #selector(tap1))
        mapKindButton.addGestureRecognizer(gesture)
        gesture.minimumPressDuration = 0
    }
    @objc private func tap1(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            mapKindButton.alpha = 1.0
            let chooseVC = ChooseMapStyleViewController()
            chooseVC.completion = { [weak self] style in
                guard
                    let unwrappedStyle = style else { return }
                self?.mapView.mapType = unwrappedStyle
            }
            chooseVC.modalTransitionStyle = .crossDissolve
            chooseVC.modalPresentationStyle = .overCurrentContext
            present(chooseVC,
                    animated: true,
                    completion: nil)
        } else {
            mapKindButton.alpha = 0.5
        }
    }
}
