import Foundation
import UIKit
import MapKit


extension MKMapView {
    
    func centerToLocation(center: CLLocationCoordinate2D) {
        let regionRadius: CLLocationDistance = 500
        let coordinateRegion = MKCoordinateRegion(center: center,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
        if userTrackingMode == .followWithHeading {
            userTrackingMode = .follow
        } else {
            userTrackingMode = .followWithHeading
        }
    }
}
