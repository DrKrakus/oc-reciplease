//
//  IngredientsViewController.swift
//  oc-reciplease
//
//  Created by Jerome Krakus on 18/04/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import UIKit
import CoreData

class IngredientsViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var fridgeViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var fridgeView: CustomView!
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var addTextfield: UITextField!
    @IBOutlet weak var searchRecipesButton: CustomUIButton!
    @IBOutlet weak var addIngredientButton: CustomUIButton!
    @IBOutlet weak var clearAllIngredients: CustomUIButton!
    @IBOutlet weak var loaderIndicator: UIActivityIndicatorView!

    // MARK: Actions
    @IBAction func didTapCrossButton(_ sender: UIButton) {
        // Delete the row with animation
        Ingredient.shared.ingredients.remove(at: sender.tag)
        ingredientTableView.deleteRows(at: [IndexPath(item: sender.tag, section: 0)], with: .fade)
        // Then after the duration of animation, reload data for matching tag with index
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.ingredientTableView.reloadData()
        }
        // Check for ingredients count
        guard Ingredient.shared.ingredients.count == 0 else {
            return
        }
        // Reset UI position
        hideUIElements()
        setFridgeToCenter()
        addTextfield.resignFirstResponder()
    }

    @IBAction func didTapClearButton(_ sender: Any) {
        clearTableView()
        hideUIElements()
        setFridgeToCenter()
    }

    @IBAction func didTapAddButton(_ sender: Any) {

        guard !addTextfield.text!.isEmpty else {
            return
        }

        addIngredient(addTextfield.text!)
        addTextfield.text = ""
        showUIElements()
    }
    
    @IBAction func didTapSearchRecipesButton(_ sender: Any) {
        // Show loader and hide button
        searchRecipesButton.isHidden = true
        loaderIndicator.isHidden = false
        
        RecipeService.shared.getRecipes { (success) in
            // Show button and hide loader
            self.searchRecipesButton.isHidden = false
            self.loaderIndicator.isHidden = true

            if success {
                // Check if matching recipes has been found
                guard !MatchingRecipes.shared.recipes.isEmpty else {
                    self.showRecipesNotFoundAlert()
                    return
                }
                // Go to the RecipesListView
                self.performSegue(withIdentifier: "recipesListSegue", sender: nil)
            } else {
                self.showNetworkErrorAlert()
            }
        }
    }
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        addTextfield.setBottomBorder()
        searchRecipesButton.setCustomButtonStyle()
        setLogoInNavBar()
        hideUIElements()
        setFridgeToCenter()
    }

    /// Set a logo instead a title in the navigation bar
    private func setLogoInNavBar() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "icon-logo-navbar"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }

    /// Clear the tableView
    private func clearTableView(){
        addTextfield.resignFirstResponder()
        Ingredient.shared.clearIngredients()
        ingredientTableView.reloadData()
    }

    /// Add ingredient to array
    ///
    /// - Parameter ingredient: String
    private func addIngredient(_ ingredient: String) {
        Ingredient.shared.add(ingredient)
        ingredientTableView.reloadData()
    }

    /// Hide the some of UI
    private func hideUIElements() {
            self.ingredientTableView.alpha = 0
            self.headerStackView.alpha = 0
            self.searchRecipesButton.alpha = 0
    }

    /// Show the hidden UI
    private func showUIElements() {
        UIView.animate(withDuration: 0.2) {
            self.ingredientTableView.alpha = 1
            self.headerStackView.alpha = 1
            self.searchRecipesButton.alpha = 1
        }
    }

    /// Get the fridgeView centered
    private func setFridgeToCenter() {
        // Get the middle of the screen
        let halfScreen = UIScreen.main.bounds.size.height / 2
        let fridgeViewHeight = fridgeView.bounds.size.height

        UIView.animate(withDuration: 0.3) {
            self.fridgeViewTopConstraint.constant = halfScreen - fridgeViewHeight
            self.view.layoutIfNeeded()
        }
    }

    private func setFridgeToTop() {
        UIView.animate(withDuration: 0.3) {
            self.fridgeViewTopConstraint.constant = 8
            self.view.layoutIfNeeded()
        }
    }
}

// TableView protocol
extension IngredientsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Ingredient.shared.ingredients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the cell
        let cellID = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        // Get the ingredient
        let ingredient = Ingredient.shared.ingredients[indexPath.row]

        // Check if the cell as the good type
        guard let cell = cellID as? IngredientTableViewCell else {
            return UITableViewCell()
        }

        // Assign tag for crossButton
        cell.crossButton.tag = indexPath.row

        // Configure the cell
        cell.configure(with: ingredient)
        return cell
    }
}

// TextField protocol
extension IngredientsViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        setFridgeToTop()
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard !textField.text!.isEmpty else {
            textField.resignFirstResponder()

            if Ingredient.shared.ingredients.isEmpty {
                setFridgeToCenter()
            }

            return true
        }

        addIngredient(textField.text!)
        textField.text! = ""
        textField.resignFirstResponder()
        showUIElements()
        return true
    }
}

// User Alerts
extension IngredientsViewController {

    func showRecipesNotFoundAlert() {
        let alertVC = UIAlertController.init(title: "Oups...",
                                             message: "No recipes found with your ingredients list",
                                             preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK", style: .default)

        alertVC.addAction(action)
        present(alertVC, animated: true)
    }

    func showNetworkErrorAlert() {
        let alertVC = UIAlertController.init(title: "Network Error",
                                             message: "Check your network connection and try again",
                                             preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK", style: .default)
        
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }
}
