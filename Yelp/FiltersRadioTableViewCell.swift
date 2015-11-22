//
//  FiltersTableViewCell.swift
//  Yelp
//
//  Created by Ngo Thanh Tai on 11/22/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class FiltersRadioTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var delegate:FiltersTableViewCellDelegate?
    var config:FilterConfig?
    
    var data:FilterConfigForCell! {
        didSet {
            self.nameLabel.text = data.name!
            self.accessoryType = data.state! ? .Checkmark : .None
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if config?.opened == false {
            return
        }
        delegate?.onSwitch(self, state: selected)
    }
}