//
//  SelectedRecipeServiceTest.swift
//  oc-recipleaseTests
//
//  Created by Jerome Krakus on 23/05/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import oc_reciplease

class SelectedRecipeServiceTest: XCTestCase {

    func testSelectedRecipeService() {
        SelectedRecipeService.shared.recipeID = "ID"
        // Stub for RecipeService path
        stub(condition: isHost("api.yummly.com")) { (_) -> OHHTTPStubsResponse in
            let stubData = FakeResponseData.selectedRecipeServiceCorrectData
            return OHHTTPStubsResponse(data: stubData!, statusCode: 200, headers: nil)
        }
        // Expectation
        let exp = expectation(description: "Alamofire request expectation")
        SelectedRecipeService.shared.getDetails { (success, selectedRecipe) in
            if success, let selectedRecipe = selectedRecipe {
                XCTAssertEqual(selectedRecipe.id, "Italian-Grilled-Cheese-1600270")
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testSelectedRecipeServiceWithIncorrectData() {
        SelectedRecipeService.shared.recipeID = "ID"
        // Stub for RecipeService path
        stub(condition: isHost("api.yummly.com")) { (_) -> OHHTTPStubsResponse in
            let stubData = FakeResponseData.incorrectData
            return OHHTTPStubsResponse(data: stubData!, statusCode: 200, headers: nil)
        }
        // Expectation
        let exp = expectation(description: "Alamofire request expectation")
        SelectedRecipeService.shared.getDetails { (success, selectedRecipe) in
            guard success else {
                XCTAssertTrue(selectedRecipe == nil)
                exp.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testSelectedRecipeServiceWithNoData() {
        let notConnectedError = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue)
        SelectedRecipeService.shared.recipeID = "ID"
        // Stub for RecipeService path
        stub(condition: isHost("api.yummly.com")) { (_) -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(error: notConnectedError)
        }
        // Expectation
        let exp = expectation(description: "Alamofire request expectation")
        SelectedRecipeService.shared.getDetails { (success, selectedRecipe) in
            guard success else {
                XCTAssertTrue(selectedRecipe == nil)
                exp.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        OHHTTPStubs.removeAllStubs()
    }

}
