//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by HongDi Huang on 2025/1/20.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject {
    
    private let locationManager = CLLocationManager()
    private var completionHandler: ((CLLocationCoordinate2D?, Error?) -> Void)?
    
    required override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    private func checkLocationAuthorization() {
        
        locationManager.startUpdatingLocation()
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location restricted")
        case .denied:
            print("Location denied")
            completionHandler?(nil, MessageError.textError("Please open location permission in your setting"))
        case .authorizedAlways:
            print("Location authorizedAlways")
        case .authorizedWhenInUse:
            print("Location authorized when in use")
        @unknown default:
            print("Location service disabled")
            completionHandler?(nil, MessageError.textError("Please open location permission in your setting"))
        }
        
    }
    
    func fetchAddress(location: CLLocationCoordinate2D) -> AnyPublisher<String, Error> {
        
        return Future { promise in
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    print("Error during reverse geocoding: \(error.localizedDescription)")
                    promise(.failure(MessageError.textError("Unable to fetch address")))
                    return
                }
                
                if let placemark = placemarks?.first {
                    var addressString = ""
                    if let subThoroughfare = placemark.subThoroughfare {
                        addressString += subThoroughfare + " "
                    }
                    if let thoroughfare = placemark.thoroughfare {
                        addressString += thoroughfare + ", "
                    }
                    if let locality = placemark.locality {
                        addressString += locality + ", "
                    }
                    if let administrativeArea = placemark.administrativeArea {
                        addressString += administrativeArea + " "
                    }
                    if let postalCode = placemark.postalCode {
                        addressString += postalCode + ", "
                    }
                    if let country = placemark.country {
                        addressString += country
                    }
                    promise(.success(addressString))
                } else {
                    promise(.success("No address found"))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    
    func requestLocationPermission() {
        checkLocationAuthorization()
    }
    
    func getCurrentLocation(completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        self.completionHandler = completion
        locationManager.startUpdatingLocation()
    }
}


extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            completionHandler?(location.coordinate, nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completionHandler?(nil, nil)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {//Trigged every time authorization status changes
        checkLocationAuthorization()
    }
}
