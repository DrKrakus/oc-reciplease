//
//  Recipes.swift
//  oc-reciplease
//
//  Created by Jerome Krakus on 23/04/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import Foundation

struct Recipes: Codable {
    let matches: [Match]
}

struct Match: Codable {
    let imageUrlsBySize: ImageUrlsBySize
    let sourceDisplayName: String
    let ingredients: [String]
    let id: String
    let recipeName: String
    let totalTimeInSeconds: Int
    let rating: Int
}

struct ImageUrlsBySize: Codable {
    let the90: String
    
    enum CodingKeys: String, CodingKey {
        case the90 = "90"
    }
}
