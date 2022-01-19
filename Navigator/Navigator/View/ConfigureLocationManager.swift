import Foundation
import CoreLocation
import AVFAudio


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
            let message = "Через \(String(steps[stepCounter].distance).customRoundNoDots()) метров \(steps[stepCounter].instructions)"
            speak(string: message)
        } else {
            let message = "С прибытием, вы на месте"
            speak(string: message)
            directionLabel.text = message
            superClean()
        }
    }
}
