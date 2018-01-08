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
import RevealingSplashView


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
        startSplashView()
        
    }
    
    func startSplashView(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let revealingSplashView = RevealingSplashView(iconImage: #imageLiteral(resourceName: "SplashIcon"),iconInitialSize: CGSize(width: 70, height: 70), backgroundColor: UIColor(red:0.11, green:0.56, blue:0.95, alpha:1.0))
        revealingSplashView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(revealingSplashView)
        revealingSplashView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true;
        revealingSplashView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true;
        revealingSplashView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true;
        revealingSplashView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true;
        revealingSplashView.useCustomIconColor = true
        revealingSplashView.iconColor = UIColor.red
        revealingSplashView.useCustomIconColor = false

        revealingSplashView.startAnimation(){
            print("Completed")
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
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

