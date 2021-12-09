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
                self.showRestaurants(data: self.restaurants as NSArray)
            }
            
        }
    }
    var currentCenter = CLLocationCoordinate2D()
    var currentDistance: Int = 0
    
//    var restaurants: Array?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tableview.delegate = self
        tableview.dataSource = self
        mapView.delegate = self
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
            
            manager.stopUpdatingLocation()
            
            print("user latitude = \(userLocation.coordinate.latitude)")
            print("user longitude = \(userLocation.coordinate.longitude)")
        
        PlacesService.getNearbyRestaurants(latitude: latitude, longitude: longitude) { restaurantsArray in
            self.restaurants = restaurantsArray 
        }
        
//        PlacesService.getNearbyRestaurants(latitude: latitude, longitude: longitude)
            
    }
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
            print("DEBUG: Error \(error)")
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
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
    
    
}

//MARK: MapView
extension MapDisplayController{
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let mapRect: MKMapRect = self.mapView.visibleMapRect
        
        let eastPoint = MKMapPoint(x: mapRect.minX, y: mapRect.midY)
        let westPoint = MKMapPoint(x: mapRect.maxX, y: mapRect.midY)
        
        currentDistance = Int(eastPoint.distance(to: westPoint))
        currentCenter = self.mapView.centerCoordinate
    }
    
    func showRestaurants(data: NSArray) {
        for annotation:MKAnnotation in mapView.annotations {
            if (annotation.isKind(of: MapPoint.self)) {
                mapView.removeAnnotation(annotation)
            }
            
            for restaurant in restaurants {
                var coordinate = CLLocationCoordinate2D()
                coordinate.latitude = restaurant.lat
                coordinate.longitude = restaurant.lng
                
                //TODO: Reimplement as abstracted class
//                let placePoint: MapPoint = MapPoint(name: restaurant.name, address: "", coordinate: coordinate)
                
                let annotation = MKPointAnnotation()
                annotation.title = restaurant.name
                annotation.coordinate = CLLocationCoordinate2D(latitude: restaurant.lat, longitude: restaurant.lng)
            
                
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(annotation as MKAnnotation)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MapPoint"
        
        var annotationView: MKAnnotationView
        
        if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            dequedView.annotation = annotation
            return dequedView
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier )
            annotationView.isEnabled = true
            annotationView.canShowCallout = true
            
        }
        annotationView.image = #imageLiteral(resourceName: "pin-inactive")
        return annotationView
    }
}

extension MapDisplayController {
    
}
