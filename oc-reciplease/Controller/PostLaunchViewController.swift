//
//  ViewController.swift
//  oc-reciplease
//
//  Created by Jerome Krakus on 18/04/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import UIKit

class PostLaunchViewController: UIViewController {

    // splash icon view
    var iconView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set gradient background
        setGradientBG()
        // Adding splash icon
        addSplashIcon()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        // Launch icon animation
        animateIcon()
    }

    // Set grandient background layer
    private func setGradientBG() {
        // Set grandientLayer
        let gradientLayer = CAGradientLayer()
        let lightOrange = #colorLiteral(red: 1, green: 0.5972495675, blue: 0, alpha: 1)
        let darkOrange = #colorLiteral(red: 1, green: 0.3406341374, blue: 0, alpha: 1)
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [lightOrange.cgColor, darkOrange.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)

        // Add gradientLayer
        view.layer.addSublayer(gradientLayer)
    }

    // Set the iconView
    private func addSplashIcon() {
        iconView.frame = CGRect(x: 0, y: 0, width: 126, height: 126)
        iconView.image = #imageLiteral(resourceName: "icon-splash")

        view.addSubview(iconView)

        iconView.translatesAutoresizingMaskIntoConstraints = true
        iconView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        iconView.autoresizingMask = [
            UIView.AutoresizingMask.flexibleLeftMargin,
            UIView.AutoresizingMask.flexibleRightMargin,
            UIView.AutoresizingMask.flexibleTopMargin,
            UIView.AutoresizingMask.flexibleBottomMargin
        ]
    }

    private func animateIcon() {
        UIView.animate(withDuration: 0.5, animations: {
            self.iconView.transform = CGAffineTransform(translationX: 0, y: -200)
            self.iconView.alpha = 0
        }) { (_) in
            // Go to the next vc
            let sb = self.storyboard?.instantiateViewController(withIdentifier: "cutomTabBar")
            let vc = sb as! CustomTabBarViewController
            self.present(vc, animated: true)
        }
    }
}

