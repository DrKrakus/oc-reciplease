//
//  SelectedRecipe.swift
//  oc-reciplease
//
//  Created by Jerome Krakus on 06/05/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import Foundation

struct SelectedRecipe: Codable {
    let totalTime: String
    let images: [Image]
    let name: String
    let source: Source
    let id: String
    let ingredientLines: [String]
    let rating: Int
}

struct Image: Codable {
    let hostedLargeURL: String
    
    enum CodingKeys: String, CodingKey {
        case hostedLargeURL = "hostedLargeUrl"
    }
}

struct Source: Codable {
    let sourceRecipeURL: String
    
    enum CodingKeys: String, CodingKey {
        case sourceRecipeURL = "sourceRecipeUrl"
    }
}
