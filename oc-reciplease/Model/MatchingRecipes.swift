//
//  MatchingRecipes.swift
//  oc-reciplease
//
//  Created by Jerome Krakus on 23/04/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import Foundation

class MatchingRecipes {
    // Singleton Pattern
    static var shared = MatchingRecipes()
    private init() {}

    var recipes: [Match] = []

    func add(_ recipe: Match) {
        recipes.append(recipe)
    }
}
