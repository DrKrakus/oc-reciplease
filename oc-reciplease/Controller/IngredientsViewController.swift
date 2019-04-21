//
//  IngredientsViewController.swift
//  oc-reciplease
//
//  Created by Jerome Krakus on 18/04/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import UIKit

class IngredientsViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var IngredientTableView: UITableView!
    @IBOutlet weak var addTextfield: UITextField!
    @IBOutlet weak var searchRecipesButton: CustomUIButton!
    @IBOutlet weak var addIngredientButton: CustomUIButton!
    @IBOutlet weak var clearAllIngredients: CustomUIButton!

    
    // MARK: Properties
    var ingredientArray: [String] = []

    // MARK: Action
    @IBAction func didTapClearButton(_ sender: Any) {
        clearTableView()
    }

    @IBAction func didTapAddButton(_ sender: Any) {

        guard !addTextfield.text!.isEmpty else {
            return
        }

        addToIngredientArray(addTextfield.text!)
        addTextfield.text = ""
        addTextfield.resignFirstResponder()
    }

    @IBAction func didTapDeleteCellButton(_ sender: Any) {
    }

    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        addTextfield.setBottomBorder()
        searchRecipesButton.setCustomButtonStyle()
        setLogoInNavBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }

    /// Set a logo instead a title in the navigation bar
    private func setLogoInNavBar() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "icon-logo-navbar"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }

    /// Clear the tableView
    private func clearTableView(){
        ingredientArray = []
        IngredientTableView.reloadData()
    }

    private func addToIngredientArray(_ ingredient: String) {
        ingredientArray.append(ingredient)
        IngredientTableView.reloadData()
    }
}

// TableView protocol
extension IngredientsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the cell
        let cellID = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        // Get the ingredient
        let ingredient = ingredientArray[indexPath.row]

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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard !textField.text!.isEmpty else {
            textField.resignFirstResponder()
            return true
        }

        addToIngredientArray(textField.text!)
        textField.text! = ""
        textField.resignFirstResponder()
        return true
    }
}
