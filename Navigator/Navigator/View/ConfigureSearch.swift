import Foundation
import UIKit
import MapKit
import AVFoundation


extension ViewController {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text?.removeAll()
        searchBar.endEditing(true)
        loading.stopAnimating()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getAdress()
        searchBar.text?.removeAll()
        searchBar.endEditing(true)
        loading.startAnimating()
        stepCounter = 0
    }
    func clean() {
        let oldAnnotations = mapView.annotations
        let oldOverLays = mapView.overlays
        mapView.removeAnnotations(oldAnnotations)
        mapView.removeOverlays(oldOverLays)
    }
    
    func getAdress() {
        clean()
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
            annotation.title = placemarks.first?.name
            annotation.subtitle = placemarks.first?.country
            self?.mapView.addAnnotation(annotation)
            self?.showPath(destinationCoordinate: location.coordinate)
        }
    }
    func showPath(destinationCoordinate: CLLocationCoordinate2D) {
        let sourceCoordinate = mapView.userLocation.coordinate
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = sourceItem
        destinationRequest.destination = destinationItem
        
        destinationRequest.transportType = .automobile
        destinationRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { [weak self] response, error in
            guard
                let response = response else {
                    let alertVC = UIAlertController()
                    alertVC.addAction(UIAlertAction(title: "Error",
                                                    style: .default,
                                                    handler: nil))
                    self?.present(alertVC, animated: true, completion: nil)
                    return
                }
            guard
                let shortestRoute = response.routes
                    .sorted(by: {$0.distance < $1.distance})
                    .first else { return }
            self?.remainedDistance.text = "Расстояние: \((shortestRoute.distance)/1000) км"
            var time = String(((shortestRoute.expectedTravelTime)/60)/60)
            let roundedTime = time.customRound()
            self?.remainedTime.text = "Время в пути: \(roundedTime) ч"
            UIView.animate(withDuration: 2.0,
                           animations: {
                self?.remainedDistance.isHidden = false
                self?.remainedTime.isHidden = false
            })
            let insets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            self?.mapView.addOverlay(shortestRoute.polyline)
            self?.mapView.setVisibleMapRect(shortestRoute.polyline.boundingMapRect,
                                            edgePadding: insets,
                                            animated: true)
            self?.loading.stopAnimating()
            self?.goButton.isHidden = false
            self?.shortestPath = shortestRoute
        }
    }
    func getRouteSteps(route: MKRoute) {
        _ = locationManager.monitoredRegions.map{
            locationManager.stopMonitoring(for: $0)
        }
        steps = route.steps
        for i in 0..<steps.count {
            let step = steps[i]
            let region = CLCircularRegion(center: step.polyline.coordinate,
                                          radius: 20,
                                          identifier: "\(i)")
            locationManager.startMonitoring(for: region)
        }
        stepCounter += 1
        let initialMessage = "Через \(steps[stepCounter].distance) метров  \(steps[stepCounter].instructions),ну а потом через \(steps[stepCounter + 1].distance) метров \(steps[stepCounter + 1].instructions)"
        directionLabel.text = initialMessage
        UIView.animate(withDuration: 2.0,
                       animations: { [weak self] in
            self?.directionLabel.isHidden = false
        })
        speak(string: initialMessage)
        
        if let location = locationManager.location {
            let center = location.coordinate
            mapView.centerToLocation(center: center)
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
    mutating func customRound() -> String {
        guard
            let dotIndex = self.firstIndex(of: ".")
        else { return "Error"}
        let index = self.index(after: dotIndex)
        self.removeSubrange(self.index(after: index)..<self.endIndex)
        return self
    }
}
