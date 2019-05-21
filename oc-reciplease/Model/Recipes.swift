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
// swiftlint:disable identifier_name
struct Match: Codable {
    let smallImageUrls: [String]
    let sourceDisplayName: String
    let ingredients: [String]
    let id: String
    let recipeName: String
    let totalTimeInSeconds: Int
    let rating: Int
}
