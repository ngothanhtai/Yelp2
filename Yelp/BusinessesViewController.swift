//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import JTProgressHUD

class BusinessesViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var tableView:UITableView!
    
    var searchBar:UISearchBar!
    var businesses: [Business]! = []
    var filterConfigs = FilterConfig.createaFilterConfigs()
    var loadingView:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initControls()
        
        search()
    }
    
    func search(offset:Int = 0) {
        
        if offset == 0 {
            JTProgressHUD.show()
        }
        
        Business.searchWithTerm(searchBar.text!, offset: offset, sort: self.sortBy(), categories: self.categories(), deals: self.offerDeal(), meters: self.distanceByMeters()) { (businesses: [Business]!, error: NSError!) -> Void in
            self.loadingView.hidden = true
            self.loadingView.stopAnimating()
            if offset > 0 {
                self.businesses.appendContentsOf(businesses)
            } else {
                self.businesses = businesses
            }
            
            JTProgressHUD.hide()
            
            self.tableView.reloadData()
        }
    }
    
    func initControls() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.barStyle = .Black;
        
        searchBar = UISearchBar()
        searchBar.placeholder = "Restaurants"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        
        // add trigger at the end icon
        let tableViewFooter = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        loadingView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        loadingView.hidden = true
        loadingView.stopAnimating()
        loadingView.center = tableViewFooter.center
        
        tableViewFooter.addSubview(loadingView)
        self.tableView.tableFooterView = tableViewFooter
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["view": tableViewFooter, "newView": loadingView]
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[view]-(<=0)-[newView(320)]", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: views)
        view.addConstraints(horizontalConstraints)
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[view]-(<=0)-[newView(50)]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: views)
        view.addConstraints(verticalConstraints)
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
        
        if indexPath.row == businesses.count - 1 && loadingView.hidden {
            loadingView.hidden = false
            loadingView.startAnimating()
            search(self.businesses.count)
        }
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
