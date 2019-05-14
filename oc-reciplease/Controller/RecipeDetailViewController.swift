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
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var recipeBGKView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeDurationLabel: UILabel!
    @IBOutlet weak var recipeLikeLabel: UILabel!
    @IBOutlet weak var recipeIngredientsTextView: UITextView!
    @IBOutlet weak var getDirectionsButton: CustomUIButton!
    @IBOutlet weak var favoriteBarButton: UIBarButtonItem!

    // MARK: Properties
    var selectedRecipe: SelectedRecipe?
    
    // MARK: Actions
    @IBAction func didTapGetDirectionButton(_ sender: Any) {
        // Check for selectedRecipe
        guard let selectedRecipe = selectedRecipe else {
            return
        }
        // Check for url
        guard let url = URL(string: selectedRecipe.source.sourceRecipeURL) else {
            return
        }
        // Open link in safari
        UIApplication.shared.open(url, options: [:])
    }

    @IBAction func didTapFavoriteButton(_ sender: Any) {
        // Check for selectedRecipe
        guard let selectedRecipe = selectedRecipe else {
            return
        }
        // If selectedRecipe is tag as favorite
        if selectedRecipe.isFavorite == nil {
            addToFavorite()
        } else {
            removeToFavorite()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setLogoInNavBar()
        showLoadingView()
        getRecipeDetail()
    }

    // Set a logo instead a title in the navigation bar
    private func setLogoInNavBar() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "icon-logo-navbar"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }

    // Show loadingView
    private func showLoadingView() {
        self.loadingView.alpha = 1
        self.loadingView.isHidden = false
    }

    // Hide loadingView
    private func hideLoadingView() {
        self.loadingView.alpha = 0
        self.loadingView.isHidden = true
    }

    // Get selected recipe detail
    private func getRecipeDetail() {
        // Get detail from API
        SelectedRecipeService.shared.getDetails { (success, selectedRecipe) in
            if success, let selectedRecipe = selectedRecipe {
                self.setupView(with: selectedRecipe)
                self.selectedRecipe = selectedRecipe
            } else {
                self.alertDetailsNotFound()
            }
        }
    }

    /// Setup the view with the selected recipe
    ///
    /// - Parameter selectedRecipe: SelectedRecipe receive from API
    private func setupView(with selectedRecipe: SelectedRecipe) {
        // Setup the UIView
        self.recipeLikeLabel.text = String(selectedRecipe.rating)
        self.recipeDurationLabel.text = selectedRecipe.totalTime
        self.recipeTitleLabel.text = selectedRecipe.name
        self.recipeBGKView.load(URL(string: selectedRecipe.images[0].hostedLargeURL)!)
        self.getDirectionsButton.setCustomButtonStyle()

        // Add ingredients line to textView
        for ingredientsLine in selectedRecipe.ingredientLines {
            self.recipeIngredientsTextView.text += "- " + ingredientsLine + "\n"
        }

        // Then hide the loadingView after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.hideLoadingView()
        }
    }

    private func addToFavorite() {
        selectedRecipe!.isFavorite = true
        favoriteBarButton.tintColor = #colorLiteral(red: 0.9803922772, green: 0.3921568394, blue: 0, alpha: 1)
        addToFavoriteAlert()
    }

    private func removeToFavorite() {
        selectedRecipe!.isFavorite = nil
        favoriteBarButton.tintColor = #colorLiteral(red: 0.2990769744, green: 0.3740481138, blue: 0.4247795343, alpha: 0.5)
        removeToFavoriteAlert()
    }
}

// Alerts
extension RecipeDetailViewController {
    private func alertDetailsNotFound() {
        // Alert VC
        let alertVC = UIAlertController.init(title: "Oups...", message: "Could not found details for this recipe, check your connection and try again.", preferredStyle: .alert)

        // OK Button
        let action = UIAlertAction.init(title: "OK", style: .default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }

        alertVC.addAction(action)
        present(alertVC, animated: true)
    }

    private func addToFavoriteAlert() {
        // Alert VC
        let alertVC = UIAlertController.init(title: "Cool!", message: "This recipe is now in your favorite list", preferredStyle: .alert)
        
        // OK Button
        let action = UIAlertAction.init(title: "OK", style: .default)
        
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }

    private func removeToFavoriteAlert() {
        // Alert VC
        let alertVC = UIAlertController.init(title: "Well..", message: "This recipe is no longer in your favorite list", preferredStyle: .alert)
        
        // OK Button
        let action = UIAlertAction.init(title: "OK", style: .default)
        
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }
}
