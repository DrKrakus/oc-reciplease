//
//  ViewController.swift
//  oc-reciplease
//
//  Created by Jerome Krakus on 18/04/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import UIKit

class PostLaunchViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var logo: UIImageView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        // Launch icon animation
        animateIcon()
    }

    private func animateIcon() {
        UIView.animate(withDuration: 0.6, animations: {
            self.logo.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (_) in
            UIView.animate(withDuration: 0.4, animations: {
                self.logo.transform = CGAffineTransform(scaleX: 10, y: 10)
                self.logo.alpha = 0
                self.view.backgroundColor = #colorLiteral(red: 0.9415313601, green: 0.9613165259, blue: 0.9738928676, alpha: 1)
            }, completion: { (_) in
                // Go to the next view controller
                let sb = self.storyboard?.instantiateViewController(withIdentifier: "cutomTabBar")
                let vc = sb as! CustomTabBarViewController
                self.present(vc, animated: false)
            })
        }
    }
}

