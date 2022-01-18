import Foundation
import UIKit
import MapKit


extension ViewController {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text?.removeAll()
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getAdress()
        searchBar.text?.removeAll()
        searchBar.endEditing(true)
    }
    private func clean() {
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
                    return
                }
            guard
                let shortestRoute = response.routes
                    .sorted(by: {$0.distance < $1.distance})
                    .first else { return }
            self?.elapsedDistance.text = "Расстояние: \((shortestRoute.distance)/1000) км"
            var time = String(((shortestRoute.expectedTravelTime)/60)/60)
            let roundedTime = time.customRound()
            self?.elapsedTime.text = "Ехать: \(roundedTime) ч"
            UIView.animate(withDuration: 2.0,
                           animations: {
                self?.elapsedDistance.isHidden = false
                self?.elapsedTime.isHidden = false
            })
            self?.mapView.addOverlay(shortestRoute.polyline)
            self?.mapView.setVisibleMapRect(shortestRoute.polyline.boundingMapRect,
                                            animated: true)
        }
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .systemRed
        return render
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
