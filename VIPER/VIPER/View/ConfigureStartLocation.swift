import Foundation
import UIKit
import MapKit


extension MKMapView {
    
    func centerToLocation() {
        guard
            let userLocation = userLocation.location else { return }
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: userLocation.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
        setUserTrackingMode(.follow,
                            animated: true)
    }
}
