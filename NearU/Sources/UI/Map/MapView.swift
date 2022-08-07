//
//  MapView.swift
//

import UIKit
import MapKit

class MapView: UIView {
    
    let map = makeMap()
    let centerButton = makeButton(named: "L", color: .green)
    let addButton = makeButton(named: "+", color: .red)
    weak var delegate: MapViewControllerDelegate?
    var arrAnotation : [MKAnnotation] = []
    override init(frame: CGRect){
        super.init(frame: frame)
        map.showsUserLocation = true
        LocationManager.shared.delegate = self
        addAllSubview()
        setMapConstraint()
        setButtonConstraint()
        setAddButtonConstraint()
        addTarget()
        PlacesManager.shared.placesRepository.fetch()
        updatePlacesOnMap()
        PlacesManager.shared.observerManager.add(subscriber: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
//MARK: -Fabrica UI
private extension MapView {
    private static func  makeMap() -> MKMapView{
        let m = MKMapView()
        m.translatesAutoresizingMaskIntoConstraints = false
        return m
    }
    
    private static func makeButton(named: String , color: UIColor)  -> UIButton{
        let button = UIButton()
        button.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setTitle(named, for: .normal)
        button.backgroundColor = color
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

//MARK: -SetConstrains
private extension MapView {
    private func setMapConstraint() {
        map.topAnchor.constraint(equalTo: topAnchor,constant: 0).isActive = true
        map.bottomAnchor.constraint(equalTo: bottomAnchor,constant: 0).isActive = true
        map.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 0).isActive = true
        map.trailingAnchor.constraint(equalTo: trailingAnchor,constant: 0).isActive = true
    }
    
    private func setButtonConstraint() {
        centerButton.widthAnchor.constraint(equalToConstant:50).isActive = true
        centerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        centerButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        centerButton.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -30).isActive = true
    }
    
    private func setAddButtonConstraint() {
        addButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30).isActive = true
    }
    
}

//MARK: -addSubview
private extension MapView{
    func addAllSubview(){
        addSubview(map)
        addSubview(centerButton)
        addSubview(addButton)
    }
}

//MARK: -addTargetButton
private extension MapView {
    private func addTarget(){
        centerButton.addTarget(self, action: #selector(thumbsUpButtonPressed), for: .touchDownRepeat)
        centerButton.addTarget(self, action: #selector(centerBy), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(presentController), for: .touchUpInside)
    }
    
    @objc func thumbsUpButtonPressed(_ sender: UIButton, event: UIEvent){
        let touch: UITouch = event.allTouches!.first!
        if (touch.tapCount == 2) {
            var maxLatitude  = arrAnotation.first?.coordinate.latitude
            var maxLongitude  = arrAnotation.first?.coordinate.longitude
            var minLatitude = arrAnotation.first?.coordinate.latitude
            var minLongitude = arrAnotation.first?.coordinate.longitude
            
            for currnet in arrAnotation {
                if maxLatitude! < currnet.coordinate.latitude {
                    maxLatitude = currnet.coordinate.latitude
                }
                if maxLongitude! < currnet.coordinate.longitude {
                    maxLongitude = currnet.coordinate.longitude
                }
                
                if minLongitude! > currnet.coordinate.longitude {
                    minLongitude = currnet.coordinate.longitude
                }
                
                if minLatitude! > currnet.coordinate.latitude {
                    minLatitude = currnet.coordinate.latitude
                }
            }
            

            guard minLatitude != nil,maxLatitude != nil , minLongitude != nil , maxLongitude != nil else {
                return
            }
            
            let averageLongitude = (minLongitude! + maxLongitude!)/2
            let averageLatitude = (minLatitude! + maxLatitude!)/2
            let distLong = (maxLongitude! - minLongitude!) * 1.1
            let distLat = (maxLatitude! - minLatitude!) * 1.1
            
            var region = map.region
            region.center = CLLocationCoordinate2D(latitude: averageLatitude, longitude: averageLongitude)
            region.span = .init(latitudeDelta: distLat, longitudeDelta: distLong)
            map.setRegion(region, animated: true)
        }
    }
    
    
    
    @objc func centerBy(){
        map.userTrackingMode = .follow
    }
    
    @objc func presentController() {
        delegate?.popCheckin()
    }
    
    
    
    
}

//MARK: -createNotificationCenter
private extension MapView {
    private func updatePlacesOnMap(){
        var places: [Place] = []
        for i in 0..<(PlacesManager.shared.getArrCount()){
            places.append(PlacesManager.shared.getPlace(at:IndexPath(row: i, section: 0) ))
        }
        for place in places {
            let  annotations = MKPointAnnotation()
            annotations.title = place.name
            annotations.subtitle = place.category + ", " + place.adress
            annotations.coordinate = CLLocationCoordinate2D(
                latitude:CLLocationDegrees(place.lat)!, longitude: CLLocationDegrees(place.long)!)
            map.addAnnotation(annotations)
            arrAnotation.append(annotations)
        }
    }
}
//MARK: -RealizationDelegate
extension MapView: LocationManagerDelegate{
    func newRegionReceived(region:MKCoordinateRegion) {
        map.setRegion(region, animated: true)
    }
}

//MARK: -Delegate
protocol MapViewControllerDelegate : AnyObject {
    func popCheckin()
}

//MARK: -ObserverMAnagerDelegate
extension MapView : ObserverSubscriber {
    func receive(index: IndexPath, event: SubscriptionEvent) {
        switch event {
        case .insert:
            let place = PlacesManager.shared.getPlace(at: index)
            let  annotations = MKPointAnnotation()
            annotations.title = place.name
            annotations.subtitle = place.category + "," + place.adress
            annotations.coordinate = CLLocationCoordinate2D(
                latitude:CLLocationDegrees(place.lat)!, longitude: CLLocationDegrees(place.long)!)
            self.map.addAnnotation(annotations)
            arrAnotation.insert(annotations, at: index.row)
        case .delete:
            self.map.removeAnnotation(arrAnotation[index.row])
            arrAnotation.remove(at: index.row)
        case .update:
            self.map.removeAnnotation(arrAnotation[index.row])
            arrAnotation.remove(at: index.row)
            let place = PlacesManager.shared.getPlace(at: index)
            let  annotations = MKPointAnnotation()
            annotations.title = place.name
            annotations.subtitle = place.category + "," + place.adress
            annotations.coordinate = CLLocationCoordinate2D(
                latitude:CLLocationDegrees(place.lat)!, longitude: CLLocationDegrees(place.long)!)
            self.map.addAnnotation(annotations)
            
        }
    }
    
    func startUp() {
        
    }
    
    func endUp() {
        
    }
}


