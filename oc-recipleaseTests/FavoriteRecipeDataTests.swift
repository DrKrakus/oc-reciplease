//
//  FavoriteRecipeDataTests.swift
//  oc-recipleaseTests
//
//  Created by Jerome Krakus on 22/05/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import XCTest
import CoreData
@testable import oc_reciplease

class FavoriteRecipeDataTests: XCTestCase {

    // StorageManger
    var storageManager: StorageManager?

    // PersistentContainer for unit tests
    var mockPersistantContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Reciplease")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType

        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )

            // Check if creating container wrong
            if let error = error {
                fatalError("In memory coordinator creation failed \(error)")
            }
        }
        return container
    }()

    override func setUp() {
        super.setUp()
        storageManager = StorageManager(container: mockPersistantContainer)
    }

    fileprivate func createFavoriteRecipe(_ storageManager: StorageManager) {
        // Create favoriteRecipe object
        let favoriteRecipe = FavoriteRecipe(context: storageManager.persistentContainer.viewContext)
        favoriteRecipe.id = "id"
        favoriteRecipe.imageURL = "imgURL"
        favoriteRecipe.ingredientLines = ["ingredient 1", "ingredient 2"]
        favoriteRecipe.name = "name"
        favoriteRecipe.rating = 5
        favoriteRecipe.sourceRecipeURL = "sourceRecipeURL"
        favoriteRecipe.totalTime = "totalTime"

        // Try to save
        try? storageManager.persistentContainer.viewContext.save()
    }

    func testFetchAll() {
        // Check for storageManager
        guard let storageManager = storageManager else { return }

        // Check for count in favoriteRecipes before the insert
        var favoriteRecipes = storageManager.fetchAll()
        XCTAssertEqual(favoriteRecipes.count, 0)

        // Create favoriteRecipe
        createFavoriteRecipe(storageManager)

        // And check count in favoriteRecipes
        favoriteRecipes = storageManager.fetchAll()
        XCTAssertEqual(favoriteRecipes.count, 1)
    }

    override func tearDown() {
        // Check for storageManager
        guard let storageManager = storageManager else { return }
        // Check for favoriteRecipe object
        guard storageManager.fetchAll().count == 1 else { return }
        // Then Delete it
        storageManager.deleteRecipe(with: "id")
        try? storageManager.persistentContainer.viewContext.save()
    }
}
