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
        view.backgroundColor = #colorLiteral(red: 0.9375703931, green: 0.9427609444, blue: 0.9555603862, alpha: 1)
        
        let leftMargin:CGFloat = 10
        let topMargin:CGFloat = 60
        let mapWidth:CGFloat = view.frame.size.width-20
        let mapHeight:CGFloat = view.frame.size.height-20

        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.register(RestaurantCallOutView.self, forAnnotationViewWithReuseIdentifier: "RestaurantCallout")

//        view.addSubview(mapView)
        determineCurrentLocation()
        
        view.addSubview(tableview)
        tableview.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 20, paddingBottom: 20, paddingRight: 20)
        
        let textFieldCell = UINib(nibName: "RestaurantTableViewCell",
                                      bundle: nil)
            self.tableview.register(textFieldCell,
                                    forCellReuseIdentifier: "RestaurantTableViewCell")
        tableview.backgroundColor = #colorLiteral(red: 0.9375703931, green: 0.9427609444, blue: 0.9555603862, alpha: 1)
        tableview.separatorColor = .clear
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
        let latDelta: CLLocationDegrees = 0.03
        let lonDelta: CLLocationDegrees = 0.03
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantTableViewCell") as? RestaurantTableViewCell {
            let restaurant = restaurants[indexPath.row] as Restaurant
            cell.restaurantNameLabel.text = restaurant.name
            cell.ratingsTotalLabel.text = "(\(restaurant.user_ratings_total))"
            
            var rating = 0
            if restaurant.rating == 0 {
                rating = 1
            } else {
                rating = restaurant.rating
            }
            switch restaurant.rating {
            case 0:
                cell.starRatingsImageView.image = #imageLiteral(resourceName: "1-star")
                break
            case 1:
                cell.starRatingsImageView.image = #imageLiteral(resourceName: "1-star")
                break
            case 2:
                cell.starRatingsImageView.image = #imageLiteral(resourceName: "2-star")
                break
            case 3:
                cell.starRatingsImageView.image = #imageLiteral(resourceName: "3-star")
                break
            case 4:
                cell.starRatingsImageView.image = #imageLiteral(resourceName: "4-star")
                break
            case 5:
                cell.starRatingsImageView.image = #imageLiteral(resourceName: "5-star")
                break
            default:
                cell.starRatingsImageView.image = #imageLiteral(resourceName: "1-star")
            }
            
            
            cell.starRatingsImageView.image = UIImage(named: "\(rating)-star")
            switch restaurant.price_level {
            case 1:
                cell.priceLabel.text = "$ •"
            case 2:
                cell.priceLabel.text = "$$ •"
            case 3:
                cell.priceLabel.text = "$$$ •"
            case 4:
                cell.priceLabel.text = "$$$$ •"
            default:
                cell.priceLabel.text = "$ •"
            }
                return cell
            }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
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
            
                let restAnnotation = RestaurantAnnotation(coordinate: coordinate, restaurant: restaurant)
                
                
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(restAnnotation as MKAnnotation)
                }
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
}

extension MapDisplayController {
    
}
