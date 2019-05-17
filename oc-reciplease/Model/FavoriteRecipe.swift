//
//  FavoriteRecipe.swift
//  oc-reciplease
//
//  Created by Jerome Krakus on 14/05/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import Foundation
import CoreData

class FavoriteRecipe: NSManagedObject {
    // Fetch request for FavoriteRecipe
    static var all: [FavoriteRecipe] {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        guard let favoriteRecipes = try? AppDelegate.context.fetch(request) else { return [] }
        return favoriteRecipes
    }
}
