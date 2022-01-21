import Foundation
import UIKit
import MapKit
import AVFoundation


extension ViewController {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        for subview in view.subviews where subview != searchBar {
            subview.isUserInteractionEnabled = false
        }
        return true 
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        for subview in view.subviews where subview != searchBar {
            subview.isUserInteractionEnabled = true
        }
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text?.removeAll()
        searchBar.endEditing(true)
        superClean()
        loading.stopAnimating()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getAdress()
        searchBar.text?.removeAll()
        searchBar.endEditing(true)
        loading.startAnimating()
    }
    
    func superClean() {
        stepCounter = 0
        steps.removeAll()
        shortestPath = nil
        ridingStatus = false
        currentSpeedLabel.text = "0 км/ч"
        
        let oldAnnotations = mapView.annotations
        let oldOverLays = mapView.overlays
        mapView.removeAnnotations(oldAnnotations)
        mapView.removeOverlays(oldOverLays)
        
        UIView.animate(withDuration: 2.0,
                       animations: { [weak self] in
            self?.directionLabel.isHidden = true
            self?.remainedTime.isHidden = true
            self?.remainedDistance.isHidden = true
            self?.goButton.isHidden = true
        })
        
        _ = locationManager.monitoredRegions.map{
            locationManager.stopMonitoring(for: $0)
        }
        
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: AVSpeechBoundary.word)
        }
    }
    
    func getAdress() {
        CLGeocoder().geocodeAddressString(searchField.text ?? "") { [weak self] placemarks, error in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                return
            }
            let span = MKCoordinateSpan(latitudeDelta: 0.9,
                                        longitudeDelta: 0.9)
            let region = MKCoordinateRegion(center: location.coordinate,
                                            span: span)
            self?.mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            self?.destinationLocation = location.coordinate
            annotation.title = placemarks.first?.name
            annotation.subtitle = placemarks.first?.country
            self?.mapView.addAnnotation(annotation)
            guard
                let transportType = self?.transportType else { return }
            self?.showPath(destinationCoordinate: location.coordinate,
                           transportType: transportType)
        }
    }
    
    func showPath(destinationCoordinate: CLLocationCoordinate2D, transportType: MKDirectionsTransportType) {
        
        guard
            let sourceCoordinate = locationManager.location?.coordinate
        else { return }
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = sourceItem
        destinationRequest.destination = destinationItem
        destinationRequest.transportType = transportType
        destinationRequest.requestsAlternateRoutes = true
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { [weak self] response, error in
            guard
                let response = response else {
                    let alertVC = UIAlertController()
                    alertVC.addAction(UIAlertAction(title: "Error: Can't built a route, please change transport type",
                                                    style: .default,
                                                    handler: nil))
                    self?.present(alertVC, animated: true, completion: nil)
                    return
                }
            guard
                let shortestRoute = response.routes
                    .sorted(by: {$0.distance < $1.distance})
                    .first else { return }
            self?.shortestPath = shortestRoute
            
            let distance = shortestRoute.distance
            var distanceToDisplay = ""
            if distance < 1000 {
                distanceToDisplay = String(distance).customRound() + " м"
            } else {
                distanceToDisplay = String(distance/1000).customRound() + " км"
            }
            
            let time = shortestRoute.expectedTravelTime
            var timeToDisplay = ""
            
            if time < 3600 {
                timeToDisplay = "\(String(time/60).customRound()) мин"
            } else {
                timeToDisplay = "\(String(time/60/60).customRound()) ч"
            }
            
            UIView.animate(withDuration: 2.0,
                           animations: {
                self?.remainedDistance.isHidden = false
                self?.remainedTime.isHidden = false
                self?.remainedDistance.text = "Расстояние: \(distanceToDisplay)"
                self?.remainedTime.text = "До прибытия: \(timeToDisplay)"
            })
            
            let insets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            
            self?.mapView.addOverlay(shortestRoute.polyline)
            self?.mapView.setVisibleMapRect(shortestRoute.polyline.boundingMapRect,
                                            edgePadding: insets,
                                            animated: true)
            self?.loading.stopAnimating()
            self?.goButton.isHidden = false
        }
    }
    
    func getRouteSteps(route: MKRoute) {

        steps = route.steps
        for i in 0..<steps.count {
            let step = steps[i]
            let region = CLCircularRegion(center: step.polyline.coordinate,
                                          radius: 20,
                                          identifier: "\(i)")
            locationManager.startMonitoring(for: region)
        }
        stepCounter += 1
        let initialMessage = "Через \(String(steps[stepCounter].distance).customRoundNoDots()) метров  \(steps[stepCounter].instructions),ну а потом через \(String(steps[stepCounter + 1].distance).customRoundNoDots()) метров \(steps[stepCounter + 1].instructions)"
        directionLabel.text = initialMessage
        UIView.animate(withDuration: 2.0,
                       animations: { [weak self] in
            self?.directionLabel.isHidden = false
        })
        speak(string: initialMessage)
        guard
            let userLocation = locationManager.location?.coordinate else { return }
        mapView.centerToLocation(center: userLocation)
    }
    
    func calculateRemainedTimeDistanceAndRedrawRoute() {
        guard
            let sourceCoordinate = locationManager.location?.coordinate else { return }
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation)
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = sourceItem
        destinationRequest.destination = destinationItem
        destinationRequest.transportType = transportType
        destinationRequest.requestsAlternateRoutes = true
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { [weak self] response, error in
            
            guard
                let response = response,
                let oldOverLays = self?.mapView.overlays,
                let shortestRoute = response.routes
                    .sorted(by: {$0.distance < $1.distance})
                    .first else { return }
            
            let distance = shortestRoute.distance
            var distanceToDisplay = ""
            if distance < 1000 {
                distanceToDisplay = String(distance).customRound() + " м"
            } else {
                distanceToDisplay = String(distance/1000).customRound() + " км"
            }
            
            let time = shortestRoute.expectedTravelTime
            var timeToDisplay = ""
            
            if time < 3600 {
                timeToDisplay = "\(String(time/60).customRound()) мин"
            } else {
                timeToDisplay = "\(String(time/60/60).customRound()) ч"
            }
            self?.remainedDistance.text = "Расстояние: \(distanceToDisplay)"
            self?.remainedTime.text = "До прибытия: \(timeToDisplay)"
            
            // MARK: Redraw the route
            self?.mapView.removeOverlays(oldOverLays)
            self?.mapView.addOverlay(shortestRoute.polyline)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .systemRed
        return render
    }
    
    func speak(string: String) {
        let speechUtterance = AVSpeechUtterance(string: string)
        if !synthesizer.isSpeaking {
            synthesizer.speak(speechUtterance)
        }
    }
}

extension String {
    func customRound() -> String {
        var result = self
        guard
            let dotIndex = result.firstIndex(of: ".")
        else { return "Error"}
        let index = result.index(after: dotIndex)
        result.removeSubrange(result.index(after: index)..<result.endIndex)
        return result
    }
    
    func customRoundNoDots() -> String {
        var result = self
        guard
            let dotIndex = result.firstIndex(of: ".")
        else { return "Error"}
        result.removeSubrange(dotIndex..<result.endIndex)
        return result
    }
}
