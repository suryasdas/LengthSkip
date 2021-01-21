//
//  ContentView.swift
//  project-map
//
//  Created by Surya Das on 1/21/21.
//

//import SwiftUI
//import MapKit
//import Combine
//struct ContentView: View {
//    @ObservedObject private var locationManager = LocationManager()
//    @State private var region = MKCoordinateRegion.defaultRegion
//    @State private var cancellable: AnyCancellable?
//    private func setCurrentLocation() {
//        cancellable = locationManager.$location.sink { location in
//            region = MKCoordinateRegion(center: location?.coordinate ?? CLLocationCoordinate2D(), latitudinalMeters: 500, longitudinalMeters: 500)
//        }
//    }
//    var body: some View {
//        VStack {
//            if locationManager.location != nil {
//                Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: nil)
//            } else {
//                Text("Locating user location...")
//            }
//        }
//        .onAppear {
//            setCurrentLocation()
//        }
//    }
//}
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

import SwiftUI
import MapKit
import CoreLocation
import Combine

//struct MapViewUIKit: UIViewRepresentable {
//    let region: MKCoordinateRegion
//    let mapType : MKMapType
//
//    func makeUIView(context: Context) -> MKMapView {
//        let mapView = MKMapView()
//        mapView.setRegion(region, animated: false)
//        mapView.mapType = mapType
//        return mapView
//    }
//
//    func updateUIView(_ mapView: MKMapView, context: Context) {
//        mapView.mapType = mapType
//    }
//}

struct ContentView: View {
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.61900, longitude: -74.14053) , span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    @State var track : MapUserTrackingMode = .follow
    @State var mapType: MKMapType = .standard
    var body: some View {
        Home()
//        ZStack {
//
//            MapViewUIKit(region: region, mapType: mapType)
//                .edgesIgnoringSafeArea(.all)
//
//            VStack {
//                Spacer()
//
//                Picker("", selection: $mapType) {
//                    Text("Standard").tag(MKMapType.standard)
//                    Text("Satellite").tag(MKMapType.satellite)
//                    Text("Hybrid").tag(MKMapType.hybrid)
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .offset(y: -40)
//                .font(.largeTitle)
//            }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View{
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.61900, longitude: -74.14053) , span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    @State var track : MapUserTrackingMode = .follow
    @State var mapType: MKMapType = .standard
    @State var manager = CLLocationManager()
    @StateObject var managerDelegate = locationDelegate()
    
    var body: some View{
        VStack{
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: $track)
        }
        .onAppear{
            manager.delegate = managerDelegate
        }
    }
}

class locationDelegate: NSObject,ObservableObject,CLLocationManagerDelegate{
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            print("authorized!")
            
        }
        else{
            print("not authorized")
            manager.requestWhenInUseAuthorization()
        }
    }
}


//import SwiftUI
//import MapKit
//
//struct Place: Identifiable {
//    let id = UUID()
//    let name: String
//    let latitude: Double
//    let longitude: Double
//    var coordinate: CLLocationCoordinate2D {
//        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//    }
//}
//
//struct ContentView: View {
//    // 1.
//    let places = [
//        Place(name: "British Museum", latitude: 51.519581, longitude: -0.127002),
//        Place(name: "Tower of London", latitude: 51.508052, longitude: -0.076035),
//        Place(name: "Big Ben", latitude: 51.500710, longitude: -0.124617)
//    ]
//
//    // 2.
//    @State var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 51.514134, longitude: -0.104236),
//        span: MKCoordinateSpan(latitudeDelta: 0.075, longitudeDelta: 0.075))
//
//
//    var body: some View {
//        // 3.
//        Map(coordinateRegion: $region, annotationItems: places) { place in
//            // Insert an annotation type here
//            //MapPin(coordinate: place.coordinate)
//            MapMarker(coordinate: place.coordinate)
//
//           /* MapAnnotation(coordinate: place.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
//                Circle()
//                    .strokeBorder(Color.red, lineWidth: 10)
//                    .frame(width: 44, height: 44)
//            }*/
//        }
//
//        .ignoresSafeArea(.all)
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
