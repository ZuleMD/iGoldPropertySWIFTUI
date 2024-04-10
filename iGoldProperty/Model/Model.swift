//
//  Model.swift
//  iGoldProperty
//
//  Created by Mariem Derbali on 10/18/23.
//

import Foundation
import CoreLocation
import SwiftUI
import MapKit


enum SaleCategory: String, CaseIterable, Codable{
    case sale
    case rent
    case investment
    
    var title: String {
        switch self {
        case .sale:       return "Sale"
        case .rent:       return "Rent"
        case .investment: return "Investment"
        }
    }
    
    var saleColor: Color{
        switch self {
        case .sale:       return .green
        case .rent:       return .orange
        case .investment: return .blue
        }
    }
    
    var markedTitle: String{
        switch self {
        case .sale:       return "SOLD"
        case .rent:       return "RENTED"
        case .investment: return "INVESTED"
        }
    }
    
    var imageName: String {
        switch self{
        case .sale:       return "sale"
        case .rent:       return "rent"
        case .investment: return "investment"
        }
    }
}

enum RealEstateType: String, CaseIterable , Codable {
    case apartment
    case house
    case townHouse
    case farm
    case land
    case building
    case office
    case room
    case penthouse
    case floor
    case camp
    case chalet
    
    var title: String {
        switch self{
        case .apartment:  return "Apartment"
        case .house:      return "House"
        case .townHouse:  return "Town House"
        case .farm:       return "Farm"
        case .land:       return "Land"
        case .building:   return "Building"
        case .office:     return "Office"
        case .room:       return "Room"
        case .penthouse:  return "Penthouse"
        case .floor:      return "Floor"
        case .camp:       return "Camp"
        case .chalet:     return "Chalet"
            
        }
    }
    
    var imageName: String {
        switch self{
        case .apartment: return "apartment"
        case .house: return "house"
        case .townHouse: return "townHouse"
        case .farm: return "farm"
        case .land: return "land"
        case .building: return "building"
        case .office: return "office"
        case .room: return "room"
        case .penthouse: return "penthouse"
        case .floor: return "floor"
        case .camp: return "camp"
        case .chalet: return "chalet"
            
        }
    }
}

enum OfferType: String, CaseIterable, Codable {
    case daily
    case monthly
    case yearly
    
    var title: String{
        switch self {
        case .daily:   return "Daily"
        case .monthly: return "Monthly"
        case .yearly:  return "Yearly"
        }
    }
}

enum City: String, CaseIterable, Codable {
    case ariana
    case beja
    case benArous
    case bizerte
    case gabes
    case gafsa
    case jendouba
    case kairouan
    case kasserine
    case kebili
    case kef
    case mahdia
    case manouba
    case medenine
    case monastir
    case nabeul
    case sfax
    case sidiBouzid
    case siliana
    case sousse
    case tozeur
    case tunis
    case zaghouan

    var title: String {
        switch self {
        case .ariana: return "Ariana"
        case .beja: return "Beja"
        case .benArous: return "Ben Arous"
        case .bizerte: return "Bizerte"
        case .gabes: return "Gabes"
        case .gafsa: return "Gafsa"
        case .jendouba: return "Jendouba"
        case .kairouan: return "Kairouan"
        case .kasserine: return "Kasserine"
        case .kebili: return "Kebili"
        case .kef: return "Kef"
        case .mahdia: return "Mahdia"
        case .manouba: return "Manouba"
        case .medenine: return "Medenine"
        case .monastir: return "Monastir"
        case .nabeul: return "Nabeul"
        case .sfax: return "Sfax"
        case .sidiBouzid: return "Sidi Bouzid"
        case .siliana: return "Siliana"
        case .sousse: return "Sousse"
        case .tozeur: return "Tozeur"
        case .tunis: return "Tunis"
        case .zaghouan: return "Zaghouan"
        }
    }

    var coordinate: CLLocationCoordinate2D {
        switch self {
        case .ariana: return .init(latitude: 36.8663, longitude: 10.1954)
        case .beja: return .init(latitude: 36.7294, longitude: 9.1900)
        case .benArous: return .init(latitude: 36.7382, longitude: 10.2269)
        case .bizerte: return .init(latitude: 37.2744, longitude: 9.8730)
        case .gabes: return .init(latitude: 33.8869, longitude: 10.0982)
        case .gafsa: return .init(latitude: 34.4250, longitude: 8.7842)
        case .jendouba: return .init(latitude: 36.5011, longitude: 8.7778)
        case .kairouan: return .init(latitude: 35.6782, longitude: 10.0965)
        case .kasserine: return .init(latitude: 35.1672, longitude: 8.8289)
        case .kebili: return .init(latitude: 33.7044, longitude: 8.9714)
        case .kef: return .init(latitude: 36.1699, longitude: 8.7088)
        case .mahdia: return .init(latitude: 35.5047, longitude: 11.0624)
        case .manouba: return .init(latitude: 36.8101, longitude: 9.2322)
        case .medenine: return .init(latitude: 33.3476, longitude: 10.4924)
        case .monastir: return .init(latitude: 35.7290, longitude: 10.7971)
        case .nabeul: return .init(latitude: 36.4560, longitude: 10.7351)
        case .sfax: return .init(latitude: 34.7390, longitude: 10.7605)
        case .sidiBouzid: return .init(latitude: 35.0387, longitude: 9.4852)
        case .siliana: return .init(latitude: 36.0909, longitude: 9.3701)
        case .sousse: return .init(latitude: 35.8273, longitude: 10.6367)
        case .tozeur: return .init(latitude: 33.9308, longitude: 8.1303)
        case .tunis: return .init(latitude: 36.8065, longitude: 10.1815)
        case .zaghouan: return .init(latitude: 36.4018, longitude: 10.1479)
        }
    }

    var extraZoomLevel: MKCoordinateSpan {
        switch self {
        case .ariana, .beja, .benArous, .bizerte, .gabes, .gafsa, .jendouba, .kairouan, .kasserine, .kebili, .kef, .mahdia, .manouba, .medenine, .monastir, .nabeul, .sfax, .sidiBouzid, .siliana, .sousse, .tozeur, .tunis, .zaghouan:
            return .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        }
    }

    var zoomLevel: MKCoordinateSpan {
        switch self {
        case .ariana, .beja, .benArous, .bizerte, .gabes, .gafsa, .jendouba, .kairouan, .kasserine, .kebili, .kef, .mahdia, .manouba, .medenine, .monastir, .nabeul, .sfax, .sidiBouzid, .siliana, .sousse, .tozeur, .tunis, .zaghouan:
            return .init(latitudeDelta: 0.2, longitudeDelta: 0.2)
        }
    }
}


enum AvailabilityDay: String , CaseIterable, Codable, Identifiable {
    
    var id: String { rawValue }
    
    case saturday
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    
    
    var title: String {
        switch self {
        case .saturday:  return "Saturday"
        case .sunday:    return "Sunday"
        case .monday:    return "Monday"
        case .tuesday:   return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday:  return "Thursday"
        case .friday:    return "Friday"
        }
    }
    
}

struct Equipment: Codable, Equatable {
    var id = UUID().uuidString
    var beds: Int = 0
    var baths: Int = 0
    var livingRooms: Int = 0
    var space: Int = 0
    var ovens: Int = 0
    var fridges: Int = 0
    var microwaves: Int = 0
    var airConditions: Int = 0

    var isSmart: Bool = false
    var hasWifi: Bool = false
    var hasPool: Bool = false
    var hasElevator: Bool = false
    var hasGym: Bool = false
}


struct RealEstate: Codable, Equatable, Identifiable{
    static func == (lhs: RealEstate, rhs: RealEstate) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id = UUID().uuidString
    var ownerId: String = ""
    var images: [String] = []
    var description: String = ""
    var equipment: [Equipment] = [Equipment()]

    
    var age: Int = 0
    
    var location: CLLocationCoordinate2D = .init(latitude: 0.0, longitude: 0.0)
    
    var saleCategory          : SaleCategory = .rent
    var city                  : City = .benArous
    var type                  : RealEstateType = .apartment
    var offer                 : OfferType      = .yearly
    var isAvailable           : Bool = true
    var price                 : Int = 0
    var videoUrlString        : String = ""
    
}

extension CLLocationCoordinate2D: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(longitude)
        try container.encode(latitude)
    }
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let longitude = try container.decode(CLLocationDegrees.self)
        let latitude = try container.decode(CLLocationDegrees.self)
        self.init(latitude: latitude, longitude: longitude)
    }
}

extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}


struct User: Codable, Identifiable {
    var id                  : String              = ""
    var profileImageUrl     : String              = ""
    var favoriteRealEstate  : [String]            = []
    var realEstates         : [String]            = []
    var phoneNumber         : String              = ""
    var email               : String              = ""
    var username            : String              = ""
    var isVerified          : Bool                = false
    var dayTimeAvailability : [DayTimeSelection]  = []
    var location            : CLLocationCoordinate2D = .init(latitude: 0.0, longitude: 0.0)
}

struct DayTimeSelection: Hashable, Codable {
    var day: AvailabilityDay
    var fromTime: Date
    var toTime: Date
}


