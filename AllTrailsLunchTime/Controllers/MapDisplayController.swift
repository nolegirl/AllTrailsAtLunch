//
//  MapDisplayController.swift
//  AllTrailsLunchTime
//
//  Created by Mechelle Sieglitz on 12/6/21.
//

import UIKit
import MapKit
import CoreLocation

class MapDisplayController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchControllerDelegate, UISearchBarDelegate {
    
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
    var isSearchBarEmpty: Bool {
        return self.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool = false
    let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.searchTextField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let emptyImage = UIImage()
        bar.setImage(emptyImage, for: .search, state: .normal)
        return bar
    }()
    
    let filterButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        button.titleLabel?.textColor = .lightGray
        button.layer.borderWidth = 0.5
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.alpha = 0.5
        
        return button
    }()
    
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
    
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return view
    }()
    
    let restaurantDetailView: UIView = {
        let view = UIView()
        let restaurantCallout = RestaurantCallOutView()
        view.addSubview(restaurantCallout)
        restaurantCallout.frame = view.frame
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        return view
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        determineCurrentLocation()
        configureUI()
    }
    
    func configureUI(){
        self.navigationController?.navigationBar.isHidden = true
        
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

        view.addSubview(mapView)
        
        view.addSubview(tableButton)
        tableButton.anchor(bottom: self.view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20, width: 100, height: 44)
        tableButton.centerX(inView: self.view)
        
        self.view.addSubview(headerView)
        headerView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, width: self.view.frame.size.width, height: 160)
        
        let logo = UIImage(named: "headerImage")
        let logoView = UIImageView(image: logo)
        logoView.contentMode = .scaleAspectFit
        headerView.addSubview(logoView)
        logoView.anchor(top: headerView.topAnchor, paddingTop: 40, width: self.view.frame.size.width, height:80)
        logoView.centerX(inView: self.headerView)
        
        searchBar.delegate = self
        searchBar.placeholder = "Search for a restaurant"
        searchBar.searchTextField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        searchBar.searchTextField.rightView = UIImageView(image: UIImage(named: "searchIcon"))
        searchBar.searchTextField.rightViewMode = UITextField.ViewMode.always
        
        let magnifyer = UIImage(named: "searchIcon")
        let magnifyerImageView = UIImageView(image: magnifyer)
        magnifyerImageView.contentMode = .scaleAspectFit
        
        let stackview = UIStackView(arrangedSubviews: [searchBar, magnifyerImageView])
        stackview.layer.borderColor = UIColor.lightGray.cgColor
        stackview.layer.borderWidth = 0.5
        
        self.headerView.addSubview(filterButton)
        filterButton.setTitle("Filter", for: .normal)
        filterButton.anchor(top: logoView.bottomAnchor, left: self.view.leftAnchor, bottom: headerView.bottomAnchor, paddingTop: -8, paddingLeft: 20, paddingBottom: 8, paddingRight: 20, width: 60, height: 44)
        
        self.headerView.addSubview(stackview)
        stackview.anchor(top: logoView.bottomAnchor,left: filterButton.rightAnchor, bottom: headerView.bottomAnchor, right: self.view.rightAnchor, paddingTop: -8, paddingLeft: 20, paddingBottom: 8, paddingRight: 20, height: 30)
 
    }
    
    override func viewDidLayoutSubviews() {
        
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
        isFiltering = searchBar.text?.isEmpty ?? false ? false : true
        
        filteredRestaurants = self.restaurants.filter { (restaurant: Restaurant) -> Bool in
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
    
    //MARK: Search
    //MARK: Search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchBar.text!)
//        if ((searchBar.text?.isEmpty) != nil) {
//            self.isFiltering = false
//        } else {
//            self.isFiltering = true
//        }
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
            annotationView.canShowCallout = false
        }
        annotationView.image = #imageLiteral(resourceName: "pin-inactive")
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
        view.image = #imageLiteral(resourceName: "pin-active")
        
        if view.annotation is MKUserLocation {
            return
        }

        let calloutView = RestaurantCallOutView()

        let annotation = view.annotation as! RestaurantAnnotation
        let restaurant = annotation.restaurant
    
        restaurantDetailView.center = CGPoint(x: mapView.center.x, y: mapView.center.y - 150)
        calloutView.restaurantName.text = restaurant.name
        calloutView.priceLabel.text = calculatePriceLabel(price: restaurant.price_level)
        calloutView.starImageView.image = calculateStarLevel(stars: restaurant.rating)
//        calloutView.restaurantImageView.image = #imageLiteral(resourceName: "martis-trail")
        calloutView.reviewNumberLabel.text = "(\(restaurant.user_ratings_total)"
        restaurantDetailView.addSubview(calloutView)
        calloutView.anchor(top: restaurantDetailView.topAnchor, left: restaurantDetailView.leftAnchor, bottom: restaurantDetailView.bottomAnchor, right: restaurantDetailView.rightAnchor)
        mapView.addSubview(restaurantDetailView)
        
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = #imageLiteral(resourceName: "pin-inactive")
        for view in self.restaurantDetailView.subviews {
            view.removeFromSuperview()
        }
        restaurantDetailView.removeFromSuperview()
    }
    
    //MARK: Helpers
    func calculatePriceLabel(price: Int) -> String {
        switch price {
            case 1:
                return "$ •"
            case 2:
                return "$$ •"
            case 3:
                return "$$$ •"
            case 4:
                return "$$$$ •"
            default:
                return "$ •"
            }
                return ""
        }
    
    func calculateStarLevel(stars: Int) -> UIImage {
        let image = UIImage()
        var rating = 0
        if stars == 0 {
            rating = 1
        } else {
            rating = stars
        }
//        switch restaurant.rating {
//                case 0:
//                    image = #imageLiteral(resourceName: "1-star")
//                    break
//                case 1:
//                    image = #imageLiteral(resourceName: "1-star")
//                    break
//                case 2:
//                    image = #imageLiteral(resourceName: "2-star")
//                    break
//                case 3:
//                    image = #imageLiteral(resourceName: "3-star")
//                    break
//                case 4:
//                    image = #imageLiteral(resourceName: "4-star")
//                    break
//                case 5:
//                    image = #imageLiteral(resourceName: "5-star")
//                    break
//                default:
//                    image = #imageLiteral(resourceName: "1-star")
//                }
        return UIImage(named: "\(rating)-star") ?? UIImage()
    }
    
//    func configureCustomCalloutView(restaurant: Restaurant) -> RestaurantCallOutView {
//        let restaurant: Restaurant
//
//        cell.restaurantNameLabel.text = restaurant.name
//        cell.ratingsTotalLabel.text = "(\(restaurant.user_ratings_total))"
//
//        var rating = 0
//        if restaurant.rating == 0 {
//            rating = 1
//        } else {
//            rating = restaurant.rating
//        }
//        switch restaurant.rating {
//        case 0:
//            cell.starRatingsImageView.image = #imageLiteral(resourceName: "1-star")
//            break
//        case 1:
//            cell.starRatingsImageView.image = #imageLiteral(resourceName: "1-star")
//            break
//        case 2:
//            cell.starRatingsImageView.image = #imageLiteral(resourceName: "2-star")
//            break
//        case 3:
//            cell.starRatingsImageView.image = #imageLiteral(resourceName: "3-star")
//            break
//        case 4:
//            cell.starRatingsImageView.image = #imageLiteral(resourceName: "4-star")
//            break
//        case 5:
//            cell.starRatingsImageView.image = #imageLiteral(resourceName: "5-star")
//            break
//        default:
//            cell.starRatingsImageView.image = #imageLiteral(resourceName: "1-star")
//        }
//
//
//        cell.starRatingsImageView.image = UIImage(named: "\(rating)-star")
//        switch restaurant.price_level {
//        case 1:
//            cell.priceLabel.text = "$ •"
//        case 2:
//            cell.priceLabel.text = "$$ •"
//        case 3:
//            cell.priceLabel.text = "$$$ •"
//        case 4:
//            cell.priceLabel.text = "$$$$ •"
//        default:
//            cell.priceLabel.text = "$ •"
//        }
//            return cell
//        }
//    }
}

extension MapDisplayController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
      }
}
