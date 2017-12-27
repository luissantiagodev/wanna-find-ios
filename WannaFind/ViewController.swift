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

class MapController: UIViewController {

    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var mapView : GMSMapView?
    
    let imageMarker : UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "icons8-marker"));
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image;
    }()

    func createMapView ()-> GMSMapView{
        let map = GMSMapView();
        map.translatesAutoresizingMaskIntoConstraints = false
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        map.camera = camera
        do {
            if let styleURL = Bundle.main.url(forResource: "map-style", withExtension: "json") {
                map.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        return map;
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNavBar()
        mapView = createMapView();
        loadMap()
        loadSearchBar()
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
        }
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

