//
//  TableDisplayController.swift
//  AllTrailsLunchTime
//
//  Created by Mechelle Sieglitz on 12/8/21.
//

import UIKit

class TableDisplayController: UITableViewController {
   //MARK: Properties
    let restaurants: [Restaurant] = []
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        let restaurantCell = UINib(nibName: "RestaurantTableViewCell",
                                      bundle: nil)
            self.tableView.register(restaurantCell,
                                    forCellReuseIdentifier: "RestaurantTableViewCell")
        self.view.backgroundColor = #colorLiteral(red: 0.9375703931, green: 0.9427609444, blue: 0.9555603862, alpha: 1)
        tableView.separatorColor = .clear
    }
    
    static let restaurantCellIdentifier = "restaurantCell"
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    //MARK: Actions
}
