//
//  DetailViewController.swift
//  Yelp
//
//  Created by Ngo Thanh Tai on 11/22/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var ratingImgView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var foodCategoryLabel: UILabel!
    @IBOutlet weak var reviewCounterLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var bgViewDetail: UIView!
    @IBOutlet weak var mapView: MKMapView!

    var business:Business! {
        didSet {
            self.title = business.name!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
   
    func updateUI() {
        self.title = business.name
        self.imgView.setImageWithURL(business.imageURL!)
        self.imgView.layer.cornerRadius = 8
        self.imgView.layer.masksToBounds = true
        self.imgView.layer.borderWidth = 1
        self.imgView.layer.borderColor = UIColor.darkGrayColor().CGColor
        
        self.nameLabel.text = business.name!
        self.ratingImgView.setImageWithURL(business.ratingImageURL!)
        self.addressLabel.text = business.address!
        self.foodCategoryLabel.text = business.categories!
        self.reviewCounterLabel.text = "\(business.reviewCount!) reviews"
        self.distanceLabel.text = business.distance!

        // 1
        let location = CLLocationCoordinate2D(
            latitude: self.business.latitude!,
            longitude: self.business.longitude!
        )
        // 2
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        //3
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = business.name!
        annotation.subtitle = business.address!
        mapView.addAnnotation(annotation)
    }
}
