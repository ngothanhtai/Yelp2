//
//  FiltersTableViewController.swift
//  Yelp
//
//  Created by Ngo Thanh Tai on 11/22/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

protocol FiltersTableViewControllerDelegate {
    func filterTableViewController(filterTableViewController:FiltersTableViewController, filterConfigs:[FilterConfig])
}

class FiltersTableViewController: UITableViewController {
    
    var filterConfigs:[FilterConfig]!
    var delegate:FiltersTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barStyle = .Black;
    }
    
    @IBAction func onCancelBarButton(sender:AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSearchBarButton(sender:AnyObject) {
        delegate?.filterTableViewController(self, filterConfigs: self.filterConfigs)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension FiltersTableViewController:FiltersTableViewCellDelegate {
    func onSwitch(cell: UITableViewCell, state: Bool) {
        if let indexPath = tableView.indexPathForCell(cell) {
            if filterConfigs[indexPath.section].type == .Checkmark {
                var i = 0
                for i = 0; i < filterConfigs[indexPath.section].arrKV.count; i++ {
                    filterConfigs[indexPath.section].arrKV[i].state = false
                }
            }
            filterConfigs[indexPath.section].arrKV[indexPath.row].state = state
        }
    }
}

extension FiltersTableViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let row = filterConfigs[section]
        if !row.opened && row.numVisible > 0 {
            return row.numVisible
        }
        return filterConfigs[section].arrKV.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filterConfigs[section].headerTitle!
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return filterConfigs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let config = filterConfigs[indexPath.section]
        switch config.type {
        case .Switch:
            
            if config.numVisible > 1 && config.numVisible < config.arrKV.count && config.opened == false && indexPath.row >= config.numVisible - 1 {
                let cell = UITableViewCell()
                cell.textLabel?.text = "See All"
                cell.textLabel?.textColor = UIColor.darkGrayColor()
                cell.textLabel?.textAlignment = .Center
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCellWithIdentifier("FiltersSwitchTableViewCell", forIndexPath: indexPath) as! FiltersSwitchTableViewCell
                cell.data = config.arrKV[indexPath.row]
                cell.config = config
                cell.delegate = self
                return cell
            }
        case .None:
            return UITableViewCell()
        case .Checkmark:
            let cell = tableView.dequeueReusableCellWithIdentifier("FiltersRadioTableViewCell", forIndexPath: indexPath) as! FiltersRadioTableViewCell
            if config.opened {
                cell.data = config.arrKV[indexPath.row]
            } else {
                cell.data = config.arrKV.filter({ (cell:FilterConfigForCell) -> Bool in
                    return cell.state!
                }).first
            }
            cell.config = config
            cell.delegate = self
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let config = filterConfigs[indexPath.section]
        if config.type == .Switch {
            if (config.opened == false && indexPath.row < config.numVisible - 1) {
                
                tableView.deselectRowAtIndexPath(indexPath, animated: false)
                return
            }
            filterConfigs[indexPath.section].opened = true
            if config.opened == false
            {
                tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
            }
            
        }
        else {
            filterConfigs[indexPath.section].opened = !filterConfigs[indexPath.section].opened
            tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
        }
        
    }
}