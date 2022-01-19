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
        
        goButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        goButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        goButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        goButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        
        mapKindButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        mapKindButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        mapKindButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        mapKindButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        
        infoStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        infoStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        infoStackView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        infoStackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        infoStackView1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        infoStackView1.topAnchor.constraint(equalTo: view.topAnchor, constant: 170).isActive = true
        infoStackView1.widthAnchor.constraint(equalToConstant: 200).isActive = true
        infoStackView1.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        goButton.layer.cornerRadius = goButton.frame.height/2
        locationButton.layer.cornerRadius = locationButton.frame.height/2
        mapKindButton.layer.cornerRadius = mapKindButton.frame.height/2
    }
}
