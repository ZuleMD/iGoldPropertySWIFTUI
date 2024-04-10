//
//  AddRealEstateViewModel.swift
//  iGoldProperty
//
//  Created by Mariem Derbali on 12/3/23.
//

import Foundation
import SwiftUI
import MapKit

class AddRealEstateViewModel : ObservableObject {
    @Published var realEstate = RealEstate()
    @Published var images : [UIImage] = []
    @Published var videoUrl: URL?
    @Published var refreshMapViewId = UUID()
    @Published var coordinateRegion: MKCoordinateRegion = .init(center: .init(latitude:0.0 , longitude:0.0 ), span: .init(latitudeDelta: 0.0, longitudeDelta: 0.0))
    
}
