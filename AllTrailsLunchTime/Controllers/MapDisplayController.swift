//
//  MapDisplayController.swift
//  AllTrailsLunchTime
//
//  Created by Mechelle Sieglitz on 12/6/21.
//

import UIKit
import MapKit
import CoreLocation

class MapDisplayController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
    
    
    //MARK: - Properties
    var locationManager:CLLocationManager!
    let mapView = MKMapView()
    let tableview: UITableView = {
        let tableview = UITableView()
        return tableview
    }()
    var restaurants = [Restaurant] () {
        didSet{
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
            
        }
    }
    
//    var restaurants: Array?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let leftMargin:CGFloat = 10
        let topMargin:CGFloat = 60
        let mapWidth:CGFloat = view.frame.size.width-20
        let mapHeight:CGFloat = 300

        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true

        view.addSubview(mapView)
        determineCurrentLocation()
        
        view.addSubview(tableview)
        tableview.anchor(top: mapView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 20, paddingBottom: 20, paddingRight: 20)
    }
    
    //MARK: - Actions
    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            DispatchQueue.main.async {
                self.locationManager.startUpdatingLocation()
                self.mapView.showsUserLocation = true
            }
        }
    }
    

    //MARK: - Map
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        let latDelta: CLLocationDegrees = 0.05
        let lonDelta: CLLocationDegrees = 0.05
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
            
            // Call stopUpdatingLocation() to stop listening for location updates,
            // other wise this function will be called every time when user location changes.
            
           // manager.stopUpdatingLocation()
            
            print("user latitude = \(userLocation.coordinate.latitude)")
            print("user longitude = \(userLocation.coordinate.longitude)")
        
        PlacesService.getNearbyRestaurants(latitude: latitude, longitude: longitude) { restaurantsArray in
            self.restaurants = restaurantsArray as! [Restaurant]
        }
        
//        PlacesService.getNearbyRestaurants(latitude: latitude, longitude: longitude)
            
    }
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
            print("DEBUG: Error \(error)")
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
                locationManager.requestLocation()
            }
        }
    
    static let restaurantCellIdentifier = "restaurantCell"
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(restaurants.count)
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")

        if cell == nil {
            cell = UITableViewCell(style:.default, reuseIdentifier: "cell")
        }

        cell?.textLabel?.text = restaurants[indexPath.row].name
        return cell ?? UITableViewCell.init()
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
        
        
    }
}

extension MapDisplayController{
    
    
    
}

extension MapDisplayController {
    
}
