//
//  iGoldPropertyIntegrationTests.swift
//  iGoldPropertyTests
//
//  Created by Mariem Derbali on 12/5/23.
//

import XCTest
import CoreLocation

@testable import iGoldProperty

class iGoldPropertyIntegrationTests: XCTestCase {

    var firebaseUserManager: FirebaseUserManager!
    var firebaseRealEstateManager: FirebaseRealEstateManager!

    override func setUp() {
        super.setUp()
        firebaseUserManager = FirebaseUserManager()
        firebaseRealEstateManager = FirebaseRealEstateManager()
    }

    override func tearDown() {
        firebaseUserManager = nil
        firebaseRealEstateManager = nil
        super.tearDown()
    }

    // TC_LoginAndAddRealEstate_001: Login and add real estate
    func testLoginAndAddRealEstate() throws {
        // Preconditions
        let loginExpectation = XCTestExpectation(description: "User login should be successful")
        let addRealEstateExpectation = XCTestExpectation(description: "Adding real estate should be successful")

        // Variables to capture user ID
        var loggedInUserId: String?

        // Test steps
        firebaseUserManager.logUserIn(
            email: "jake@example.com",
            password: "123456"
        ) { loginSuccess in
            XCTAssertTrue(loginSuccess, "User login should be successful")

            // After successful login, get the user ID
            loggedInUserId = self.firebaseUserManager.auth.currentUser?.uid

            loginExpectation.fulfill()

            // Check if user ID is obtained
            guard let userId = loggedInUserId else {
                XCTFail("Failed to obtain user ID after login")
                return
            }

            // Use the obtained user ID when creating real estate
            guard let image = UIImage(named: "apartment") else {
                XCTFail("Failed to load integration test image")
                return
            }

            let videoURL = URL(string: "https://www.youtube.com/watch?v=y9j-BL5ocW8")!

            let realEstate = RealEstate(
                ownerId: userId,
                images: ["apartment"],
                description: "Integration Test Real Estate Adding",
                equipment: [
                    Equipment(beds: 2, baths: 1, livingRooms: 1, space: 100, ovens: 1, fridges: 1, microwaves: 1, airConditions: 2, isSmart: true, hasWifi: true, hasPool: true, hasElevator: false, hasGym: false)
                ],
                age: 5,
                location: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                saleCategory: .rent,
                city: .benArous,
                type: .apartment,
                offer: .yearly,
                isAvailable: true,
                price: 4500,
                videoUrlString: "integrationTestVideoURL"
            )

            self.firebaseRealEstateManager.addRealEstate(
                realEstate: realEstate,
                images: [image],
                videoUrl: videoURL
            ) { addRealEstateSuccess in
                XCTAssertTrue(addRealEstateSuccess, "Adding real estate should be successful")
                addRealEstateExpectation.fulfill()
            }
        }

        wait(for: [loginExpectation, addRealEstateExpectation], timeout: 40.0)
    }
    

    //TC_LoginAndAddToFavorites002: Login and add real estate to favorites
    func testLoginAndAddToFavorites() throws {
        // Preconditions
        let loginExpectation = XCTestExpectation(description: "User login should be successful")
        let addToFavoritesExpectation = XCTestExpectation(description: "Adding to favorites should be successful")

        // Variables to capture user ID
        var loggedInUserId: String?

        // Test steps
        firebaseUserManager.logUserIn(
            email: "jake@example.com",
            password: "123456"
        ) { loginSuccess in
            XCTAssertTrue(loginSuccess, "User login should be successful")

            // After successful login, get the user ID
            loggedInUserId = self.firebaseUserManager.auth.currentUser?.uid

            loginExpectation.fulfill()

            // Check if user ID is obtained
            guard let userId = loggedInUserId else {
                XCTFail("Failed to obtain user ID after login")
                return
            }

            // Use the obtained user ID when creating real estate
            guard let image = UIImage(named: "apartment") else {
                XCTFail("Failed to load integration test image")
                return
            }

            let videoURL = URL(string: "https://www.youtube.com/watch?v=y9j-BL5ocW8")!

            let realEstate = RealEstate(
                id: "64042C34-03EC-4D64-822A-E91F695B99B7", // added real estate id
                ownerId: userId, // auth user id (jake)
                images: ["integrationTestImage"],
                description: "Integration Test Real Estate Favorites",
                equipment: [
                    Equipment(beds: 2, baths: 1, livingRooms: 1, space: 100, ovens: 1, fridges: 1, microwaves: 1, airConditions: 2, isSmart: true, hasWifi: true, hasPool: true, hasElevator: false, hasGym: false)
                ],
                age: 5,
                location: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                saleCategory: .rent,
                city: .benArous,
                type: .apartment,
                offer: .yearly,
                isAvailable: true,
                price: 4500,
                videoUrlString: "integrationTestVideoURL"
            )

            self.firebaseRealEstateManager.addRealEstate(
                realEstate: realEstate,
                images: [image],
                videoUrl: videoURL
            ) { addRealEstateSuccess in
                XCTAssertTrue(addRealEstateSuccess, "Adding real estate should be successful")

                // Now, add the real estate to favorites
                self.firebaseRealEstateManager.bookMarkRealEstate(realEstate: realEstate, userId: userId)
                           addToFavoritesExpectation.fulfill()
                
            }
        }

        wait(for: [loginExpectation, addToFavoritesExpectation], timeout: 40.0)
    }


}
