import Foundation


extension ViewController {
    func setConstraints() {
        
        mapView.frame = view.bounds

        searchField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        searchField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        searchField.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        searchField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        searchField.layer.cornerRadius = 8
        
        locationButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        locationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        locationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        locationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        
        transportTypeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        transportTypeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        transportTypeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        transportTypeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
        goButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        goButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        goButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        goButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        
        mapKindButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        mapKindButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        mapKindButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        mapKindButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        
        remainedDistanceAndTimeStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        remainedDistanceAndTimeStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        remainedDistanceAndTimeStackView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        remainedDistanceAndTimeStackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        directionLabelStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        directionLabelStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 170).isActive = true
        directionLabelStackView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        directionLabelStackView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        goButton.layer.cornerRadius = goButton.frame.height/2
        locationButton.layer.cornerRadius = locationButton.frame.height/2
        mapKindButton.layer.cornerRadius = mapKindButton.frame.height/2
        transportTypeButton.layer.cornerRadius = transportTypeButton.frame.height/2
    }
}
