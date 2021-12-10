//
//  RestaurantAnnotation.swift
//  AllTrailsLunchTime
//
//  Created by Mechelle Sieglitz on 12/9/21.
//

import MapKit

class RestaurantAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let restaurant: Restaurant
    let title: String!
    
    init(coordinate: CLLocationCoordinate2D, restaurant: Restaurant) {
        self.coordinate = coordinate
        self.restaurant = restaurant
        title = restaurant.name
    }
}
