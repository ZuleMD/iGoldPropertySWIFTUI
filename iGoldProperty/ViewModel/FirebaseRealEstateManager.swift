//
//  FirebaseRealEstateManager.swift
//  iGoldProperty
//
//  Created by Mariem Derbali on 12/13/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage
import CoreLocation

class FirebaseRealEstateManager: NSObject, ObservableObject {
    
    @Published var realEstates : [RealEstate] = []
    @Published var realEstatesReset : [RealEstate] = []
    @Published var myRealEstates: [RealEstate] = []
    @Published var bookmarkedRealEstates: [RealEstate] = []
 
    
    let auth: Auth
    let firestore: Firestore
    let storage: Storage
    
    override init() {
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
        self.storage = Storage.storage()
        super.init()
        setupListeners()
        
    }
    
    private func setupListeners() {
            // Fetch real estates when the app starts or when the user logs in
            fetchRealEstates()
            fetchMyRealEstates()
        fetchMyBookMarkedRealEstates()
        }
    
    
    func deleteRealEstate(realEstate: RealEstate) {
        // Remove the real estate from the user's subcollection
         firestore.collection("users").document(realEstate.ownerId).collection("realEstates").document(realEstate.id).delete { error in
            if let error = error {
                print("DEBUG: Error deleting real estate from user's subcollection \(error)")
                return
            }

            self.firestore.collection("users").document(realEstate.ownerId).collection("bookmarks").document(realEstate.id).delete()

            // Remove the real estate from the "realEstates" collection
            self.firestore.collection("realEstates").document(realEstate.id).delete { error in
                if let error = error {
                    print("DEBUG: Error deleting real estate from realEstates collection \(error)")
                    return
                }

                // Optionally, you can also update the local array of myRealEstates
                if let index = self.myRealEstates.firstIndex(where: { $0.id == realEstate.id }) {
                   self.myRealEstates.remove(at: index)
                }
            }
        }
    }

    
    func fetchMyBookMarkedRealEstates(){
        guard let userId = auth.currentUser?.uid else {return}
        try? firestore.collection("users").document(userId).collection("bookmarks").addSnapshotListener { querySnapshot, error in
            guard let bookmarkedRealEstates = querySnapshot?.documents.compactMap({try? $0.data(as: RealEstate.self)}) else {return}
            self.bookmarkedRealEstates = bookmarkedRealEstates
        }
    }
    
    
    func markRealEstateAs(realEstate: inout RealEstate) {
        // Set isAvailable to false
        realEstate.isAvailable = false
        
        // Update the real estate document in the users' subcollection
        try? firestore.collection("users")
            .document(realEstate.ownerId)
            .collection("realEstates")
            .document(realEstate.id)
            .setData(from: realEstate)
        
        // Delete the real estate document from the "realEstates" collection
        firestore.collection("realEstates")
            .document(realEstate.id)
            .delete()
    }


    
 
    func reAddRealEstate(realEstate: RealEstate) {
        let userRef = firestore.collection("users").document(realEstate.ownerId)
        let realEstateRef = firestore.collection("realEstates").document(realEstate.id)

      try? userRef.collection("realEstates").document(realEstate.id).setData(from: realEstate) { error in
            if let error = error {
                print("DEBUG: Error while setting data in user's subcollection \(error)")
                return
            }

          try?  realEstateRef.setData(from: realEstate) { error in
                if let error = error {
                    print("DEBUG: Error while setting data in realEstates collection \(error)")
                    // Handle the error, maybe undo the set data in the user's subcollection
                }
            }
        }
    }

    
    
    func fetchRealEstates() {
        print("DEBUG: Fetching real estates...")

        firestore.collection("realEstates").getDocuments { [weak self] querySnapshot, error in
            guard let self = self, let querySnapshot = querySnapshot else {
                return
            }

            if let error = error {
                print("DEBUG: Error while fetching all real estate \(error)")
                return
            }

            let realEstates = querySnapshot.documents.compactMap { try? $0.data(as: RealEstate.self) }

            print("DEBUG: Real estates \(realEstates.map { $0.id })")
            self.realEstates = realEstates

            // Attach .addSnapshotListener for real-time updates
            self.firestore.collection("realEstates").addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self, let querySnapshot = querySnapshot else {
                    return
                }

                if let error = error {
                    print("DEBUG: Error in .addSnapshotListener \(error)")
                    return
                }

                let updatedRealEstates = querySnapshot.documents.compactMap { try? $0.data(as: RealEstate.self) }

                print("DEBUG: Updated real estates \(updatedRealEstates.map { $0.id })")
                self.realEstates = updatedRealEstates
                self.realEstatesReset = updatedRealEstates
                

            }
        }
    }

 
    func bookMarkRealEstate(realEstate: RealEstate, userId: String){
       try? firestore.collection("users").document(userId).collection("bookmarks").document(realEstate.id).setData(from: realEstate)
        
        DispatchQueue.main.async {
               self.bookmarkedRealEstates.append(realEstate)
           }
    }
    
    func removeRealEstateFromBookMarks(realEstate: RealEstate){
         try? firestore.collection("users").document(realEstate.ownerId).collection("bookmarks").document(realEstate.id).delete()
        
         DispatchQueue.main.async {
            if let index = self.bookmarkedRealEstates.firstIndex(of: realEstate) {
                self.bookmarkedRealEstates.remove(at: index)
            }
        }
    }
    
    func fetchOwnerDetail(userId: String, completion: @escaping( (User) -> () )){
        firestore.collection("users").document(userId).addSnapshotListener { documentSnapshot, error in
            if let error = error {
                print("DEBUG: error while getting user info \(error)")
                return
                
            }
            
            guard let userOwner = try? documentSnapshot?.data(as: User.self) else {return}
            
            completion(userOwner)
        }
    }

    func fetchMyRealEstates() {
        guard let userId = auth.currentUser?.uid else {return}
        firestore.collection("users").document(userId).collection("realEstates").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("DEBUG: error while getting my Real Estates \(error)")
                return
                
            }
            guard let myRealEstates = querySnapshot?.documents.compactMap({try? $0.data(as: RealEstate.self)}) else {return}
            
            DispatchQueue.main.async {
                        self.myRealEstates = myRealEstates.sorted{ $0.isAvailable && !$1.isAvailable }
                    }
            
            
        }
    }
        
    
    func addRealEstate(realEstate: RealEstate, images: [UIImage], videoUrl: URL?, completion: @escaping((Bool) -> ())) {
        var updatedRealEstate = realEstate // Create a mutable copy

        if let videoUrl = videoUrl {
            // Video is provided
            uploadVideoToStorage(videoUrl: videoUrl) { videoUrlString in
                updatedRealEstate.videoUrlString = videoUrlString
                self.handleImagesAndFirestore(realEstate: updatedRealEstate, images: images, completion: completion)
            }
        } else if !images.isEmpty {
            // Only images are provided
            self.handleImagesAndFirestore(realEstate: updatedRealEstate, images: images, completion: completion)
        } else {
            // Neither images nor video are provided
            self.updateRealEstatesCollection(updatedRealEstate) { success in
                if success {
                    self.updateUserSubcollection(updatedRealEstate, completion: completion)
                } else {
                    completion(false)
                }
            }
        }
    }

    
    private func updateRealEstatesCollection(_ realEstate: RealEstate, completion: @escaping (Bool) -> ()) {
        try? self.firestore.collection("realEstates").document(realEstate.id).setData(from: realEstate) { error in
            if let error = error {
                print("Error adding document to Firestore (realEstates): \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }

    private func updateUserSubcollection(_ realEstate: RealEstate, completion: @escaping (Bool) -> ()) {
        try? self.firestore.collection("users").document(realEstate.ownerId).collection("realEstates").document(realEstate.id).setData(from: realEstate) { error in
            if let error = error {
                print("Error adding document to user's subcollection: \(error)")
                completion(false)
            } else {
                print("DEBUG: - all uploads are complete")
                completion(true)
            }
        }
    }


    
    private func handleImagesAndFirestore(realEstate: RealEstate, images: [UIImage], completion: @escaping((Bool) -> ())) {
        // Handle the case where images are provided
        self.uploadImagesToStorage(images: images) { imageUrlStrings in
            var updatedRealEstate = realEstate // Create another mutable copy
            updatedRealEstate.images = imageUrlStrings

            // Update the "realEstates" collection
            self.updateRealEstatesCollection(updatedRealEstate) { success in
                if success {
                    // Update the user's subcollection after successfully updating "realEstates" collection
                    self.updateUserSubcollection(updatedRealEstate, completion: completion)
                } else {
                    completion(false)
                }
            }
        }
    }

    
    func uploadImagesToStorage(images: [UIImage], onCompletion: @escaping ([String]) -> ()) {
        guard let userId = auth.currentUser?.uid else {
            print("DEBUG: User ID is nil.")
            onCompletion([])
            return
        }

        var uploadedImageURLs: [String] = []

        // Use a DispatchGroup to wait for all uploads to complete
        let dispatchGroup = DispatchGroup()

        print("DEBUG: - entering uploadImagesToStorage func")

        for (index, image) in images.enumerated() {
            dispatchGroup.enter()
            print("DEBUG: - entering photo loop")

            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                print("DEBUG: - failed to convert image to data")
                dispatchGroup.leave()
                continue
            }

            let imageName = UUID().uuidString
            let storageRef = storage.reference(withPath: "\(userId)/\(imageName).jpg")

            storageRef.putData(imageData, metadata: nil) { (_, error) in
                if let error = error {
                    print("DEBUG: - failed to upload photo \(index + 1) - \(error)")
                } else {
                    print("DEBUG: - successfully uploading photo \(index + 1)")
                    storageRef.downloadURL { (url, _) in
                        if let downloadURL = url?.absoluteString {
                            print("DEBUG: - successfully downloading photo URL \(index + 1)")
                            uploadedImageURLs.append(downloadURL)
                        } else {
                            print("DEBUG: - failed to get download URL for photo \(index + 1)")
                        }
                        dispatchGroup.leave()
                    }
                }
            }
        }

        // Notify when all uploads are complete
        dispatchGroup.notify(queue: .main) {
            print("DEBUG: - all uploads are complete")
            onCompletion(uploadedImageURLs)
        }
    }

    
    func uploadVideoToStorage(videoUrl: URL, onCompletion: @escaping (String) -> ()) {
        print("DEBUG: 2 - entering uploadVideoToStorage func ")
 
        guard let userId = auth.currentUser?.uid else { return }

        do {
            let videoData = try Data(contentsOf: videoUrl)
            print("DEBUG: 3 - entering uploadVideoToStorage func ")
            let videoFileName: String = UUID().uuidString
            let refStorage = storage.reference(withPath: "\(userId)/\(videoFileName)/\(videoUrl.lastPathComponent)")

            print("DEBUG: 4 - success uploading video to storage ")
            refStorage.putData(videoData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("DEBUG: error while uploading video \(error)")
                    return
                }

                refStorage.downloadURL { (videoUrl, error) in
                    if let error = error {
                        print("DEBUG: error while getting download URL \(error)")
                        return
                    }
                    print("DEBUG 5: - success downloading video from storage ")
                    guard let videoUrl = videoUrl?.absoluteString else { return }
                    onCompletion(videoUrl)
                }
            }
        } catch {
            print("DEBUG: failed upload video function \(error)")
        }
    }

    
}
