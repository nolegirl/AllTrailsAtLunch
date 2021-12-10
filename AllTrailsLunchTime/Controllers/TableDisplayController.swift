//
//  TableDisplayController.swift
//  AllTrailsLunchTime
//
//  Created by Mechelle Sieglitz on 12/8/21.
//

import UIKit

class TableDisplayController: UITableViewController, UISearchControllerDelegate {
    
    
   //MARK: Properties
    lazy var restaurants: [Restaurant] = []
    
    lazy var mapButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        button.imageView?.image = #imageLiteral(resourceName: "list")
        button.setTitle("List", for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        button.addTarget(self, action: #selector(showMapView), for: .touchUpInside)
        return button
    }()
    
    var filteredRestaurants: [Restaurant] = []
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        let restaurantCell = UINib(nibName: "RestaurantTableViewCell",
                                      bundle: nil)
            self.tableView.register(restaurantCell,
                                    forCellReuseIdentifier: "RestaurantTableViewCell")
        configureUI()
    }
    
    deinit {
        print("deinit \(self)")
    }
    
    func configureUI() {
        self.view.backgroundColor = #colorLiteral(red: 0.9375703931, green: 0.9427609444, blue: 0.9555603862, alpha: 1)
        tableView.separatorColor = .clear
        
        view.addSubview(mapButton)
        mapButton.anchor(bottom: self.view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 40, width: 100, height: 44)
        mapButton.centerX(inView: self.view)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a restaurant"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationController?.navigationBar.addSubview(searchController.searchBar)
    }
    
    //MARK: Actions
    
    @objc func showMapView() {
        self.navigationController?.popViewController(animated: false)
    }
}

//MARK: TableViewDataSource
extension TableDisplayController {
    static let restaurantCellIdentifier = "restaurantCell"
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.isFiltering) {
            return self.filteredRestaurants.count
        } else {
            return restaurants.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantTableViewCell") as? RestaurantTableViewCell {
            
            let restaurant: Restaurant
            if (isFiltering) {
                restaurant = filteredRestaurants[indexPath.row] as Restaurant
            } else {
                restaurant = restaurants[indexPath.row] as Restaurant
            }
            
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    //MARK: - Search
    func filterContentForSearchText(_ searchText: String) {
      filteredRestaurants = restaurants.filter { (restaurant: Restaurant) -> Bool in
        return restaurant.name.lowercased().contains(searchText.lowercased())
      }
        
        self.tableView.reloadData()
    }
}

extension TableDisplayController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
      }
}

