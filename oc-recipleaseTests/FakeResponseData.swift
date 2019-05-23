//
//  FakeResponseData.swift
//  oc-recipleaseTests
//
//  Created by Jerome Krakus on 23/05/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import Foundation
// swiftlint:disable all
class FakeResponseData {
    // Bundle indentifier
    private static let bundle = Bundle(for: FakeResponseData.self)

    // For RecipeService response data
    static var recipeServiceCorrectData: Data? {
        let url = bundle.url(forResource: "RecipeServiceResponse", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    // For SelectedRecipeService response data
    static var selectedRecipeServiceCorrectData: Data? {
        let url = bundle.url(forResource: "SelectedRecipeServiceResponse", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    // For incorrect data
    static var incorrectData: Data? {
        let data = "error".data(using: .utf8)!
        return data
    }
}
