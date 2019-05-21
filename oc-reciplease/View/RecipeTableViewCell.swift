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

    func configure(with recipe: Match) {
        // Change the size of image by modifying the URL
        let biggerImgUrl = recipe.smallImageUrls[0].replacingOccurrences(of: "=s90", with: "=s360")
        guard let URL = URL(string: biggerImgUrl) else { return }

        // Configure the cell
        self.imageBackground.load(URL)
        self.titleLabel.text = recipe.recipeName
        self.ratioLabel.text = String(recipe.rating)
        self.durationLabel.text = String(recipe.totalTimeInSeconds / 60) + " min"
        self.recipeID = recipe.id
    }

    // Configure for favoriteRecipe
    func favoriteConfiguration(with recipe: FavoriteRecipe) {
        // Check for optionnal values
        guard let title = recipe.name else { return }
        guard let duration = recipe.totalTime else { return }
        guard let id = recipe.id else { return }
        guard let imgURLString = recipe.imageURL else { return }
        guard let imgURL = URL(string: imgURLString) else { return }

        // Configure the cell
        self.titleLabel.text = title
        self.ratioLabel.text = String(recipe.rating)
        self.durationLabel.text = duration
        self.recipeID = id
        self.imageBackground.load(imgURL)
    }
}
