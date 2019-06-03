//
//  StorageManager.swift
//  oc-reciplease
//
//  Created by Jerome Krakus on 23/05/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class StorageManager {

    let persistentContainer: NSPersistentContainer!

    //Init for test
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
    }

    convenience init() {
        //Use the default container for production environment
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate unavailable")
        }
        self.init(container: appDelegate.persistentContainer)
    }

    /// Fetch all the favorite recipe
    func fetchAll() -> [FavoriteRecipe] {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        guard let favoriteRecipes = try? persistentContainer.viewContext.fetch(request) else { return [] }
        return favoriteRecipes
    }

    /// Delete recipe with ID
    func deleteRecipe(with ID: String) {
        // Create Request
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", ID)

        // Try to delete recipe
        do {
            let recipes = try persistentContainer.viewContext.fetch(request)
            persistentContainer.viewContext.delete(recipes[0])
        } catch let err {
            print(err)
        }
    }
}
