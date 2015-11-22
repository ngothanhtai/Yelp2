//
//  FiltersTableViewCell.swift
//  Yelp
//
//  Created by Ngo Thanh Tai on 11/22/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class FiltersSwitchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var switchState: UISwitch!
    
    var delegate:FiltersTableViewCellDelegate?
    var config:FilterConfig?
    
    var data:FilterConfigForCell! {
        didSet {
            self.nameLabel.text = data.name
            self.switchState.on = data.state
        }
    }

    @IBAction func onValueChanged(sender: UISwitch) {
        delegate?.onSwitch(self, state: sender.on)
    }
}

protocol FiltersTableViewCellDelegate {
    func onSwitch(cell:UITableViewCell, state:Bool)
}