//
//  PlacesService.swift
//  AllTrailsLunchTime
//
//  Created by Mechelle Sieglitz on 12/6/21.
//

import Foundation
import UIKit
private let kGOOGLE_API_KEY = "AIzaSyDue_S6t9ybh_NqaeOJDkr1KC9a2ycUYuE"

struct PlacesService {
    static func getNearbyRestaurants(latitude:Double, longitude: Double, completion: @escaping([Restaurant]) -> Void ) {
        let url:String = "https://maps.googleapis.com/maps/api/place/search/json?location=\(latitude),\(longitude)&radius=1500&type=restaurant&key=\(kGOOGLE_API_KEY)"
        guard let serviceURL = URL(string: url) else {return}
        var request = URLRequest(url: serviceURL)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 20
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                let restaurantsArray = NSMutableArray()
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.fragmentsAllowed) as! [String : Any]
                    
                    let restaurants = json["results"] as! NSArray
                    
                    for restaurantDictionary in restaurants {
                        let dictionary = restaurantDictionary as! [String: Any]
                        
                        let restaurant = Restaurant(dictionary: dictionary)
                        restaurantsArray.add(restaurant)
                        print(restaurant)
                    }
//                    json.forEach { restaurantDict in
//                        let array = restaurantDict
//
//
//                        print(json["results"][0] ?? "results not here")
//                    }
//                    for (item in json) {
//                        let restaurant = Restaurant(dictionary: item as! [String : Any])
//                    }
                    
                    
                    let array = restaurantsArray.copy() as! [Restaurant]
                    completion(array)
                    print(json)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func getRestaurantImage(photoReference: String) {
//        https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=photo_reference&key=YOUR_API_KEY
        
        let url:String = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=\(photoReference)&key=\(kGOOGLE_API_KEY)"
        guard let serviceURL = URL(string: url) else {return}
        var request = URLRequest(url: serviceURL)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 20
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.fragmentsAllowed) as! [String : Any]
                    
                    let image = UIImage()
                    
                
//                    completion(image)
                    print(json)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
