import Foundation
import CoreLocation


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
}
