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
    var favoriteRecipes = FavoriteRecipe.all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLogoInNavBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Get the new array
        favoriteRecipes = FavoriteRecipe.all
        favoriteTableView.reloadData()
        checkForFavoriteRecipesCount()
    }

    private func setLogoInNavBar() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "icon-logo-navbar"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
    private func checkForFavoriteRecipesCount() {
        guard favoriteRecipes.count > 0 else {
            return
        }
        noFavoriteView.isHidden = true
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

        // Check for optional values
        guard let imgURL = recipe.imageURL else { return UITableViewCell() }
        guard let URL = URL(string: imgURL) else { return UITableViewCell() }
        guard let title = recipe.name else { return UITableViewCell() }
        guard let duration = recipe.totalTime else { return UITableViewCell() }
        guard let id = recipe.id else { return UITableViewCell() }
        let ratio = recipe.rating

        // Configure the cell
        cell.favoriteConfiguration(imgURL: URL,
                                   title: title,
                                   ratio: ratio,
                                   duration: duration,
                                   id: id)
        return cell
    }
}
