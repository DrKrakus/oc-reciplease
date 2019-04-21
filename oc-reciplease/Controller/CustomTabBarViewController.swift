//
//  CustomTabBarViewController.swift
//  oc-reciplease
//
//  Created by Jerome Krakus on 21/04/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Remove the border of navigationBar
        removeBorder()
    }
    
    private func removeBorder() {
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
    }
}
