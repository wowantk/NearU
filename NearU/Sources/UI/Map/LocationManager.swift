//
//  LocationManager.swift
//

import Foundation
import CoreLocation
import MapKit

final class LocationManager:NSObject{
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    weak var delegate:LocationManagerDelegate?
    
    static let shared = LocationManager()
    
    
    private override init() {}
}

//MARK: -IternalInterface
extension LocationManager {
    func checkLocationService() {
        locationManager.distanceFilter = 250
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            createAlert(name: "Turn On", info: "Turn On Location")
        }
        
    }
    
    func getLongitude() -> String {
        if let long = locationManager.location?.coordinate.longitude{
            return "\(long)"
        }else{
            return "0"
        }
    }
    
    func getLatitude() -> String {
        if let lattid = locationManager.location?.coordinate.latitude{
            return "\(lattid)"
        }else{
            return "0"
        }
    }
}

//MARK: -PrivateInterface

private extension LocationManager {
    private func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            delegate?.newRegionReceived(region: region)
            
        }
    }
    
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            createAlert(name: "Error", info: "Turn On ur Location")
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            createAlert(name: "Error", info: "Smth wrhg with your adult permission")
            break
        case .authorizedAlways:
            break
        default:
            
            break
        }
    }
    
    private func createAlert(name:String,info:String) {
        let alertController = UIAlertController(title: name, message: info, preferredStyle: .alert)
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}


//MARK: -LocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        delegate?.newRegionReceived(region: region)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

//MARK: -LocationManagerDelegate
protocol LocationManagerDelegate : AnyObject {
    func newRegionReceived(region:MKCoordinateRegion)
}



