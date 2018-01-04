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
    
    var resultView: UITextView?
    
    var mapView : GMSMapView?
    
    var locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    
    var placesClient : GMSPlacesClient!
    
    var userLocation : CLLocationCoordinate2D?
    
    var cameraZoom : Float = 17.0
    
    
    let imageMarker : UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "icons8-marker-100(1)"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image;
    }()

    func createMapView ()-> GMSMapView{
        let map = GMSMapView();
        map.translatesAutoresizingMaskIntoConstraints = false
        let camera = GMSCameraPosition.camera(withLatitude: 18.134542, longitude: -94.498825, zoom: cameraZoom)
        map.camera = camera
        map.settings.zoomGestures = false
        map.isMyLocationEnabled = true
        
        do {
            if let styleURL = Bundle.main.url(forResource: "map-style", withExtension: "json") {
                map.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        return map;
    }
    

    func generateFloatingActionButton (handleLocationUpdate : @escaping (FloatyItem)->Void  , handleAlarmTravel : @escaping (FloatyItem)->Void) -> Floaty {
        let fab = Floaty()
        fab.addItem("", icon: #imageLiteral(resourceName: "icons8-alarm-clock-filled-100") , handler : handleAlarmTravel)
        fab.buttonColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        fab.friendlyTap = true
        fab.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1);
        fab.openAnimationType = .slideUp
        return fab
    }
    
    
    func handleLocationUpdate( _ : FloatyItem){
        print("Update location")
    }
    
    func handleTravelAlarm(_ : FloatyItem){
        let detailController = DetailRideController();
        //TODO : Get the location acording to the marker
        detailController.modalPresentationStyle = .custom
        present(detailController, animated: true, completion: nil)
        if let clientLocation = userLocation {
            requestAddress(location: clientLocation)
        }
        
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
    
    
    func loadLocation(){
        //MARK : Initialize the location manager
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
    }
    
    func loadFloatingActionButton(){
        let floatingActionButton = generateFloatingActionButton(handleLocationUpdate: handleLocationUpdate, handleAlarmTravel: handleTravelAlarm)
        self.view.addSubview(floatingActionButton)
    }
    
    func loadMap(){
        if let mapView = mapView {
            self.view.addSubview(mapView);
            mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true;
            mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true;
            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true;
            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true;
            
            mapView.addSubview(imageMarker)
            imageMarker.centerXAnchor.constraint(equalTo: mapView.centerXAnchor).isActive = true;
            imageMarker.centerYAnchor.constraint(equalTo: mapView.centerYAnchor).isActive = true;
            imageMarker.heightAnchor.constraint(equalToConstant: 50).isActive = true;
            mapView.delegate = self
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let coordinate = mapView.projection.coordinate(for: imageMarker.center)
        print("latitude " + "\(coordinate.latitude)" + " longitude " + "\(coordinate.longitude)")
        userLocation = coordinate
    }
    

    func loadSearchBar(){
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self as? GMSAutocompleteResultsViewControllerDelegate
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView();
        let searchBar = searchController?.searchBar;
        searchBar?.translatesAutoresizingMaskIntoConstraints = false;
        subView.backgroundColor = .clear
        subView.addSubview(searchBar!)
        mapView?.addSubview(subView)
        
        subView.translatesAutoresizingMaskIntoConstraints = false
        subView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        subView.heightAnchor.constraint(equalToConstant: 70).isActive = true;
        subView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        subView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false

        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
    }
    
    func loadNavBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    

}

extension MapController : CLLocationManagerDelegate{
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
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
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }

}

