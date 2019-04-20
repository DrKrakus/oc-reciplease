//
//  ViewController.swift
//  oc-reciplease
//
//  Created by Jerome Krakus on 18/04/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import UIKit

class PostLaunchViewController: UIViewController {

    // Set the statusbar text color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

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
        super.viewDidAppear(true)
        // Launch icon animation
        animateIcon()
    }

    // Set grandient background layer
    private func setGradientBG() {
        // Set grandientLayer
        let gradientLayer = CAGradientLayer()
        let lightOrange = #colorLiteral(red: 0.9921568627, green: 0.6156862745, blue: 0, alpha: 1)
        let darkOrange = #colorLiteral(red: 0.9803921569, green: 0.3921568627, blue: 0, alpha: 1)
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
        UIView.animate(withDuration: 1, animations: {
            self.iconView.transform = CGAffineTransform(translationX: 0, y: 200)
            self.iconView.alpha = 0
        }) { (_) in
            // Go to the next vc
            let sb = self.storyboard?.instantiateViewController(withIdentifier: "customNavController")
            let vc = sb as! CustomNavigationViewController
            self.present(vc, animated: true)
        }
    }
}

