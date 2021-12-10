//
//  RestaurantTableViewCell.swift
//  AllTrailsLunchTime
//
//  Created by Mechelle Sieglitz on 12/9/21.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var starRatingsImageView: UIImageView!
    
    @IBOutlet weak var ratingsTotalLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cardView.layer.cornerRadius = 8
        self.cardView.layer.borderWidth = 0.5
        self.cardView.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
