//
//  iGoldPropertyApp.swift
//  iGoldProperty
//
//  Created by Mariem Derbali on 9/20/23.
//


import SwiftUI
import Firebase


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}


@main
struct iGoldPropertyApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var firebaseUserManager = FirebaseUserManager()
    
    @State private var showSplashScreen = true

    @StateObject private var firebaseRealEstateManager = FirebaseRealEstateManager()
    
    var body: some Scene {
        WindowGroup {
            if showSplashScreen {
                SplashScreenView()
                    .onAppear {
                       
                        Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
                            showSplashScreen = false
                        }
                    }
            } else {
                AuthView()
                    .environmentObject(firebaseUserManager)
                    .environmentObject(firebaseRealEstateManager)
            }
        }
    }
}
