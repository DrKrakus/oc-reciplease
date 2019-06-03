//
//  RecipeDetailViewController.swift
//  oc-reciplease
//
//  Created by Jerome Krakus on 06/05/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import UIKit
import CoreData

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
    let storageManager = StorageManager()
    var selectedRecipe: SelectedRecipe?
    var isFavorite = false

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
        // If selectedRecipe is tag as favorite
        if isFavorite {
            removeToFavorite()
        } else {
            addToFavorite()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setLogoInNavBar()
        showLoadingView()
        getRecipeDetail()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
        navigationController?.popViewController(animated: true)
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
        // Check for imgURL
        guard let imgURL = URL(string: selectedRecipe.images[0].hostedLargeURL) else {
            return
        }

        // Setup the UIView
        recipeLikeLabel.text = String(selectedRecipe.rating)
        recipeDurationLabel.text = selectedRecipe.totalTime
        recipeTitleLabel.text = selectedRecipe.name
        getDirectionsButton.setCustomButtonStyle()
        recipeBGKView.load(imgURL)

        // Add ingredients line to textView
        for ingredientsLine in selectedRecipe.ingredientLines {
            self.recipeIngredientsTextView.text += "- " + ingredientsLine + "\n"
        }

        // Then hide the loadingView after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.hideLoadingView()
        }
    }

    /// Add recipe to coreData
    private func addToFavorite() {
        // Check for selectedRecipe
        guard let selectedRecipe = selectedRecipe else { return }
        // Tag as favorite
        isFavorite = true
        favoriteBarButton.tintColor = #colorLiteral(red: 1, green: 0.3406341374, blue: 0, alpha: 1)

        // Get context
        let favoriteRecipe = FavoriteRecipe(context: storageManager.persistentContainer.viewContext)

        // Create the favoriteRecipeObject
        favoriteRecipe.id = selectedRecipe.id
        favoriteRecipe.imageURL = selectedRecipe.images[0].hostedLargeURL
        favoriteRecipe.ingredientLines = selectedRecipe.ingredientLines
        favoriteRecipe.name = selectedRecipe.name
        favoriteRecipe.rating = Int16(selectedRecipe.rating)
        favoriteRecipe.sourceRecipeURL = selectedRecipe.source.sourceRecipeURL
        favoriteRecipe.totalTime = selectedRecipe.totalTime

        // Save of context
        do {
            try storageManager.persistentContainer.viewContext.save()
            // Show alert
            successSaveAlert()
        } catch let err {
            print(err)
            // Show alert
            failSaveAlert()
            // Reset button style
            isFavorite = false
            favoriteBarButton.tintColor = #colorLiteral(red: 0.2990769744, green: 0.3740481138, blue: 0.4247795343, alpha: 0.5)
        }
    }

    /// Remove recipe from coreData
    private func removeToFavorite() {
        // Check for selectedRecipe
        guard let selectedRecipe = selectedRecipe else { return }
        // Tag as no favorite
        isFavorite = false
        favoriteBarButton.tintColor = #colorLiteral(red: 0.2990769744, green: 0.3740481138, blue: 0.4247795343, alpha: 0.5)
        // Delete recipe
        storageManager.deleteRecipe(with: selectedRecipe.id)
        // Try to save
        do {
            try storageManager.persistentContainer.viewContext.save()
            // Show Alert
            removeToFavoriteAlert()
        } catch let err {
            print(err)
            // Reset button style
            isFavorite = true
            favoriteBarButton.tintColor = #colorLiteral(red: 1, green: 0.3406341374, blue: 0, alpha: 1)
        }
    }
}

// Alerts
extension RecipeDetailViewController {
    private func alertDetailsNotFound() {
        // Alert VC
        let alertVC = UIAlertController.init(title: "Oups...",
                                             message: "Could not found details for this recipe, try again.",
                                             preferredStyle: .alert)

        // OK Button
        let action = UIAlertAction.init(title: "OK", style: .default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }

        alertVC.addAction(action)
        present(alertVC, animated: true)
    }

    private func successSaveAlert() {
        // Alert VC
        let alertVC = UIAlertController.init(title: "Cool!",
                                             message: "This recipe is now in your favorite list",
                                             preferredStyle: .alert)

        // OK Button
        let action = UIAlertAction.init(title: "OK", style: .default)

        alertVC.addAction(action)
        present(alertVC, animated: true)
    }

    private func failSaveAlert() {
        // Alert VC
        let alertVC = UIAlertController.init(title: "Oups...",
                                             message: "Impossible to save this recipe, try again.",
                                             preferredStyle: .alert)

        // OK Button
        let action = UIAlertAction.init(title: "OK", style: .default)

        alertVC.addAction(action)
        present(alertVC, animated: true)
    }

    private func removeToFavoriteAlert() {
        // Alert VC
        let alertVC = UIAlertController.init(title: "Well..",
                                             message: "This recipe is no longer in your favorite list",
                                             preferredStyle: .alert)

        // OK Button
        let action = UIAlertAction.init(title: "OK", style: .default)

        alertVC.addAction(action)
        present(alertVC, animated: true)
    }
}
