//
//  CustomView.swift
//  oc-reciplease
//
//  Created by Jerome Krakus on 18/04/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import UIKit

@IBDesignable class CustomView: UIView {

    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

@IBDesignable extension UIStackView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}

extension UIView {
    func setCustomButtonStyle(){
        // Gradient Background
        let gradientLayer = CAGradientLayer()
        let lightOrange = #colorLiteral(red: 1, green: 0.5972495675, blue: 0, alpha: 1)
        let darkOrange = #colorLiteral(red: 1, green: 0.3406341374, blue: 0, alpha: 1)
        gradientLayer.frame = bounds
        gradientLayer.colors = [lightOrange.cgColor, darkOrange.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)

        // Corner Radius
        gradientLayer.cornerRadius = CGFloat(28.5)
        
        // Add gradientLayer
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = #colorLiteral(red: 0.2990769744, green: 0.3740481138, blue: 0.4247795343, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 0.0
    }
}

extension UIImageView {

    func load(_ url: URL) {
        DispatchQueue.global().async { [weak self] in
            guard let data = try? Data(contentsOf: url) else {
                return
            }
            guard let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
