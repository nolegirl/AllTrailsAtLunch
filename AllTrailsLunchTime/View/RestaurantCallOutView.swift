//
//  RestaurantCallOutView.swift
//  AllTrailsLunchTime
//
//  Created by Mechelle Sieglitz on 12/8/21.
//

import UIKit

class RestaurantCallOutView: UIView {
    //MARK: Properties
    let restaurantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        //TODO: Set up restaurant image
        return imageView
    }()
    
    let restaurantName: UILabel = {
        let nameLabel = UILabel()
        //TODO: Set up restaurant name
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        return nameLabel
    }()
    
   let starImageView: UIImageView = {
        let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let reviewNumberLabel: UILabel = {
        let nameLabel = UILabel()
        //TODO: Set up restaurant name
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        return nameLabel
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    //MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(restaurantImageView)
        restaurantImageView.anchor(top: topAnchor, left: restaurantImageView.rightAnchor, bottom: bottomAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: frame.width/3, height: frame.size.height-16)
        
        addSubview(restaurantName)
        restaurantName.anchor(top: topAnchor, left: restaurantImageView.rightAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8)
        
        addSubview(starImageView)
        starImageView.anchor(top: restaurantName.bottomAnchor, left: restaurantImageView.rightAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingRight: 8, height: 20)
        
        let stack = UIStackView(arrangedSubviews: [priceLabel, subtitleLabel])
        addSubview(stack)
        stack.anchor(top: starImageView.bottomAnchor, left: restaurantImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Actions
    func configure(restaurant: Restaurant) {
        restaurantName.text = restaurant.name
        
    }
}
