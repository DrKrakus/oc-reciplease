//
//  CustomNavigationViewController.swift
//  oc-reciplease
//
//  Created by Jerome Krakus on 19/04/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import UIKit

class CustomNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Remove the border of navigationBar
        removeBorder()
    }

    private func removeBorder() {
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
    }


}
