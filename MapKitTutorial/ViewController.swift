//
//  ViewController.swift
//  MapKitTutorial
//
//  Created by Ajay Singh Bhawariya on 1/24/21.
//

import UIKit
import MapKit
import CoreLocation

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark) -> MKPlacemark
}

class ViewController : UIViewController,MKMapViewDelegate, UISearchBarDelegate {
    var searchController:UISearchController!
    let locationManager = CLLocationManager()
    var selectedPin:MKPlacemark? = nil
    var resultSearchController:UISearchController? = nil
    var global:MKPlacemark?=nil
    @IBOutlet weak var mapView: MKMapView!
    
    //@IBOutlet weak var searchBar: UISearchBar!
//    @IBAction func showSearchBar(_ sender: AnyObject) {
//        searchController = UISearchController(searchResultsController: nil)
//        searchController.hidesNavigationBarDuringPresentation = true
//        self.searchController.searchBar.delegate = self
//        present(searchController, animated: true, completion: nil)
//    }
    
//    func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//            self.searchBar.endEditing(true)
//        }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff
        // and clear the text in the search bar
        searchBar.text = ""
        // Hide the cancel button
        searchBar.showsCancelButton = true
        searchBar.endEditing(true)
        mapView.removeAnnotations(mapView.annotations)
        followUserLocation()
        
        // You could also change the position, frame etc of the searchBar
    }
    
//    func getDirections(){
//        if let selectedPin = selectedPin {
//            let mapItem = MKMapItem(placemark: selectedPin)
//            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
//            mapItem.openInMaps(launchOptions: launchOptions)
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        let currentLocation = locationManager.location
        
                
        
//        let loc2 = CLLocationCoordinate2D.init(latitude: selectedPin!.coordinate.latitude, longitude: selectedPin!.coordinate.longitude)
        
       // print(currentLocation.coordinate.latitude)
        //print(currentLocation.coordinate.longitude)

        
        
//        var loc1=CLLocationCoordinate2D.init(latitude: 0, longitude: 0)
//        var loc2=CLLocationCoordinate2D.init(latitude: 33.7835274, longitude: -118.1153002)

        
        let LocationSearchTable = storyboard!.instantiateViewController(withIdentifier:"LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: LocationSearchTable)
        resultSearchController?.searchResultsUpdater = LocationSearchTable
        
        let destinationlat=(LocationSearchTable.retrieveLocationlati())
        let destinationlon=(LocationSearchTable.retrieveLocationlong())
        
        let loc1 = CLLocationCoordinate2D.init(latitude: currentLocation!.coordinate.latitude, longitude: (currentLocation?.coordinate.longitude)!)
        
        let loc2 = CLLocationCoordinate2D.init(latitude: destinationlat, longitude: destinationlon)
        
        print("loc1:",loc1)
        print("loc2:",loc2)
        
        
        let sexy=Algorithm()
        var value = sexy.distance(startPoint: loc1, endPoint: loc2)
        print(value)
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Enter Address"
        navigationItem.searchController = resultSearchController
        resultSearchController?.hidesNavigationBarDuringPresentation = true
        resultSearchController?.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        
        LocationSearchTable.mapView = mapView
        LocationSearchTable.handleMapSearchDelegate = self
        
        self.getDirections(loc1: loc1, loc2: loc2)
        
//        while mapView.annotations.isEmpty == false
//        {
//            while searchBar.showsCancelButton == true {
//                <#code#>
//            }
//
//        }
        
    }
    
    func getDirections(loc1: CLLocationCoordinate2D, loc2: CLLocationCoordinate2D) {
       let source = MKMapItem(placemark: MKPlacemark(coordinate: loc1))
       source.name = "Your Location"
       let destination = MKMapItem(placemark: MKPlacemark(coordinate: loc2))
       destination.name = "Destination"
//       MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
// 
//    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
//
//        let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil)
//        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
//
//        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
//        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
//
//        let sourceAnnotation = MKPointAnnotation()
//
//        if let location = sourcePlacemark.location {
//            sourceAnnotation.coordinate = location.coordinate
//        }
//
//        let destinationAnnotation = MKPointAnnotation()
//
//        if let location = destinationPlacemark.location {
//            destinationAnnotation.coordinate = location.coordinate
//        }
//
//        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
//
//        let directionRequest = MKDirections.Request()
//        directionRequest.source = sourceMapItem
//        directionRequest.destination = destinationMapItem
//        directionRequest.transportType = .automobile
//
//        // Calculate the direction
//        let directions = MKDirections(request: directionRequest)
//
//        directions.calculate {
//            (response, error) -> Void in
//
//            guard let response = response else {
//                if let error = error {
//                    print("Error: (error)")
//                }
//
//                return
//            }
//
//            let route = response.routes[0]
//
//            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
//
////            let rect = route.polyline.boundingMapRect
//  //          self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
//        }
//    }

    // MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        let renderer = MKPolylineRenderer(overlay: overlay)

        renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)

        renderer.lineWidth = 5.0

        return renderer
    }
}


extension ViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
            guard let location = locations.last else { return }
            followUserLocation()
            let region = MKCoordinateRegion.init(center: location.coordinate,latitudinalMeters: 4000, longitudinalMeters: 4000)
            mapView.setRegion(region, animated: true)
    }
    
   

    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            followUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show alert
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }

    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // the user didn't turn it on
        }
    }

    func followUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 4000, longitudinalMeters: 4000)
            mapView.setRegion(region, animated: true)
        }
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    //TILL HERE
    
}

extension ViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark) -> MKPlacemark{
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
//        if let city = placemark.locality,
//        let state = placemark.administrativeArea {
//            annotation.subtitle = "(city) (state)"
//        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        return placemark

        
        
// Writing the code to call the mapRoute function when user touches the location
//        if selectedPin.touchUpInside==true {
//            mapRoute(placemark: MKPlacemark)
//        }
    }
    
//    func mapRoute(placemark:MKPlacemark){
//        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
//                CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
//            guard let currentLocation = locationManager.location else {
//                return
//            }
//            //print(currentLocation.coordinate.latitude)
//            //print(currentLocation.coordinate.longitude)
//
//            //@TODO: Modify
//            let loc1 = CLLocationCoordinate2D.init(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
//            let loc2 = CLLocationCoordinate2D.init(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
////            showRouteOnMap(pickupCoordinate: loc1,destinationCoordinate: loc2)
//        }
//    }
}

//extension ViewController : MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
//        if annotation is MKUserLocation {
//            //return nil so map view draws "blue dot" for standard user location
//            return nil
//        }
//        let reuseId = MapPin
//        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
//        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//        pinView?.pinTintColor = UIColor.orange
//        pinView?.canShowCallout = true
//        let smallSquare = CGSize(width: 30, height: 30)
//        let button = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: smallSquare))
//        button.setBackgroundImage(UIImage(named: "Car"), for: [])
//        button.addTarget(self, action: Selector(("getDirections")), for: .touchUpInside)
//        pinView?.leftCalloutAccessoryView = button
//        return pinView
//    }
//}
