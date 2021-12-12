//
//  Restaurant.swift
//  AllTrailsLunchTime
//
//  Created by Mechelle Sieglitz on 12/7/21.
//

import Foundation

struct Restaurant {
    //MARK: - Properties
//    let name: String?
    let photo_reference: String
//    let photo: UIImage
    let price_level: Int
    let rating: Int
    let user_ratings_total: Int
//    let open_now: Bool?
    let name: String
//    let types:Array<String>
    let lat: Double
    let lng: Double
    let openNow: Bool?
    
    //TODO: Create hours using PlaceOpeningHoursPeriod
    
    init(dictionary:[String: Any]) {
        let geometry:[String:Any] = dictionary["geometry"] as! [String : Any]
        let location:[String:Any] = geometry["location"] as! [String : Any]
        let lat = location["lat"] as! Double
        let lng = location["lng"] as! Double
        

        self.name = dictionary["name"] as? String ?? ""
        self.lat = lat
        self.lng = lng
        
        self.price_level = dictionary["price_level"] as? Int ?? 10
        self.rating = dictionary["rating"] as? Int ?? 0
        
        
        let photosArray = dictionary["photos"] as? NSArray
        let photosDictionary = photosArray?[0] as? NSDictionary
        self.photo_reference = photosDictionary?["photo_reference"] as? String ?? "COULD NOT GET PHOTO"
        
        let placeHours = dictionary["opening_hours"] as? NSDictionary
        self.openNow = placeHours?["open_now"] as? Bool ?? false
        
        
        self.user_ratings_total = dictionary["user_ratings_total"] as? Int ?? 0
    }
}

/* example result
 {
"business_status" = OPERATIONAL;
geometry =             {
 location =                 {
     lat = "37.3313217";
     lng = "-122.0317877";
 };
 viewport =                 {
     northeast =                     {
         lat = "37.3326108302915";
         lng = "-122.0306303697085";
     };
     southwest =                     {
         lat = "37.3299128697085";
         lng = "-122.0333283302915";
     };
 };
};
icon = "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/restaurant-71.png";
"icon_background_color" = "#FF9E67";
"icon_mask_base_uri" = "https://maps.gstatic.com/mapfiles/place_api/icons/v2/restaurant_pinlet";
name = "BJ's Restaurant & Brewhouse";
"opening_hours" =             {
 "open_now" = 1;
};
photos =             (
                 {
     height = 3024;
     "html_attributions" =                     (
         "<a href=\"https://maps.google.com/maps/contrib/104506279021249480336\">BJ&#39;s Restaurant &amp; Brewhouse</a>"
     );
     "photo_reference" = "Aap_uEB4yQD7GJa8RoBG3RQTgNlO7pYhRr9zDayt19gl_fmrgptrEL8GcI1u-cN0ShxUPwm46LYqyrceBKbMQmGDi8ZBw65M8quWiuENdEWGCcH0ecSGun63_knZ_hJ6uZ4ue1yYhbs9qW5u-_BV_pCctoucF5e-oXW29-itvsshn8i0GMTU";
     width = 4032;
 }
);
"place_id" = ChIJM75zpLa1j4ARd8IiWxkW30g;
"plus_code" =             {
 "compound_code" = "8XJ9+G7 Cupertino, CA, USA";
 "global_code" = "849V8XJ9+G7";
};
"price_level" = 2;
rating = 4;
reference = ChIJM75zpLa1j4ARd8IiWxkW30g;
scope = GOOGLE;
types =             (
 restaurant,
 bar,
 food,
 "point_of_interest",
 establishment
);
"user_ratings_total" = 1987;
vicinity = "10690 North De Anza Boulevard, Cupertino";
},*/
