//
//  Algorithm.swift
//  MapKitTutorial
//
//  Created by Surya Das on 3/24/21.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class Algorithm : MKMapView
{
    let locationManager = CLLocationManager()
    //let (a,b,c,d) = (0.00,0.00,0.00,0.00)
    let loc1 = CLLocationCoordinate2D.init(latitude: 0.0, longitude: 0.0)
    let loc2 = CLLocationCoordinate2D.init(latitude: 0.0, longitude: 0.0)
    
    
    func distance(startPoint:CLLocationCoordinate2D, endPoint:CLLocationCoordinate2D) -> Double{
        //let distanceValue = startPoint.distance(from: endPoint)
        //return distanceValue;
        //print("Mmmmmmmmmmmmmmmaaaaaaaaaaaaaaaaaaayyyyyyyyyyyyyyyyyyy")
        let start = MKMapPoint(startPoint)
        let end = MKMapPoint(endPoint)
        var distanceValue = start.distance(to: end)
        distanceValue = Double(round(1000*(distanceValue/(1609.344)))/1000)
        return distanceValue
        
    }
}
