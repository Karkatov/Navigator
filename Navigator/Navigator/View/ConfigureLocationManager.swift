import Foundation
import CoreLocation
import AVFAudio
import MapKit


extension ViewController {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        print("Location found")
        //        guard
        //            let userLocation = locations.first else { return }
        //        print("altitude: \(userLocation.altitude)")
        //        print("coordinate\(userLocation.coordinate)")
        //        print("course\(userLocation.course)")
        //        print("courseAccuracy\(userLocation.courseAccuracy)")
        //        print("ellipsoidalAltitude\(userLocation.ellipsoidalAltitude)")
        //        print("floor\(userLocation.floor?.level)")
        //        print("speed\(userLocation.speed)")
        //        print("description\(userLocation.description)")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        stepCounter += 1
        if stepCounter < steps.count {
            // MARK: Let's update remained time and distance info for user
            let sourceCoordinate = mapView.userLocation.coordinate
            
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
            }
            let message = "Через \(String(steps[stepCounter].distance).customRoundNoDots()) метров \(steps[stepCounter].instructions)"
            speak(string: message)
            directionLabel.text = message
            
        } else {
            
            let queue = DispatchQueue.global(qos: .userInteractive)
            queue.sync {
                let message = "С прибытием, вы на месте"
                speak(string: message)
                directionLabel.text = message
            }
            queue.sync {
                if !synthesizer.isSpeaking {
                    superClean()
                }
            }
        }
    }
}
