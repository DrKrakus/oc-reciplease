//
//  FavoriteListViewController.swift
//  oc-reciplease
//
//  Created by Jerome Krakus on 16/05/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import UIKit
import CoreData

class FavoriteListViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var favoriteTableView: UITableView!
    @IBOutlet weak var noFavoriteView: UIView!

    // MARK: Properties
    var favoriteRecipes = StorageManager().fetchAll()
    var selectedFavoriteRecipe: FavoriteRecipe?

    override func viewDidLoad() {
        super.viewDidLoad()
        setLogoInNavBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Get the new array
        favoriteRecipes = StorageManager().fetchAll()
        favoriteTableView.reloadData()
        checkForFavoriteRecipesCount()
    }

    private func setLogoInNavBar() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "icon-logo-navbar"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }

    private func checkForFavoriteRecipesCount() {

        if favoriteRecipes.count > 0 {
            noFavoriteView.isHidden = true
        } else {
            noFavoriteView.isHidden = false
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Check for segue identifier
        guard segue.identifier == "favoriteRecipeDetailsSegue" else {
            return
        }
        // Check for segue destination
        guard let detailsVC = segue.destination as? FavoriteRecipeDetailsViewController else {
            return
        }
        // Check for selectedFavoriteRecipe
        guard let selectedFavoriteRecipe = selectedFavoriteRecipe else {
            return
        }
        // Assign selectedFavoriteRecipe
        detailsVC.selectedFavoriteRecipe = selectedFavoriteRecipe
    }
}

extension FavoriteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRecipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the cell
        let cellID = tableView.dequeueReusableCell(withIdentifier: "favoriteRecipeCell", for: indexPath)
        // Check if the cell as the good type
        guard let cell = cellID as? RecipeTableViewCell else {
            return UITableViewCell()
        }

        // Get the recipe
        let recipe = favoriteRecipes[indexPath.row]

        // Configure the cell
        cell.favoriteConfiguration(with: recipe)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Matching FavoriteRecipe
        let selectedFavoriteRecipe = favoriteRecipes[indexPath.row]
        // Assign selectedRecipe
        self.selectedFavoriteRecipe = selectedFavoriteRecipe
        // Then perform transition
        performSegue(withIdentifier: "favoriteRecipeDetailsSegue", sender: nil)
    }
}
