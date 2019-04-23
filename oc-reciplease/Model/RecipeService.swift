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
    static let shared = RecipeService()
    private init() {}

    // API URL
    private var apiURL: URL {
        var urlComponents = URLComponents()

        urlComponents.scheme = "https"
        urlComponents.host = "api.yummly.com"
        urlComponents.path = "/v1/api/recipes"
        urlComponents.queryItems = [
            URLQueryItem(name: "_app_id", value: ApiKey.yummlyID),
            URLQueryItem(name: "_app_key", value: ApiKey.yummlyKey)
        ]

        guard let url = urlComponents.url else {
            fatalError("Could not create url from components")
        }

        return url
    }

    // Session configuration default
    private var recipeSession = URLSession(configuration: .default)

    // Init for UnitTest URLSessionFake
    init(recipeSession: URLSession) {
        self.recipeSession = recipeSession
    }

    // Task
    private var task: URLSessionDataTask?
}
