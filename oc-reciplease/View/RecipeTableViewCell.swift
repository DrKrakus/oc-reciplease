//
//  RecipeTableViewCell.swift
//  oc-reciplease
//
//  Created by Jerome Krakus on 23/04/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratioLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    // MARK: Properties
    var recipeID: String?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // Configure for matching recipes
    func configure(imgURL: String, title: String, ratio: Int, duration: Int, id: String) {
        // Change the size of image by modifying the URL
        let biggerImgUrl = imgURL.replacingOccurrences(of: "=s90-c", with: "=s360-c")
        guard let URL = URL(string: biggerImgUrl) else { return }

        // Configure the cell
        self.imageBackground.load(URL)
        self.titleLabel.text = title
        self.ratioLabel.text = String(ratio)
        self.durationLabel.text = String(duration / 60) + " min"
        self.recipeID = id
    }

    // Configure for favoriteRecipe
    func favoriteConfiguration(imgURL: URL, title: String, ratio: Int16, duration: String, id: String) {
        // Configure the cell
        self.titleLabel.text = title
        self.ratioLabel.text = String(ratio)
        self.durationLabel.text = duration
        self.recipeID = id
        self.imageBackground.load(imgURL)
    }
}
