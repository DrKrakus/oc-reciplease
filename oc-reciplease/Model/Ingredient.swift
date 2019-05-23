//
//  Ingredient.swift
//  oc-reciplease
//
//  Created by Jerome Krakus on 22/04/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import Foundation

class Ingredient {
    // Singleton Pattern
    static var shared = Ingredient()
    private init() {}

    // Array of ingredient
    var ingredients: [String] = []
}
