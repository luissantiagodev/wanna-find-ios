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
import PromiseKit

class MapController: UIViewController , GMSMapViewDelegate , Delegate , CancelDelegate{
    
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    
    var searchController: UISearchController?
    
    var mapView : GMSMapView?
    
    var locationManager = CLLocationManager()
    
    var placesClient : GMSPlacesClient!

    var cameraZoom : Float = 17.0
    
    let userModalView = UserViewModel(User(origin: CLLocationCoordinate2D(), destination: CLLocationCoordinate2D()))
    
    var updateViewForOnce = true
    
    var polyLine : GMSPolyline?
    
    var destinationMarker : GMSMarker?
    
    var isRiding = false
    
    let imageMarker : UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "newMarker"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image;
    }()
    
    func handleTravelAlarm(_ : FloatyItem){
        let detailController = DetailRideController()
        detailController.currentUser = userModalView.getCompleteInformation
        detailController.modalPresentationStyle = .custom
        detailController.delegateHandleControl = self
        present(detailController, animated: true, completion: nil)
    }
    
    
    func handleTrip(){
        let ridingController = RidingController()
        ridingController.modalPresentationStyle = .custom
        ridingController.cancelDelegate = self
        present(ridingController, animated: true, completion: nil)
        requestDirections()
    }
    
    func requestDirections(){
        firstly{
            requestDirections(userFullLocation: userModalView.getCompleteInformation)
            }.then{ polyline in
            self.drawOnMap(polylineString: polyline)
            }.always {
                print("Directions done")
        }
    }
    
    func drawOnMap(polylineString : String){
        let paddinBottom = UIScreen.main.bounds.height / 4
        let path = GMSPath.init(fromEncodedPath: polylineString)
        polyLine = GMSPolyline(path: path )
        polyLine?.strokeWidth = 4
        polyLine?.strokeColor = #colorLiteral(red: 0.003906628583, green: 0.4769868255, blue: 0.992308557, alpha: 1)
        polyLine?.map = mapView
        let bounds = GMSCoordinateBounds(path: path!)
        let update = GMSCameraUpdate.fit(bounds , with:UIEdgeInsetsMake(paddinBottom + 20, 50, paddinBottom + 20  , 50))
        //We add the marker
        let customImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        customImage.image =  #imageLiteral(resourceName: "icons8-marker-100(1)").withRenderingMode(.alwaysTemplate)
        customImage.tintColor = .blue
        destinationMarker = GMSMarker(position: userModalView.destinationLocation)
        destinationMarker?.iconView = customImage
        mapView?.animate(with: update)
        destinationMarker?.map = mapView
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
    
    func loadFloatingActionButton(){
        let floatingActionButton = generateFloatingActionButton(handleLocationUpdate: updateCameraLocation, handleAlarmTravel: handleTravelAlarm)
        self.view.addSubview(floatingActionButton)
    }
    
    func onRideCancel() {
        imageMarker.isHidden = false
        updateLocation()
        removePolyLine()
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let coordinate = mapView.projection.coordinate(for: imageMarker.center)
        userModalView.destinationLocation = coordinate
    }
    
    func removePolyLine(){
        polyLine?.map = nil
        destinationMarker?.map = nil
    }
    
    func updateCameraLocation(_ : FloatyItem){
        updateLocation()
    }
    
    func updateLocation(){
        let location = userModalView.originUserLocation
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude,
                                              longitude: location.longitude,
                                              zoom: cameraZoom)
        if (mapView?.isHidden)! {
            mapView?.isHidden = false
            mapView?.camera = camera
        } else {
            mapView?.animate(to: camera)
        }
    }
    
    func onRideAccepted() {
        imageMarker.isHidden = true
        handleTrip()
        isRiding = true
    }
}

extension MapController : CLLocationManagerDelegate{
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        userModalView.originUserLocation = location.coordinate
        if updateViewForOnce {
            updateLocation()
            updateViewForOnce = false
        }
        //MARK: Check if the user is in the trip, otherwise don't say nothing
        if isRiding {
            print("The user is in the trip")
            if (GMSGeometryDistance(userModalView.originUserLocation, userModalView.destinationLocation)<50){
                print("You have arrived to your destination")
            }
        }else{
            print("The user is NOT in the trip")
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


extension MapController{
    public func animateMapToZoomOut(){
        mapView?.animate(toZoom: 16.4)
    }
    
    public func requestDirections(userFullLocation : User)-> Promise<String> {
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(userFullLocation.originLocation.latitude),\(userFullLocation.originLocation.longitude)&destination=\(userFullLocation.destinationLocation.latitude),\(userFullLocation.destinationLocation.longitude)&sensor=true&key=\(keyMap)"
        print(urlString)
        let url = URL(string: urlString)
        print(url ?? "No link found")
        return Promise<String> { dirrections , error  in
            if let url = url {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        print(error)
                    }
                    guard let data = data else { return }
                    let result = try? JSONDecoder().decode(Route.self, from: data)
                    if let finalResult = result  {
                        let polyLine = finalResult.routes[0].overview_polyline.points
                        return dirrections(polyLine)
                    }
                }
                task.resume()
            }else{
                print("There isn't a url formaly parsed")
            }
        }
    }
}

