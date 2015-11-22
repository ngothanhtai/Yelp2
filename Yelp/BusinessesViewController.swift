//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var tableView:UITableView!
    
    var searchBar:UISearchBar!
    var businesses: [Business]! = []
    var filterConfigs = FilterConfig.createaFilterConfigs()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initControls()
        
        search()
    }
    
    func search() {
        Business.searchWithTerm(searchBar.text!, sort: self.sortBy(), categories: self.categories(), deals: self.offerDeal(), meters: self.distanceByMeters()) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            self.tableView.reloadData()
        }
    }
    
    func initControls() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        searchBar = UISearchBar()
        searchBar.placeholder = "Restaurants"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let nagivationController = segue.destinationViewController as? UINavigationController {
            if let filterController = nagivationController.topViewController as? FiltersTableViewController {
                filterController.delegate = self
                filterController.filterConfigs = self.filterConfigs
            }
        } else if let detailVC = segue.destinationViewController as? DetailViewController {
            let indexPath = self.tableView.indexPathForCell(sender as! BusinessTableViewCell)!
            detailVC.business = self.businesses[indexPath.row]
        }
    }
}

extension BusinessesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businesses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell") as! BusinessTableViewCell
        cell.business = self.businesses[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension BusinessesViewController : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBarSearchButtonClicked(searchBar)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.search()
        self.searchBar.setShowsCancelButton(false, animated: true)
        self.searchBar.endEditing(true)
    }
}

extension BusinessesViewController:FiltersTableViewControllerDelegate {
    func onSearch(filterConfigs: [FilterConfig]) {
        self.filterConfigs = filterConfigs
        self.search()
    }
}

extension BusinessesViewController {
    func offerDeal() -> Bool {
        
        var dealConfig = self.filterConfigs[0]
        return dealConfig.arrKV[0].state

    }
    
    func distanceByMeters() -> Float? {
        let distanceConfig = self.filterConfigs[1]
        for item in distanceConfig.arrKV {
            if item.state! {
                if item.value == nil {
                    return nil
                }
                return (item.value as! Float) * 1609.344
            }
        }
        return nil
    }
    
    func sortBy() -> YelpSortMode {
        let sortByConfig = self.filterConfigs[2]
        for item in sortByConfig.arrKV {
            if item.state! {
                if item.value == nil {
                    return YelpSortMode.HighestRated
                }
                return YelpSortMode(rawValue: item.value as! Int)!
            }
        }
        
        return YelpSortMode.HighestRated
    }
    
    func categories() -> [String] {
        let categoryConfig = self.filterConfigs[3]
        
        var arrName = [String]()
        for item in categoryConfig.arrKV {
            if item.state! {
                arrName.append(item.value as! String)
            }
        }
        
        return arrName
    }
}
