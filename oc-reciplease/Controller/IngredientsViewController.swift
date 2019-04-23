//
//  IngredientsViewController.swift
//  oc-reciplease
//
//  Created by Jerome Krakus on 18/04/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import UIKit

class IngredientsViewController: UIViewController {

    @IBOutlet weak var fridgeViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var fridgeView: CustomView!
    @IBOutlet weak var headerStackView: UIStackView!
    // MARK: Outlets
    @IBOutlet weak var IngredientTableView: UITableView!
    @IBOutlet weak var addTextfield: UITextField!
    @IBOutlet weak var searchRecipesButton: CustomUIButton!
    @IBOutlet weak var addIngredientButton: CustomUIButton!
    @IBOutlet weak var clearAllIngredients: CustomUIButton!
    @IBOutlet weak var loaderIndicator: UIActivityIndicatorView!
    
    // MARK: Properties

    // MARK: Action
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
                self.performSegue(withIdentifier: "recipesListSegue", sender: nil)
            } else {
                print("Networking error")
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
        IngredientTableView.reloadData()
    }

    /// Add ingredient to array
    ///
    /// - Parameter ingredient: String
    private func addIngredient(_ ingredient: String) {
        Ingredient.shared.add(ingredient)
        IngredientTableView.reloadData()
    }

    /// Hide the some of UI
    private func hideUIElements() {
            self.IngredientTableView.alpha = 0
            self.headerStackView.alpha = 0
            self.searchRecipesButton.alpha = 0
    }

    /// Show the hidden UI
    private func showUIElements() {
        UIView.animate(withDuration: 0.2) {
            self.IngredientTableView.alpha = 1
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
