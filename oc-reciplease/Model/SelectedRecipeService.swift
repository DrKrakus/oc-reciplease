//
//  SelectedRecipeService.swift
//  oc-reciplease
//
//  Created by Jerome Krakus on 06/05/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import Foundation
import Alamofire

class SelectedRecipeService {
    // Singleton pattern
    static var shared = SelectedRecipeService()
    private init() {}

    // Selected recip ID for API call
    var recipeID: String?

    // API URL
    private var selectedRecipeURL: URL {
        var urlComponents = URLComponents()

        urlComponents.scheme = "https"
        urlComponents.host = "api.yummly.com"
        urlComponents.path = "/v1/api/recipe/\(SelectedRecipeService.shared.recipeID!)"
        urlComponents.queryItems = [
            URLQueryItem(name: "_app_id", value: ApiKey.yummlyID),
            URLQueryItem(name: "_app_key", value: ApiKey.yummlyKey)
        ]
        
        guard let url = urlComponents.url else {
            fatalError("Could not create url from components")
        }
        
        return url
    }

    // API Call
    func getDetails(callback: @escaping (Bool, SelectedRecipe?) -> Void) {
        // Alamofire request
        AF.request(selectedRecipeURL).responseData { (response) in
                // Check for data
                guard let jsonData = response.data else {
                    callback(false, nil)
                    return
                }
                
                // Decode data to match SelectedRecipe
                do {
                    let JSONDetails = try JSONDecoder().decode(SelectedRecipe.self, from: jsonData)
                    callback(true, JSONDetails)

                } catch let err {
                    print(err)
                    callback(false, nil)
                }
        }
    }
}
