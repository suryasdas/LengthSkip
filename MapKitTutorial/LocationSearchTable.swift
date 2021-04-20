//
//  LocationSearchTable.swift
//  MapKitTutorial
//
//  Created by Ajay Singh Bhawariya on 1/24/21.
//

import UIKit
import MapKit
import CoreLocation

class LocationSearchTable : UITableViewController {
    var temp1=CLLocationDegrees()
    var temp2=CLLocationDegrees()
    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate:HandleMapSearch? = nil
    var loc2=CLLocationCoordinate2D.init(latitude: 33.7835274, longitude: -118.1153002)
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
}

extension LocationSearchTable : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        
        
        // func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let mapView = mapView,
              let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
                guard let response = response else {
                    return
                }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
        //}
    }
}


extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
                let selectedItem = matchingItems[indexPath.row].placemark
                cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
                return cell
        }
}

extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        temp1 = loc2.latitude
        temp2 = loc2.longitude
        print(temp1, temp2)
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
        temp1=selectedItem.coordinate.latitude
        temp2=selectedItem.coordinate.longitude
        print("pro1:",temp1)
        print("pro2:",temp2)
    }
    func retrieveLocationlati() -> CLLocationDegrees{
        return temp1
    }
    func retrieveLocationlong() -> CLLocationDegrees{
        return temp2
    }
}
