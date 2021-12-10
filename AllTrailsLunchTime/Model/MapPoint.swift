//
//  MapPoint.swift
//  AllTrailsLunchTime
//
//  Created by Mechelle Sieglitz on 12/8/21.
//

import Foundation
import MapKit

class MapPoint:NSObject {
    
    //MARK: - Properties
    let restaurant: Restaurant

    let coordinate: CLLocationCoordinate2D
    
    
    //MARK: - Lifecycle
    init(restaurant:Restaurant, coordinate: CLLocationCoordinate2D) {
        self.restaurant = restaurant
        self.coordinate = coordinate
    
    }
    
    
}
