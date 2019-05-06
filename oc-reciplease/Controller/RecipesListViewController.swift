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
extension RecipesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MatchingRecipes.shared.recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the cell
        let cellID = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        // Get the recipes
        let recipe = MatchingRecipes.shared.recipes[indexPath.row]
        
        // Check if the cell as the good type
        guard let cell = cellID as? RecipeTableViewCell else {
            return UITableViewCell()
        }

        // Configure the cell
        cell.configure(imgURL: recipe.imageUrlsBySize.the90,
                       title: recipe.recipeName,
                       ratio: recipe.rating,
                       duration: recipe.totalTimeInSeconds,
                       id: recipe.id)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Current Cell
        let currentCell = tableView.cellForRow(at: indexPath) as! RecipeTableViewCell

        // Set SelectedRecipe ID
        SelectedRecipeService.shared.recipeID = currentCell.recipeID

        // Then go to the next View
        self.performSegue(withIdentifier: "recipeDetailSegue", sender: nil)
    }
}
