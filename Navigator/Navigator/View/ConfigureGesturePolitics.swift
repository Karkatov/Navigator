import Foundation
import UIKit
import AVFoundation



extension ViewController {
    func setGestureLocationButtonPolitics() {
        let gesture = UILongPressGestureRecognizer(target: self,
                                                   action: #selector(tapLocation))
        locationButton.addGestureRecognizer(gesture)
        gesture.minimumPressDuration = 0
    }
    @objc private func tapLocation(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            locationButton.alpha = 1.0
            let userLocation = mapView.userLocation.coordinate
            mapView.centerToLocation(center: userLocation)
        } else {
            locationButton.alpha = 0.5
        }
    }
    func setGestureMapKindButtonPolitics() {
        let gesture = UILongPressGestureRecognizer(target: self,
                                                   action: #selector(tapMapKind))
        mapKindButton.addGestureRecognizer(gesture)
        gesture.minimumPressDuration = 0
    }
    @objc private func tapMapKind(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            mapKindButton.alpha = 1.0
            let chooseVC = MapStyleViewController()
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
    func setGestureGoButtonPolitics() {
        let gesture = UILongPressGestureRecognizer(target: self,
                                                   action: #selector(tapGo))
        goButton.addGestureRecognizer(gesture)
        gesture.minimumPressDuration = 0
    }
    @objc private func tapGo(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            goButton.backgroundColor = .red.withAlphaComponent(1.0)
            
            if ridingStatus == false {
                if let unwrapped = shortestPath {
                    goButton.setTitle("Стоп", for: .normal)
                    getRouteSteps(route: unwrapped)
                    ridingStatus = true
                }
            } else {
                goButton.setTitle("В путь", for: .normal)
                superClean()
            }
        } else {
            goButton.backgroundColor = .red.withAlphaComponent(0.5)
        }
    }
    
    func setGestureTransportTypeButtonPolitics() {
        let gesture = UILongPressGestureRecognizer(target: self,
                                                   action: #selector(tapTransportType))
        transportTypeButton.addGestureRecognizer(gesture)
        gesture.minimumPressDuration = 0
    }
    @objc private func tapTransportType(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            transportTypeButton.alpha = 1.0
            let chooseTransportTypeVC = TransportTypeViewController()
            chooseTransportTypeVC.completion = { [weak self] type in
                guard
                    let unwrappedTransportType = type else { return }
                self?.transportType = unwrappedTransportType
                if unwrappedTransportType == .walking {
                    self?.transportTypeButton.setImage(UIImage(systemName: "figure.walk"),
                                                       for: .normal)
                } else {
                    self?.transportTypeButton.setImage(UIImage(systemName: "car.fill"),
                                                       for: .normal)
                }
            }
            chooseTransportTypeVC.modalTransitionStyle = .crossDissolve
            chooseTransportTypeVC.modalPresentationStyle = .overCurrentContext
            present(chooseTransportTypeVC,
                    animated: true,
                    completion: nil)
        } else {
            transportTypeButton.alpha = 0.5
        }
    }
}
