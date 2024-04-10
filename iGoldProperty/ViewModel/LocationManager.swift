//
//  FirebaseUserManager.swift
//  iGoldProperty
//
//  Created by Mariem Derbali on 11/27/23.
//

import SwiftUI
import MapKit
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var userLocation: CLLocation?
    @Published var isAuthorized: Bool = false
    @Published var region: MKCoordinateRegion?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    func requestLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }

        switch status {
        case .notDetermined:
            isAuthorized = false
            return "notDetermined"
        case .authorizedWhenInUse, .authorizedAlways:
            isAuthorized = true
            return "authorized"
        case .restricted:
            isAuthorized = false
            return "restricted"
        case .denied:
            isAuthorized = false
            return "denied"
        default:
            return "unknown"
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        print(statusString)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location

        if region == nil {
            region = MKCoordinateRegion(
                center: userLocation!.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        }

        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("DEBUG: error while getting location")
    }
}

