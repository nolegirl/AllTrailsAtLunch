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
        self.cardView.layer.borderWidth = 0.25
        self.cardView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.cardView.layer.shadowColor = UIColor.lightGray.cgColor
        self.cardView.layer.shadowOpacity = 0.1
        self.cardView.layer.shadowOffset = CGSize(width: 0.5, height: 1)
        self.cardView.layer.shadowRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
