import UIKit
import MapKit
import Contacts
import CoreLocation
import AVFAudio


protocol UserView {
    var presenter: UserPresenter? { get set }
    func updateView()
}

final class ViewController: UIViewController, UserView, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {
        
    var presenter: UserPresenter?
    var stepCounter = 0 
    var synthesizer = AVSpeechSynthesizer()
    var steps: [MKRoute.Step] = []
    var shortestPath: MKRoute?
    var transportType: MKDirectionsTransportType = .automobile
    var destinationLocation = CLLocationCoordinate2D()
    var ridingStatus = false {
        didSet {
            goButton.setTitle(ridingStatus ? "Стоп" : "В путь",
                              for: .normal)
            ridingStatus ? (UIApplication.shared.isIdleTimerDisabled = true) : (UIApplication.shared.isIdleTimerDisabled = false)
        }
    }
    
    let currentCoordinatesLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Start monitoring..."
        lbl.backgroundColor = .clear
        lbl.textColor = .label.withAlphaComponent(0.5)
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 15, weight: .bold)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let currentSpeedLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "0 км/ч"
        lbl.backgroundColor = .clear
        lbl.textColor = .label.withAlphaComponent(0.5)
        lbl.numberOfLines = 1
        lbl.font = .systemFont(ofSize: 80, weight: .bold)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let loading: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        loading.hidesWhenStopped = true
        loading.style = .whiteLarge
        return loading
    }()
    
    let remainedTime: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label.withAlphaComponent(0.5)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.font = .systemFont(ofSize: 15, weight: .bold)
        lbl.backgroundColor = .clear
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let remainedDistance: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15, weight: .bold)
        lbl.textColor = .label.withAlphaComponent(0.5)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.backgroundColor = .clear
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let remainedDistanceAndTimeStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let directionLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label.withAlphaComponent(0.5)
        lbl.numberOfLines = 0
        lbl.adjustsFontSizeToFitWidth = true
        lbl.backgroundColor = .clear
        lbl.font = .systemFont(ofSize: 15, weight: .bold)
        return lbl
    }()
    
    let directionLabelStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let goButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .red
        btn.alpha = 0.5
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("В путь",
                     for: .normal)
        return btn
    }()
    
    let searchField: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Search for..."
        search.translatesAutoresizingMaskIntoConstraints = false
        search.tintColor = .white
        search.showsCancelButton = true
        search.searchBarStyle = .minimal
        return search
    }()
    
    let mapKindButton: UIButton = {
        let btn = UIButton()
        btn.alpha = 0.5
        btn.backgroundColor = .label
        btn.setImage(UIImage(systemName: "map.fill"),
                     for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let transportTypeButton: UIButton = {
        let btn = UIButton()
        btn.alpha = 0.5
        btn.backgroundColor = .label
        btn.setImage(UIImage(systemName: "car.fill"),
                     for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let subwayButton: UIButton = {
        let btn = UIButton()
        btn.alpha = 0.5
        btn.backgroundColor = .label
        btn.setImage(UIImage(systemName: "tram.fill.tunnel"),
                     for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let locationManager: CLLocationManager = {
        let loc = CLLocationManager()
        loc.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        loc.distanceFilter = 5
        loc.startUpdatingLocation()
        return loc
    }()
    
    let mapView: MKMapView = {
        let map = MKMapView()
        map.showsCompass = true
        map.showsUserLocation = true
        map.showsTraffic = true
        map.showsScale = true
        map.showsBuildings = true
        map.mapType = .standard
        return map
    }()
    
    let locationButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .label
        btn.alpha = 0.5
        btn.setImage(UIImage(systemName: "location.north.fill"),
                     for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    func updateView() {
        //
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGestureMapKindButtonPolitics()
        setGestureGoButtonPolitics()
        setGestureLocationButtonPolitics()
        setGestureTransportTypeButtonPolitics()
        setGestureSubwayButtonPolitics()
        view.addSubview(mapView)
        view.addSubview(loading)
        view.addSubview(searchField)
        view.addSubview(locationButton)
        view.addSubview(mapKindButton)
        view.addSubview(goButton)
        view.addSubview(transportTypeButton)
        view.addSubview(subwayButton)
        view.addSubview(currentCoordinatesLabel)
        view.addSubview(currentSpeedLabel)
        remainedDistanceAndTimeStackView.addArrangedSubview(remainedDistance)
        remainedDistanceAndTimeStackView.addArrangedSubview(remainedTime)
        directionLabelStackView.addArrangedSubview(directionLabel)
        view.addSubview(remainedDistanceAndTimeStackView)
        view.addSubview(directionLabelStackView)
        mapView.delegate = self
        searchField.delegate = self
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        remainedTime.isHidden = true
        remainedDistance.isHidden = true
        directionLabel.isHidden = true
        goButton.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.navigationBar.isHidden = true
        setConstraints()
        loading.center = view.center
    }
}

