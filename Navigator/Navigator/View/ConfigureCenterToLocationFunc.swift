import Foundation
import UIKit
import MapKit


extension MKMapView {
    
    func centerToLocation(center: CLLocationCoordinate2D) {
        setUserTrackingMode(.follow, animated: true)
    }
}
