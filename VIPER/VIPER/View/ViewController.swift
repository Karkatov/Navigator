import UIKit
import MapKit
import Contacts
import CoreLocation


protocol UserView {
    var presenter: UserPresenter? { get set }
    func updateView()
}

final class ViewController: UIViewController, UserView, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {
    
    var presenter: UserPresenter?
    
    let elapsedTime: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.adjustsFontSizeToFitWidth = true
        lbl.backgroundColor = .white.withAlphaComponent(0.5)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    let elapsedDistance: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.adjustsFontSizeToFitWidth = true
        lbl.backgroundColor = .white.withAlphaComponent(0.5)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    let infoStackView: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let searchField: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Search for..."
        search.translatesAutoresizingMaskIntoConstraints = false
        search.tintColor = .label
        search.showsCancelButton = true
        search.searchBarStyle = .minimal
        return search
    }()
    
    let mapKindButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.alpha = 0.5
        btn.setImage(UIImage(systemName: "eye"),
                     for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
        
    let locationManager: CLLocationManager = {
        let loc = CLLocationManager()
        loc.desiredAccuracy = 1.0
        loc.distanceFilter = 10
        return loc
    }()
    
    let mapView: MKMapView = {
       let map = MKMapView()
        map.showsCompass = true
        map.showsUserLocation = true
        map.showsTraffic = true
        map.showsScale = true
        map.showsBuildings = true
        map.mapType = .hybridFlyover
        return map
    }()
    
    let locationButton: UIButton = {
       let btn = UIButton()
        btn.backgroundColor = .white
        btn.alpha = 0.5
        btn.setImage(UIImage(systemName: "location.fill"),
                     for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    func updateView() {
        // 
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setGesturePolitics()
        setGesturePolitics1()
        view.addSubview(mapView)
        view.addSubview(searchField)
        view.addSubview(locationButton)
        view.addSubview(mapKindButton)
        infoStackView.addArrangedSubview(elapsedDistance)
        infoStackView.addArrangedSubview(elapsedTime)
        view.addSubview(infoStackView)
        mapView.delegate = self
        searchField.delegate = self
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        elapsedTime.isHidden = true
        elapsedDistance.isHidden = true
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.navigationBar.isHidden = true
        setConstraints()
    }
}

