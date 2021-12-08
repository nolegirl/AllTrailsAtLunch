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
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    var subtitle: String = ""
    var title: String = ""
    
    //MARK: - Lifecycle
    init(name: String, address: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.address = address
        self.coordinate = coordinate
        
        self.title = name
        self.subtitle = address
    }
    
    
}
