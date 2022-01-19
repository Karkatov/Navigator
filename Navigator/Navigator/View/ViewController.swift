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
    var status = false 
    
    let loading: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        loading.hidesWhenStopped = true
        loading.style = .white
        return loading
    }()
    
    let remainedTime: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.adjustsFontSizeToFitWidth = true
        lbl.backgroundColor = .white.withAlphaComponent(0.5)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    let remainedDistance: UILabel = {
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
    let directionLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.numberOfLines = 0
        lbl.adjustsFontSizeToFitWidth = true
        lbl.backgroundColor = .white.withAlphaComponent(0.5)
        return lbl
    }()
    let infoStackView1: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    let goButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("В путь",
                     for: .normal)
        btn.backgroundColor = .red.withAlphaComponent(0.5)
        btn.translatesAutoresizingMaskIntoConstraints = false 
        return btn
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
        setGesturePolitics2()
        view.addSubview(mapView)
        view.addSubview(loading)
        view.addSubview(searchField)
        view.addSubview(locationButton)
        view.addSubview(mapKindButton)
        view.addSubview(goButton)
        infoStackView.addArrangedSubview(remainedDistance)
        infoStackView.addArrangedSubview(remainedTime)
        infoStackView1.addArrangedSubview(directionLabel)
        view.addSubview(infoStackView)
        view.addSubview(infoStackView1)
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

