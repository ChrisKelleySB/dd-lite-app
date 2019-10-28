//
//  FeaturesTabBarController.swift
//  dd-ios-takehome
//
//  Created by Christopher Kelley on 10/27/19.
//  Copyright © 2019 Christopher Kelley. All rights reserved.
//

import UIKit

class FeaturesTabBarController: UITabBarController {
    var searchResults: ExploreResultArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let exploreVC = self.viewControllers?.first(where: { $0 as? ExploreTableViewController != nil }) as? ExploreTableViewController {
            if let searchResults = searchResults {
                exploreVC.exploreResults = searchResults
            }
        }
    }
    
    @IBAction func showMapAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
