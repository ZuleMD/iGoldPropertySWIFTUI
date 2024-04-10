//
//  FirebaseUserManager.swift
//  iGoldProperty
//
//  Created by Mariem Derbali on 10/30/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage
import CoreLocation

class FirebaseUserManager: NSObject, ObservableObject {
    
    @Published var user: User = .init()
    @Published var isAuthenticated: Bool = false

    
    let auth: Auth
    let firestore: Firestore
    let storage: Storage
    
    override init() {
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
        self.storage = Storage.storage()
        super.init()
        
    }
    
    func fetchUser(){
        guard let userId = auth.currentUser?.uid else {return}
        firestore.collection("users").document(userId).getDocument { documentSnapshot, error in
            if let error = error {
                print("DEBUG: error while fetching user info \(error.localizedDescription)")
                return
            }
            guard let user = try? documentSnapshot?.data(as: User.self) else {return}
            self.user = user
        }
    }
    
    func updateUserName(username: String, documentID: String, completion: @escaping (Bool) -> ()) {
        let firstCharacter = username.prefix(1)
        let alphanumericCharacterSet = CharacterSet.alphanumerics
        
        if firstCharacter == " " || firstCharacter.rangeOfCharacter(from: alphanumericCharacterSet) == nil{
              completion(false)
              return
          }
        
        let updatedData: [String: Any] = [
            "username": username
        ]

        self.firestore.collection("users").document(documentID).setData(updatedData, merge: true) { error in
            if let error = error {
                print("DEBUG: error while updating username")
                completion(false)
            } else {
                completion(true)
            }
        }
    }


    
    func updatePhoneNumber(phoneNumber : String, completion: @escaping ( (Bool) -> () ) ){
        self.user.phoneNumber = phoneNumber
 
        try? self.firestore.collection("users").document(self.user.id).setData(from: user, merge: true)
        
        { error in
        if let error = error{
            print("DEBUG: error while uodating phone number")
            completion(false)
        }
        completion(true)
    }
    }
    
    func updateDayTimeAvailability(){
        try? self.firestore.collection("users").document(self.user.id).setData(from: user, merge: true)
      

    }
    
    func updateProfileImage(image: UIImage, completion: @escaping (Bool) -> ()) {
            guard let userId = auth.currentUser?.uid else {
                completion(false)
                return
            }
            
            let profileImageId = UUID().uuidString
            guard let imageData = image.jpegData(compressionQuality: 0.5) else {
                completion(false)
                return
            }
            
            let ref = storage.reference(withPath: userId + "/" + profileImageId)
            ref.putData(imageData, metadata: nil) { _, error in
                if let error = error {
                    print("DEBUG: Error while uploading profile image: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                ref.downloadURL { imageUrl, error in
                    if let error = error {
                        print("DEBUG: Error while downloading imageUrl: \(error.localizedDescription)")
                        completion(false)
                        return
                    }
                    
                    guard let profileImageUrlString = imageUrl?.absoluteString else {
                        completion(false)
                        return
                    }
                    
                    self.user.profileImageUrl = profileImageUrlString
                    try? self.firestore.collection("users").document(userId).setData(from: self.user, merge: true) { error in
                        if let error = error {
                            print("DEBUG: Error while updating profile image URL: \(error.localizedDescription)")
                            completion(false)
                            return
                        }
                        
                        completion(true)
                    }
                }
            }
        }
    
    func logOut(completion: @escaping ( (Bool) -> () )){
        do{
            try? auth.signOut()
            self.user = .init()
            self.isAuthenticated = false
            completion(true)
        } catch {
            print("\(error)")
            completion(false)
        }
    }
    
    func logUserIn(email: String, password: String, completion: @escaping (Bool) -> ()) {
        auth.signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                print("DEBUG: Error while logging user in: \(error.localizedDescription)")
                completion(false)
            } else {
                // Login successful
                self.fetchUser()
                self.isAuthenticated = true
                completion(true)
            }
            
        }
    }

    
    func createNewUser(email: String, password: String, username: String, profileImage: UIImage?, location: CLLocationCoordinate2D, completion: @escaping (Bool) -> ()) {
        
        print("DEBUG: Checking for empty username...")
            guard !username.isEmpty else {
                print("DEBUG: Empty username found, returning false")
                completion(false)
                return
            }
        auth.createUser(withEmail: email, password: password) { authResult , error in
            if let error = error {
                print("DEBUG: error while creating account \(error.localizedDescription)")
                completion(false)
            } else {
                guard let userId = authResult?.user.uid else { return }

                // Check if profileImage is nil
                if let profileImage = profileImage {
                    self.UpdateProfileImageToStorage(userId: userId, profileImage: profileImage) { profileImageUrlString in
                        let user = User(id: userId, profileImageUrl: profileImageUrlString,
                                        favoriteRealEstate: [], realEstates: [],
                                        phoneNumber: "", email: email, username: username,
                                        isVerified: false,
                                        dayTimeAvailability:[
                                            .init(day: .monday, fromTime: Date(), toTime: Date()),
                                            .init(day: .tuesday, fromTime: Date(), toTime: Date()),
                                            .init(day: .wednesday, fromTime: Date(), toTime: Date()),
                                            .init(day: .thursday, fromTime: Date(), toTime: Date()),
                                            .init(day: .friday, fromTime: Date(), toTime: Date()),
                                            .init(day: .saturday, fromTime: Date(), toTime: Date()),
                                            .init(day: .sunday, fromTime: Date(), toTime: Date())
                                        ],
                                        location: location)
                        
                        try? self.firestore.collection("users").document(userId).setData(from:user )
                        self.fetchUser()
                        self.isAuthenticated = true
                        completion(true)
                    }
                } else {
                    // Set profile image URL to empty string
                    let user = User(id: userId, profileImageUrl: "",
                                    favoriteRealEstate: [], realEstates: [],
                                    phoneNumber: "", email: email, username: username,
                                    isVerified: false,
                                    dayTimeAvailability:[
                                        .init(day: .monday, fromTime: Date(), toTime: Date()),
                                        .init(day: .tuesday, fromTime: Date(), toTime: Date()),
                                        .init(day: .wednesday, fromTime: Date(), toTime: Date()),
                                        .init(day: .thursday, fromTime: Date(), toTime: Date()),
                                        .init(day: .friday, fromTime: Date(), toTime: Date()),
                                        .init(day: .saturday, fromTime: Date(), toTime: Date()),
                                        .init(day: .sunday, fromTime: Date(), toTime: Date())
                                    ],
                                    location: location)
                    
                    try? self.firestore.collection("users").document(userId).setData(from:user )
                    self.fetchUser()
                    self.isAuthenticated = true
                    completion(true)
                }
            }
        }
    }



    
    func UpdateProfileImageToStorage(userId: String, profileImage: UIImage?, completion: @escaping ( (String) -> () )){
        
        let profileImageId = UUID().uuidString
        
        if let profileImage = profileImage  {
            guard let imageData = profileImage.jpegData(compressionQuality: 0.5 ) else {return}
            let ref = storage.reference(withPath: userId + "/" + profileImageId)
            ref.putData(imageData, metadata: nil) { StorageMetadata, error in
                if let error = error {
                    print("DEBUG: error while uploading profile image \(error.localizedDescription)")
                    return
                }
                ref.downloadURL { imageUrl, error in
                    if let error = error {
                        print("DEBUG: error while downloading imageUrl \(error.localizedDescription)")
                        return
                    }
                    guard let profileImageUrlString = imageUrl?.absoluteString else {return}
                    completion(profileImageUrlString)
                }
                
            }
        }
    }
        
    
}
