//
//  RecipesListViewController.swift
//  oc-reciplease
//
//  Created by Jerome Krakus on 21/04/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import UIKit

class RecipesListViewController: UIViewController {

    @IBOutlet weak var recipesTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setLogoInNavBar()
    }

    private func setLogoInNavBar() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "icon-logo-navbar"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
}

// TableView protocol
extension RecipesListViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MatchingRecipes.shared.recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the cell
        let cellID = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        // Check if the cell as the good type
        guard let cell = cellID as? RecipeTableViewCell else { return UITableViewCell() }

        // Get the recipes
        let recipe = MatchingRecipes.shared.recipes[indexPath.row]

        // Configure the cell
        cell.configure(with: recipe)

        return cell
    }

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            // Get the cell
            let prefetchCell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
            // Check if the cell as the good type
            guard let cell = prefetchCell as? RecipeTableViewCell else { return }
            // Get the matching recipe
            let recipe = MatchingRecipes.shared.recipes[indexPath.row]
            // Configure the prefetchCell with matching recipe
            cell.configure(with: recipe)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Current Cell
        guard let currentCell = tableView.cellForRow(at: indexPath) as? RecipeTableViewCell else {
            return
        }

        // Set SelectedRecipe ID
        SelectedRecipeService.shared.recipeID = currentCell.recipeID

        // Then go to the next View
        self.performSegue(withIdentifier: "recipeDetailSegue", sender: nil)
    }
}
