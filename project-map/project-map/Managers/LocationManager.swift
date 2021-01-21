//
//  LocationManager.swift
//  project-map
//
//  Created by Surya Das on 1/21/21.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject{
    
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    
    override init(){
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
}

extension LocationManager: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {return}
        
        DispatchQueue.main.async{
            self.location = location
        }
    }
}
