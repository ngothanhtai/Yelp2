//
//  BusinessTableViewCell.swift
//  Yelp
//
//  Created by Ngo Thanh Tai on 11/21/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingImgView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var foodCategoryLabel: UILabel!
    @IBOutlet weak var reviewCounterLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var business:Business! {
        didSet {
            if business.imageURL != nil {
                self.imgView.setImageWithURL(business.imageURL!)
            }
            self.nameLabel.text = business.name!
            self.ratingImgView.setImageWithURL(business.ratingImageURL!)
            self.addressLabel.text = business.address!
            self.foodCategoryLabel.text = business.categories!
            self.reviewCounterLabel.text = "\(business.reviewCount!) reviews"
            self.distanceLabel.text = business.distance!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgView.layer.cornerRadius = 8
        self.imgView.layer.masksToBounds = true
        self.imgView.layer.borderWidth = 1
        self.imgView.layer.borderColor = UIColor.darkGrayColor().CGColor
    }
}
