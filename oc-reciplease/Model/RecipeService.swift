//
//  RecipeService.swift
//  oc-reciplease
//
//  Created by Jerome Krakus on 22/04/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import Foundation
import Alamofire

class RecipeService {
    // Singleton pattern
    static var shared = RecipeService()
    private init() {}

    // API URL
    private var apiURL: URL {
        var urlComponents = URLComponents()

        urlComponents.scheme = "https"
        urlComponents.host = "api.yummly.com"
        urlComponents.path = "/v1/api/recipes"
        urlComponents.queryItems = [
            URLQueryItem(name: "_app_id", value: ApiKey.yummlyID),
            URLQueryItem(name: "_app_key", value: ApiKey.yummlyKey),
            URLQueryItem(name: "allowedIngredient", value: "cheese"),
            URLQueryItem(name: "allowedIngredient", value: "tomatoes"),
            URLQueryItem(name: "allowedIngredient", value: "herbs")
        ]

        guard let url = urlComponents.url else {
            fatalError("Could not create url from components")
        }

        return url
    }

    func getRecipes(callback: @escaping (Bool) -> Void) {
        // Reset the recipes list
        MatchingRecipes.shared.recipes = []

        // Alamofire request
        AF.request(apiURL)
            .responseData { (response) in
                // Check for data
                guard let jsonData = response.data else {
                    callback(false)
                    return
                }

                // Decode data to match Recipes
                do {
                    let JSONrecipes = try JSONDecoder().decode(Recipes.self, from: jsonData)

                    JSONrecipes.matches.forEach({ MatchingRecipes.shared.add(recipe: $0)})
                    callback(true)

                } catch let err {
                    print(err)
                    callback(false)
                }
        }
    }
}
