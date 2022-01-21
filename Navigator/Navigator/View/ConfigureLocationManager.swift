import Foundation
import CoreLocation
import AVFAudio
import MapKit


extension ViewController {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let userCurrentLocation = manager.location?.coordinate,
           let userSpeed = manager.location?.speed {
            // MARK: Real - time coordinates testing
            self.currentCoordinatesLabel.text = "Current longitude: \(String(describing: userCurrentLocation.longitude))\n\n Current latitude: \(String(describing: userCurrentLocation.latitude))"
            if userSpeed > 0 {
                self.currentSpeedLabel.text = String(userSpeed * 3.6).customRound() + " км/ч"
            }
            if ridingStatus {
                mapView.centerToLocation(center: userCurrentLocation)
                // MARK: Let's update remained time, distance and redraw the path
                calculateRemainedTimeDistanceAndRedrawRoute()
            } 
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        stepCounter += 1
        if stepCounter < steps.count {
            let message = "Через \(String(steps[stepCounter].distance).customRoundNoDots()) метров \(steps[stepCounter].instructions)"
            speak(string: message)
            directionLabel.text = message
        } else {
            let message = "С прибытием, вы на месте"
            speak(string: message)
            directionLabel.text = message
        }
    }
}
