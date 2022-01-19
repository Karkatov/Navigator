import Foundation
import UIKit
import AVFoundation



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
            let userLocation = mapView.userLocation.coordinate
            mapView.centerToLocation(center: userLocation)
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
    func setGesturePolitics2() {
        let gesture = UILongPressGestureRecognizer(target: self,
                                                   action: #selector(tap2))
        goButton.addGestureRecognizer(gesture)
        gesture.minimumPressDuration = 0
    }
    @objc private func tap2(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            goButton.backgroundColor = .red.withAlphaComponent(1.0)
            
            if status == false {
                if let unwrapped = shortestPath {
                    goButton.setTitle("Стоп", for: .normal)
                    getRouteSteps(route: unwrapped)
                    status = true
                }
            } else {
                goButton.setTitle("В путь", for: .normal)
                UIView.animate(withDuration: 2.0,
                               animations: { [weak self] in
                    self?.directionLabel.isHidden = true
                    self?.remainedTime.isHidden = true
                    self?.remainedDistance.isHidden = true
                    self?.goButton.isHidden = true 
                })
                stepCounter = 0
                _ = locationManager.monitoredRegions.map{
                    locationManager.stopMonitoring(for: $0)
                }
                clean()
                let location = mapView.userLocation.coordinate
                mapView.centerToLocation(center: location)
                steps.removeAll()
                status = false
                if synthesizer.isSpeaking {
                    synthesizer.stopSpeaking(at: AVSpeechBoundary.word)
                }
                shortestPath = nil
            }
            
        } else {
            goButton.backgroundColor = .red.withAlphaComponent(0.5)
        }
    }
}
