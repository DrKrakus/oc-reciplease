//
//  RecipeDetailViewController.swift
//  oc-reciplease
//
//  Created by Jerome Krakus on 06/05/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var recipeBGKView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeDurationLabel: UILabel!
    @IBOutlet weak var recipeLikeLabel: UILabel!
    @IBOutlet weak var recipeIngredientsTextView: UITextView!
    @IBOutlet weak var getDirectionsButton: CustomUIButton!
    @IBOutlet weak var favorisBarButton: UIBarButtonItem!

    // MARK: Actions
    @IBAction func didTapGetDirectionButton(_ sender: Any) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        getRecipeDetail()
    }

    private func getRecipeDetail() {
        // Get detail from API
        SelectedRecipeService.shared.getDetails { (success, selectedRecipe) in
            if success, let selectedRecipe = selectedRecipe {
                self.recipeLikeLabel.text = String(selectedRecipe.rating)
                self.recipeDurationLabel.text = selectedRecipe.totalTime
                self.recipeTitleLabel.text = selectedRecipe.name
                self.recipeIngredientsTextView.text = selectedRecipe.ingredientLines.description
                self.recipeBGKView.load(URL(string: selectedRecipe.images[0].hostedLargeURL)!)
            } else {
                print("Could not get the details, try again")
            }
        }
    }
}
