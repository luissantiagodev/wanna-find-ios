//
//  Constraints.swift
//  WannaFind
//
//  Created by Luis Santiago  on 1/5/18.
//  Copyright © 2018 Luis Santiago . All rights reserved.
//

import Foundation
import GoogleMaps
import CoreLocation
import GooglePlaces
import Floaty

extension MapController{
    
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
    
    func loadLocation(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
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
        
        setUpContraints(subView)
        
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
    
    func setUpContraints(_ subView : UIView){
        subView.translatesAutoresizingMaskIntoConstraints = false
        subView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        subView.heightAnchor.constraint(equalToConstant: 70).isActive = true;
        subView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        subView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
    }
    
    func generateFloatingActionButton (handleLocationUpdate : @escaping (FloatyItem)->Void  , handleAlarmTravel : @escaping (FloatyItem)->Void) -> Floaty {
        let fab = Floaty()
        fab.addItem("", icon: #imageLiteral(resourceName: "icons8-alarm-clock-filled-100") , handler : handleAlarmTravel)
        fab.addItem("", icon: #imageLiteral(resourceName: "icons8-marker-100(1)") , handler : handleLocationUpdate)
        fab.buttonColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        fab.friendlyTap = true
        fab.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1);
        fab.openAnimationType = .slideUp
        return fab
    }
    
    
    func loadNavBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func createMapView ()-> GMSMapView{
        let map = GMSMapView();
        map.translatesAutoresizingMaskIntoConstraints = false        
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
}
