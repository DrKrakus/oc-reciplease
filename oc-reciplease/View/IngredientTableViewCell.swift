//
//  IngredientTableViewCell.swift
//  oc-reciplease
//
//  Created by Jerome Krakus on 21/04/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var crossButton: UIButton!

    func configure(with ingredient: String) {
        titleLabel.text! = ingredient
    }
}
