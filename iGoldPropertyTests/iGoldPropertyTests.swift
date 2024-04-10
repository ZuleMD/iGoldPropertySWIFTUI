//
//  iGoldPropertyTests.swift
//  iGoldPropertyTests
//
//  Created by Mariem Derbali on 12/1/23.
//

import XCTest
import CoreLocation

@testable import iGoldProperty

class iGoldPropertyTests: XCTestCase {

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

    // ******************* User Registration TESTS *******************
    
    // TC_Register_001
    func testRegisterWithValidCredentials() throws {
        // Preconditions
        let expectation = XCTestExpectation(description: "User registration should be successful")

        // Test steps
        firebaseUserManager.createNewUser(
            email: "jake@example.com",
            password: "123456",
            username: "jake",
            profileImage: UIImage(named: "person"),
            location: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        ) { success in
            // Expected result
            XCTAssertTrue(success, "User registration should be successful")
            expectation.fulfill()
        }


        wait(for: [expectation], timeout: 20.0)
    }
    
    // TC_Register_002
    func testRegisterWithoutPhoto() throws {
        // Preconditions
        let expectation = XCTestExpectation(description: "User registration should be successful without a photo")

        // Test steps
        firebaseUserManager.createNewUser(
            email: "jane@example.com",
            password: "123456",
            username: "jane",
            profileImage: nil, // No photo provided
            location: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        ) { success in
            // Expected result
            XCTAssertTrue(success, "User registration should be successful without a photo")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    // TC_Register_003
    func testRegisterWithoutUsername() throws {
        // Preconditions
        let expectation = XCTestExpectation(description: "User registration should fail without a username")

        // Test steps
        firebaseUserManager.createNewUser(
            email: "lucy@example.com",
            password: "123456",
            username: "", // Empty username
            profileImage: UIImage(named: "person"),
            location: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        ) { success in
            // Expected result
            XCTAssertFalse(success, "User registration should fail without a username")
            expectation.fulfill()
        }

    
        wait(for: [expectation], timeout: 10.0)
    }

    // TC_Register_004
    func testRegisterWithoutEmail() throws {
        // Preconditions
        let expectation = XCTestExpectation(description: "User registration should fail without an email")

        // Test steps
        firebaseUserManager.createNewUser(
            email: "", // Empty email
            password: "123456",
            username: "lucy",
            profileImage: UIImage(named: "person"),
            location: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        ) { success in
            // Expected result
            XCTAssertFalse(success, "User registration should fail without an email")
            expectation.fulfill()
        }

        
        wait(for: [expectation], timeout: 10.0)
        
        // Time for asynchronous completion
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1.0))
    }


    // TC_Register_005
    func testRegisterWithoutPassword() throws {
        // Preconditions
        let expectation = XCTestExpectation(description: "User registration should fail without a password")

        // Test steps
         firebaseUserManager.createNewUser(
            email: "lucy@example.com",
            password: "",
            username: "lucy",
            profileImage: UIImage(named: "person"),
            location: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        ) { success in
             XCTAssertFalse(success, "User registration should fail without a password")
            expectation.fulfill()
        }

        
        wait(for: [expectation], timeout: 10.0)
        
        // Time for asynchronous completion
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1.0))
    }
    
    
    
    // ******************* User Authentication TESTS *******************

    // TC_Login_001
    func testLoginWithValidCredentials() throws {
        // Preconditions
          let expectation = XCTestExpectation(description: "User login should be successful")

          // Test steps
          firebaseUserManager.logUserIn(
              email: "jake@example.com",
              password: "123456"
          ) { success in
              XCTAssertTrue(success, "User login should be successful")
              expectation.fulfill()
          }

          wait(for: [expectation], timeout: 10.0)

          // Time for asynchronous completion
          RunLoop.current.run(until: Date(timeIntervalSinceNow: 1.0))
      }
    
    
    // TC_Login_002
    func testLoginWithoutEmail() throws {
        // Preconditions
        let expectation = XCTestExpectation(description: "User login should fail without email")

        // Test steps
        firebaseUserManager.logUserIn(
            email: "",
            password: "123456"
        ) { success in
            XCTAssertFalse(success, "User login should fail without email")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)

      
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1.0))
    }

    
    // TC_Login_003
    func testLoginWithoutPassword() throws {
        // Preconditions
        let expectation = XCTestExpectation(description: "User login should fail without password")

        // Test steps
        firebaseUserManager.logUserIn(
            email: "jake@example.com",
            password: ""
        ) { success in
            XCTAssertFalse(success, "User login should fail without password")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)

        // Time for asynchronous completion
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1.0))
    }

    // TC_Login_004
    func testLoginWithWrongEmail() throws {
        // Preconditions
        let expectation = XCTestExpectation(description: "User login should fail with wrong email")

        // Test steps
        firebaseUserManager.logUserIn(
            email: "jakeee@example.com",
            password: "123456"
        ) { success in
            XCTAssertFalse(success, "User login should fail with wrong email")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)

        // Time for asynchronous completion
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1.0))
    }
    

    // TC_Login_005
    func testLoginWithWrongPassword() throws {
        // Preconditions
        let expectation = XCTestExpectation(description: "User login should fail with wrong password")

        // Test steps
        firebaseUserManager.logUserIn(
            email: "jake@example.com",
            password: "blablabla"
        ) { success in
            XCTAssertFalse(success, "User login should fail with wrong password")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)

        // Time for asynchronous completion
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1.0))
    }

    
    
    // ******************* User Profile Managment TESTS *******************

    
    // TC_Profile_001
    func testUpdateUsernameWithNewOne() throws {
        // Preconditions
        let expectation = XCTestExpectation(description: "Username should be updated successfully")

        // Test steps
        let documentID = "DPCvteeSriVPvVB9JqgCo7HviWJ2" //jake document id
        self.firebaseUserManager.updateUserName(username: "jake reyes", documentID: documentID) { success in
            XCTAssertTrue(success, "Username should be updated successfully")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }


    // TC_Profile_002
    func testUpdateUsernameWithEmptyOne() throws {
        // Preconditions
        let expectation = XCTestExpectation(description: "Failed to update profile")

        // Test steps
        let documentID = "DPCvteeSriVPvVB9JqgCo7HviWJ2" //jake document id
        self.firebaseUserManager.updateUserName(username: "", documentID: documentID) { success in
            XCTAssertFalse(success, "Failed to update profile")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }
    
    // TC_Profile_003
    func testUpdateUsernameWithSpaces() throws {
        // Preconditions
        let expectation = XCTestExpectation(description: "Failed to update profile")

        // Test steps
        let documentID = "DPCvteeSriVPvVB9JqgCo7HviWJ2" //jake document id
        self.firebaseUserManager.updateUserName(username: " jake reyes", documentID: documentID) { success in
            XCTAssertFalse(success, "Failed to update profile")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }
    
    
    // TC_Profile_004
    func testUpdateUsernameWithSpecialCharacters() throws {
        // Preconditions
        let expectation = XCTestExpectation(description: "Failed to update profile")

        // Test steps
        let documentID = "DPCvteeSriVPvVB9JqgCo7HviWJ2" //jake document id
        self.firebaseUserManager.updateUserName(username: "?jake reyes", documentID: documentID) { success in
            XCTAssertFalse(success, "Failed to update profile")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }
    
    // TC_Profile_005
    func testUpdateUsernameWithNumber() throws {
        // Preconditions
        let expectation = XCTestExpectation(description: "Failed to update profile")

        // Test steps
        let documentID = "DPCvteeSriVPvVB9JqgCo7HviWJ2" //jake document id
        self.firebaseUserManager.updateUserName(username: "jake reyes99", documentID: documentID) { success in
            XCTAssertFalse(success, "Failed to update profile")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }


    // ******************* User Session Management TESTS *******************

    // TC_Logout_001
    func testLogout() throws {
        // Preconditions: Log in a user before attempting to log out
        let loginExpectation = XCTestExpectation(description: "User login should be successful")

        // Log in the user
        firebaseUserManager.logUserIn(
            email: "jake@gmail.com",
            password: "123456"
        ) { loginSuccess in
            XCTAssertTrue(loginSuccess, "User login should be successful")
            loginExpectation.fulfill()
        }

        wait(for: [loginExpectation], timeout: 10.0)

        
        XCTAssertTrue(firebaseUserManager.isAuthenticated, "User should be authenticated after login")

        // Logout
        let logoutExpectation = XCTestExpectation(description: "User logout should be successful")

        firebaseUserManager.logOut { logoutSuccess in
            XCTAssertTrue(logoutSuccess, "User logout should be successful")
            logoutExpectation.fulfill()
        }

        wait(for: [logoutExpectation], timeout: 10.0)

        XCTAssertFalse(firebaseUserManager.isAuthenticated, "User should be logged out")
    }

  
    // ******************* Real Estate Management TESTS *******************
 
    // TC_RealEstate_001
        func testAddRealEstateWithAllData() throws {
            // Preconditions
            let expectation = XCTestExpectation(description: "Adding real estate with all data should be successful")

            // Test steps
            guard let image1 = UIImage(named: "apartment"),
                 let image2 = UIImage(named: "apartment") else {
               XCTFail("Failed to load one or more images")
               return
            }
            
            let videoURL = URL(string: "https://www.youtube.com/watch?v=y9j-BL5ocW8")!

            let realEstate = RealEstate(
                ownerId: "ivAHEdLAP2gq13qwaw8kVy1V12r2", //jake id
                images: ["apartment", "apartment"],
                description: "Blablabla",
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
                price: 500,
                videoUrlString: "your_video_url_here"
            )

            firebaseRealEstateManager.addRealEstate(
                realEstate: realEstate,
                images: [image1, image2],
                videoUrl: videoURL
            ) { success in
                // Expected result
                XCTAssertTrue(success, "Adding real estate with all data should be successful")
                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 180.0)
        }

    // TC_RealEstate_002
    func testAddRealEstateWithoutPhoto() throws {
        // Preconditions
        let expectation = XCTestExpectation(description: "Adding real estate without a photo should be successful")

        // Test steps
        let videoURL = URL(string: "https://www.youtube.com/watch?v=y9j-BL5ocW8")!

        let realEstate = RealEstate(
            id: UUID().uuidString,
            ownerId: "ivAHEdLAP2gq13qwaw8kVy1V12r2", //jake id
            images: [],
            description: "Blablabla",
            equipment: [
                Equipment(beds: 4, baths: 1, livingRooms: 5, space: 100, ovens: 1, fridges: 1, microwaves: 1, airConditions: 2, isSmart: true, hasWifi: true, hasPool: true, hasElevator: false, hasGym: false)
             ],
            age: 7,
            location: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            saleCategory: .sale,
            city: .monastir,
            type: .house,
            offer: .yearly,
            isAvailable: true,
            price: 300000,
            videoUrlString: "your_video_url_here"

        )

        firebaseRealEstateManager.addRealEstate(
            realEstate: realEstate,
            images: [],
            videoUrl: videoURL
        ) { success in
            // Expected result
            XCTAssertTrue(success, "Adding real estate without a photo should be successful")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 150.0)
    }

     // TC_RealEstate_003
    func testAddRealEstateWithoutVideo() throws {
        
        // Preconditions
        let expectation = XCTestExpectation(description: "Adding real estate without a video should be successful")

        // Test steps

        guard let image1 = UIImage(named: "apartment"),
                 let image2 = UIImage(named: "apartment") else {
               XCTFail("Failed to load one or more images")
               return
           }

        let realEstate = RealEstate(
              ownerId: "ivAHEdLAP2gq13qwaw8kVy1V12r2", //jake id
            images: ["apatment", "apatment"],
            description: "Blablabla",
            equipment: [
                Equipment(beds: 4, baths: 1, livingRooms: 5, space: 100, ovens: 1, fridges: 1, microwaves: 1, airConditions: 2, isSmart: true, hasWifi: true, hasPool: true, hasElevator: false, hasGym: false)
             ],
            age: 5,
            location: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            saleCategory: .rent,
            city: .sfax,
            type: .house,
            offer: .yearly,
            isAvailable: true,
            price: 600000,
            videoUrlString: ""
        )

        firebaseRealEstateManager.addRealEstate(
            realEstate: realEstate,
            images: [image1, image2],
            videoUrl: nil
        ) { success in
            // Expected result
            XCTAssertTrue(success, "Adding real estate without a video should be successful")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 300.0)

    }

    // TC_RealEstate_004
    func testDeleteRealEstate() throws {
        // Preconditions
        let expectation = XCTestExpectation(description: "Deleting real estate should be successful")

        // Test steps
        let realEstateToDelete = RealEstate(
            id: "374FB90A-467F-444A-91BF-184EADE3CF5A", //added real estate id
            ownerId: "ivAHEdLAP2gq13qwaw8kVy1V12r2", // jake id
            images: ["apatment", "apatment"],
            description: "Blablabla",
            equipment: [
                Equipment(beds: 4, baths: 1, livingRooms: 5, space: 100, ovens: 1, fridges: 1, microwaves: 1, airConditions: 2, isSmart: true, hasWifi: true, hasPool: true, hasElevator: false, hasGym: false)
             ],
            age: 5,
            location: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            saleCategory: .rent,
            city: .sfax,
            type: .house,
            offer: .yearly,
            isAvailable: true,
            price: 600000,
            videoUrlString: ""
        )

        firebaseRealEstateManager.deleteRealEstate(realEstate: realEstateToDelete)

       
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            // Fulfill the expectation after waiting
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    // TC_RealEstate_005
    func testMarkRealEstateAsUnavailable() throws {
        // Preconditions
        let expectation = XCTestExpectation(description: "Marking real estate as unavailable should be successful")

        // Test steps
        var realEstateToMark = RealEstate(
            id: "0FD98040-9F53-4234-9743-373729E64B12", //added reak estate id
            ownerId: "ivAHEdLAP2gq13qwaw8kVy1V12r2", // jake id
            images: [],
            description: "Blablabla",
            equipment: [
                Equipment(beds: 4, baths: 1, livingRooms: 5, space: 100, ovens: 1, fridges: 1, microwaves: 1, airConditions: 2, isSmart: true, hasWifi: true, hasPool: true, hasElevator: false, hasGym: false)
             ],
            age: 7,
            location: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            saleCategory: .sale,
            city: .monastir,
            type: .house,
            offer: .yearly,
            isAvailable: true,
            price: 300000,
            videoUrlString: "your_video_url_here"
        )

    
        firebaseRealEstateManager.markRealEstateAs(realEstate: &realEstateToMark)

         
        XCTAssertFalse(realEstateToMark.isAvailable, "isAvailable should be set to false after marking as unavailable")
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            // Fulfill the expectation after waiting
            expectation.fulfill()
        }
 
        wait(for: [expectation], timeout: 10.0)
    }

    // TC_RealEstate_006
    func testMarkRealEstateAsAvailable() throws {
        // Preconditions
        let expectation = XCTestExpectation(description: "Marking real estate as available should be successful")

        // Test steps
        let realEstateToMark = RealEstate(
            id: "0FD98040-9F53-4234-9743-373729E64B12",  //added reak estate id
            ownerId: "ivAHEdLAP2gq13qwaw8kVy1V12r2",  // jake id
            images: [],
            description: "Blablabla",
            equipment: [
                Equipment(beds: 4, baths: 1, livingRooms: 5, space: 100, ovens: 1, fridges: 1, microwaves: 1, airConditions: 2, isSmart: true, hasWifi: true, hasPool: true, hasElevator: false, hasGym: false)
             ],
            age: 7,
            location: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            saleCategory: .sale,
            city: .monastir,
            type: .house,
            offer: .yearly,
            isAvailable: true,
            price: 300000,
            videoUrlString: "your_video_url_here"
        )

    
        firebaseRealEstateManager.reAddRealEstate(realEstate: realEstateToMark)

         
        XCTAssertTrue(realEstateToMark.isAvailable, "isAvailable should be set to true after marking as available")
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            // Fulfill the expectation after waiting
            expectation.fulfill()
        }
 
        wait(for: [expectation], timeout: 30.0)
    }
   
    
    // ******************* Favorites Real Estates Management TESTS *******************

    // TC_RealEstateFavorites_001
    func testBookMarkRealEstate() throws {
        // Preconditions
        let expectation = XCTestExpectation(description: "Bookmarking real estate should be successful")

        // Test steps
        let realEstateToBookmark = RealEstate(
            id: "0FD98040-9F53-4234-9743-373729E64B12",  //added reak estate id
            ownerId: "ivAHEdLAP2gq13qwaw8kVy1V12r2",  // jake id
            images: [],
            description: "Blablabla",
            equipment: [
                Equipment(beds: 4, baths: 1, livingRooms: 5, space: 100, ovens: 1, fridges: 1, microwaves: 1, airConditions: 2, isSmart: true, hasWifi: true, hasPool: true, hasElevator: false, hasGym: false)
             ],
            age: 7,
            location: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            saleCategory: .sale,
            city: .monastir,
            type: .house,
            offer: .yearly,
            isAvailable: true,
            price: 300000,
            videoUrlString: "your_video_url_here"
            )
        
         
        firebaseRealEstateManager.bookMarkRealEstate(realEstate: realEstateToBookmark, userId: "ivAHEdLAP2gq13qwaw8kVy1V12r2")
           DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
           

               expectation.fulfill()
           }



        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 30.0)
    }

    
    
    // TC_RealEstateFavorites_002
    func testRemovingBookMarkRealEstate() throws {
        // Preconditions
        let expectation = XCTestExpectation(description: "Bookmarking real estate should be successful")

        // Test steps
        let realEstateToBookmark = RealEstate(
            id: "0FD98040-9F53-4234-9743-373729E64B12", //added reak estate id
            ownerId: "ivAHEdLAP2gq13qwaw8kVy1V12r2", // jake id
            images: [],
            description: "Blablabla",
            equipment: [
                Equipment(beds: 4, baths: 1, livingRooms: 5, space: 100, ovens: 1, fridges: 1, microwaves: 1, airConditions: 2, isSmart: true, hasWifi: true, hasPool: true, hasElevator: false, hasGym: false)
             ],
            age: 7,
            location: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            saleCategory: .sale,
            city: .monastir,
            type: .house,
            offer: .yearly,
            isAvailable: true,
            price: 300000,
            videoUrlString: "your_video_url_here"
            )
        
         
        firebaseRealEstateManager.removeRealEstateFromBookMarks(realEstate: realEstateToBookmark)
           DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
   
               expectation.fulfill()
           }



        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 30.0)
    }


    

}

    

    

