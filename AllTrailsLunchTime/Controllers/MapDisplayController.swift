//
//  MapDisplayController.swift
//  AllTrailsLunchTime
//
//  Created by Mechelle Sieglitz on 12/6/21.
//

import UIKit
import MapKit
import CoreLocation

class MapDisplayController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchControllerDelegate {
    
    
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
    
    var filteredRestaurants: [Restaurant] = []
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    lazy var tableButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        button.imageView?.image = #imageLiteral(resourceName: "list")
        button.setTitle("List", for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        button.addTarget(self, action: #selector(showTableView), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        determineCurrentLocation()
        configureUI()
    }
    
    func configureUI(){
//        self.navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = #colorLiteral(red: 0.9375703931, green: 0.9427609444, blue: 0.9555603862, alpha: 1)
        
        view.addSubview(tableButton)
        tableButton.anchor(bottom: self.view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 40, width: 100, height: 44)
        tableButton.centerX(inView: self.view)
        
        let leftMargin:CGFloat = 10
        let topMargin:CGFloat = 60
        let mapWidth:CGFloat = view.frame.size.width-20
        let mapHeight:CGFloat = view.frame.size.height-20

        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.register(RestaurantCallOutView.self, forAnnotationViewWithReuseIdentifier: "RestaurantCallout")

        view.addSubview(mapView)
        
        view.addSubview(tableButton)
        tableButton.anchor(bottom: self.view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 40, width: 100, height: 44)
        tableButton.centerX(inView: self.view)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a restaurant"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.isUserInteractionEnabled = false
    }
    
    deinit {
        print("deinit \(self)")
    }
    
    //MARK: - Actions
    @objc func showTableView() {
        let controller = TableDisplayController()
        controller.restaurants = self.restaurants
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    //MARK: - Search
    func filterContentForSearchText(_ searchText: String) {
      filteredRestaurants = restaurants.filter { (restaurant: Restaurant) -> Bool in
        return restaurant.name.lowercased().contains(searchText.lowercased())
      }
        self.showRestaurants(data: filteredRestaurants as NSArray)
    }

}

//MARK: CLLocationManagerDelegate
extension MapDisplayController {
    
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        let latDelta: CLLocationDegrees = 0.03
        let lonDelta: CLLocationDegrees = 0.03
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
            
        manager.stopUpdatingLocation()
        
        PlacesService.getNearbyRestaurants(latitude: latitude, longitude: longitude) { restaurantsArray in
            self.restaurants = restaurantsArray
           
        }
            
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
}

//MARK: MapKit
extension MapDisplayController{
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let mapRect: MKMapRect = self.mapView.visibleMapRect
        
        let eastPoint = MKMapPoint(x: mapRect.minX, y: mapRect.midY)
        let westPoint = MKMapPoint(x: mapRect.maxX, y: mapRect.midY)
        
        currentDistance = Int(eastPoint.distance(to: westPoint))
        currentCenter = self.mapView.centerCoordinate
    }
    
    func showRestaurants(data: NSArray) {
        searchController.searchBar.isUserInteractionEnabled = true
        for annotation:MKAnnotation in mapView.annotations {
            
                mapView.removeAnnotation(annotation)
            }
           
            
            let currentRestaurants = self.isFiltering ? filteredRestaurants : restaurants
            
            for restaurant in currentRestaurants {
                var coordinate = CLLocationCoordinate2D()
                coordinate.latitude = restaurant.lat
                coordinate.longitude = restaurant.lng
                
                //TODO: Reimplement as abstracted class
//                let placePoint: MapPoint = MapPoint(name: restaurant.name, address: "", coordinate: coordinate)
            
                let restAnnotation = RestaurantAnnotation(coordinate: coordinate, restaurant: restaurant)
                
                
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(restAnnotation as MKAnnotation)
                }
            
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MapPoint"
        
        if annotation is MKUserLocation {
            return nil
        }
        
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

//        calloutView.translatesAutoresizingMaskIntoConstraints = true
//        calloutView.backgroundColor = .white
//        view.addSubview(calloutView)
//
//        NSLayoutConstraint.activate([
//                calloutView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 0),
//                calloutView.widthAnchor.constraint(equalToConstant: 60),
//                calloutView.heightAnchor.constraint(equalToConstant: 30),
//                calloutView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.calloutOffset.x)
//            ])
        
        if view.annotation is MKUserLocation {
            return
        }
        
        let calloutView = RestaurantCallOutView()
        let annotation = view.annotation as! RestaurantAnnotation
        
        calloutView.restaurantName.text = annotation.restaurant.name
        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
        view.addSubview(calloutView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
        
    }
    
    //MARK: Search
    
}

extension MapDisplayController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
      }
}
