//
//  ViewController.swift
//  WannaFind
//
//  Created by Luis Santiago  on 12/26/17.
//  Copyright © 2017 Luis Santiago . All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Floaty
import CoreLocation


class MapController: UIViewController , GMSMapViewDelegate{

    var resultsViewController: GMSAutocompleteResultsViewController?
    
    var searchController: UISearchController?
    
    var mapView : GMSMapView?
    
    var locationManager = CLLocationManager()
    
    var placesClient : GMSPlacesClient!

    var cameraZoom : Float = 17.0
    
    let userModalView = UserViewModel(User(origin: CLLocationCoordinate2D(), destination: CLLocationCoordinate2D()))
    
    
    let imageMarker : UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "icons8-marker-100(1)"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image;
    }()


    func handleLocationUpdate( _ : FloatyItem){
        print("Update location")
    }
    
    func handleTravelAlarm(_ : FloatyItem){
        let detailController = DetailRideController();
        detailController.currentUser = userModalView.getCompleteInformation
        detailController.modalPresentationStyle = .custom
        present(detailController, animated: true, completion: nil)
        print("FINAL LOCATIONS\(userModalView.originUserLocation) \(userModalView.destinationLocation)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNavBar()
        mapView = createMapView()
        loadMap()
        loadSearchBar()
        loadFloatingActionButton()
        loadLocation()
    }
    
    func loadFloatingActionButton(){
        let floatingActionButton = generateFloatingActionButton(handleLocationUpdate: handleLocationUpdate, handleAlarmTravel: handleTravelAlarm)
        self.view.addSubview(floatingActionButton)
    }
    
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let coordinate = mapView.projection.coordinate(for: imageMarker.center)
        userModalView.destinationLocation = coordinate
    }
    
}

extension MapController : CLLocationManagerDelegate{
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        userModalView.originUserLocation = location.coordinate
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: cameraZoom)
        if (mapView?.isHidden)! {
            mapView?.isHidden = false
            mapView?.camera = camera
        } else {
            mapView?.animate(to: camera)
        }
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView?.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

