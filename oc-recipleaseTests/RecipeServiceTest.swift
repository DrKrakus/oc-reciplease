//
//  RecipeServiceTest.swift
//  oc-recipleaseTests
//
//  Created by Jerome Krakus on 22/05/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import XCTest
import Alamofire
import OHHTTPStubs
@testable import oc_reciplease

class RecipeServiceTest: XCTestCase {

    func testRecipeService() {
        // Stub for RecipeService path
        stub(condition: isPath("/v1/api/recipes")) { (_) -> OHHTTPStubsResponse in
            let stubData = FakeResponseData.recipeServiceCorrectData
            return OHHTTPStubsResponse(data: stubData!, statusCode: 200, headers: nil)
        }
        // Expectation
        let exp = expectation(description: "Alamofire request expectation")
        RecipeService.shared.getRecipes { (succes) in
            if succes {
                XCTAssertEqual(MatchingRecipes.shared.recipes.count, 10)
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testRecipeServiceWithIncorrectData() {
        // Stub for RecipeService path
        stub(condition: isPath("/v1/api/recipes")) { (_) -> OHHTTPStubsResponse in
            let stubData = FakeResponseData.incorrectData
            return OHHTTPStubsResponse(data: stubData!, statusCode: 200, headers: nil)
        }
        // Expectation
        let exp = expectation(description: "Alamofire request expectation")
        RecipeService.shared.getRecipes { (succes) in
            guard succes else {
                XCTAssertEqual(MatchingRecipes.shared.recipes.count, 0)
                exp.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testRecipeServiceWithNoData() {
        let notConnectedError = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue)
        // Stub for RecipeService path
        stub(condition: isPath("/v1/api/recipes")) { (_) -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(error: notConnectedError)
        }
        // Expectation
        let exp = expectation(description: "Alamofire request expectation")
        RecipeService.shared.getRecipes { (succes) in
            guard succes else {
                XCTAssertEqual(MatchingRecipes.shared.recipes.count, 0)
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
