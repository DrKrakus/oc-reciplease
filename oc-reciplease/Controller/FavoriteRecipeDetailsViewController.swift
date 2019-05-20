//
//  FavoriteRecipeDetailsViewController.swift
//  oc-reciplease
//
//  Created by Jerome Krakus on 20/05/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import UIKit
import CoreData

class FavoriteRecipeDetailsViewController: UIViewController {

    /// MARK: Outlets
    @IBOutlet weak var recipeBGKView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeDurationLabel: UILabel!
    @IBOutlet weak var recipeLikeLabel: UILabel!
    @IBOutlet weak var recipeIngredientsTextView: UITextView!
    @IBOutlet weak var getDirectionsButton: CustomUIButton!
    @IBOutlet weak var favoriteBarButton: UIBarButtonItem!

    /// MARK: Properties
    var selectedFavoriteRecipe: FavoriteRecipe!

    /// MARK: Actions
    @IBAction func didTapGetDirectionButton(_ sender: Any) {
        // Check for selectedRecipe
        guard let selectedFavoriteRecipe = selectedFavoriteRecipe else {
            return
        }
        // Check for URL String
        guard let sourceRecipeURL = selectedFavoriteRecipe.sourceRecipeURL else {
            return
        }
        // Check for URL
        guard let url = URL(string: sourceRecipeURL) else {
            return
        }
        // Open link in safari
        UIApplication.shared.open(url, options: [:])
    }

    @IBAction func didTapFavoriteBarButton(_ sender: Any) {
        deleteRecipeToBDD()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLogoInNavBar()
        setupView()
    }

    // Set a logo instead a title in the navigation bar
    private func setLogoInNavBar() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "icon-logo-navbar"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }

    // Setup View from selectedFavortieRecipe datas
    private func setupView() {
        // Check for optional values
        guard let imgURL = selectedFavoriteRecipe.imageURL else { return }
        guard let URL = URL(string: imgURL) else { return }
        guard let title = selectedFavoriteRecipe.name else { return }
        guard let duration = selectedFavoriteRecipe.totalTime else { return }
        guard let ingredientLines = selectedFavoriteRecipe.ingredientLines else { return }
        let ratio = selectedFavoriteRecipe.rating

        // Setup View
        recipeBGKView.load(URL)
        recipeTitleLabel.text = title
        recipeDurationLabel.text = duration
        recipeLikeLabel.text = String(ratio)
        getDirectionsButton.setCustomButtonStyle()

        // Add ingredients line to textView
        for ingredientsLine in ingredientLines {
            recipeIngredientsTextView.text += "- " + ingredientsLine + "\n"
        }
    }

    // Delete the recipe from favorite
    private func deleteRecipeToBDD() {
        // Get the recipe ID
        guard let recipeID = selectedFavoriteRecipe.id else {
            return
        }
        // Try to delete recipe
        FavoriteRecipe.deleteRecipe(with: recipeID)
        // Try to save
        do {
            try AppDelegate.context.save()
            // Show Alert
            removeToFavoriteAlert()
        } catch let err {
            print(err)
        }
    }
}

// Alerts
extension FavoriteRecipeDetailsViewController {
    private func removeToFavoriteAlert() {
        // Alert VC
        let alertVC = UIAlertController.init(title: "Well..", message: "This recipe is no longer in your favorite list", preferredStyle: .alert)
        
        // OK Button
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            // Close the view
            self.navigationController?.popViewController(animated: true)
        }
        
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }
}
