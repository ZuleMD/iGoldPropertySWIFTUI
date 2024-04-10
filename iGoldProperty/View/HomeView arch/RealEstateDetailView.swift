//
//  RealEstateDetailView.swift
//  iGoldProperty
//
//  Created by Mariem Derbali on 11/27/23.
//

import SwiftUI
import MapKit
import AVKit
import SDWebImageSwiftUI

enum MediaType: String, CaseIterable {
    case photos
    case video
    
    var title: String {
        switch self {
        case .photos:
            return "Photos"
        case .video:
            return "Video"
        }
    }
    
}


struct RealEstateDetailView: View {
    @EnvironmentObject var firebaseUserManager : FirebaseUserManager
    //@Binding var realEstate: RealEstate
    @EnvironmentObject var firebaseRealEstateManager : FirebaseRealEstateManager
    var realEstate: RealEstate
    
    @StateObject var viewModel = AddRealEstateViewModel()

    @State var selectedMediaType: MediaType = .photos
    @State var coordinateRegion: MKCoordinateRegion = .init()
    @State var dayTimeSelection: [DayTimeSelection] = [
        .init(day: .monday, fromTime: Date(), toTime: Date()),
        .init(day: .tuesday, fromTime: Date(), toTime: Date()),
        .init(day: .wednesday, fromTime: Date(), toTime: Date()),
        .init(day: .thursday, fromTime: Date(), toTime: Date()),
        .init(day: .friday, fromTime: Date(), toTime: Date()),
        .init(day: .saturday, fromTime: Date(), toTime: Date()),
        .init(day: .sunday, fromTime: Date(), toTime: Date()),
    ]
    let customBackgroundColor = Color(UIColor(red: 237/255, green: 204/255, blue: 56/255, alpha: 1.0))
    
     
    let customDeepBlueColor = Color(UIColor(red: 29/255, green: 50/255, blue: 90/255, alpha: 1.0))
    let customForestGreenColor = Color(UIColor(red: 34/255, green: 102/255, blue: 68/255, alpha: 1.0))
    let customTerracottaOrangeColor = Color(UIColor(red: 204/255, green: 93/255, blue: 85/255, alpha: 1.0))
 
    let customUltraThinMaterialColor = Color(UIColor(red: 22/255, green: 22/255, blue: 22/255, alpha: 0.5))

    
    @State var ownerUser = User()
    
    var isBookMarked: Bool {
        firebaseRealEstateManager.bookmarkedRealEstates.contains(where: {$0.id == realEstate.id})
    }
    

    var body: some View {
        ScrollView {
                  Picker("Picker", selection: $selectedMediaType) {
                      ForEach(MediaType.allCases, id: \.self) { mediaType in
                          Text(mediaType.title)
                      }
                  }.pickerStyle(SegmentedPickerStyle())
                  .labelsHidden()

            switch selectedMediaType {
            case .photos:
                if realEstate.images == [] {
                    Image(systemName: "photo")
                      .resizable()
                      .scaledToFill()
                      .frame(width: 100, height: 100)
                      .opacity(0.4)
                      .padding(.vertical, 18)
                }
                else if realEstate.images.count == 1 {
                  
                    WebImage(url: URL(string: realEstate.images[0]))
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width - 20, height: 340)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            VStack{
                                HStack{
                                    HStack{
                                        Image(systemName: "photo")
                                        Text("\(realEstate.images.count)")
                                    }
                                     .padding(8)
                                    .background(customUltraThinMaterialColor).clipShape(RoundedRectangle(cornerRadius: 12))

                                    Spacer()
                                    
                                    Button {
                                        if isBookMarked {
                                            firebaseRealEstateManager.removeRealEstateFromBookMarks(realEstate: realEstate)
                                        }else{
                                            firebaseRealEstateManager.bookMarkRealEstate(realEstate: realEstate, userId: firebaseUserManager.user.id)
                                        }
                                    } label : {
                                        Image(systemName: isBookMarked ? "bookmark.fill" : "bookmark")
                                            .foregroundColor(customBackgroundColor)
                                            .padding(8)
                                            .background(customUltraThinMaterialColor).clipShape(Circle())
                                    }
                                }
                                Spacer()
                                HStack{
                                    HStack{
                                        Image(realEstate.saleCategory.imageName)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 24, height: 20)
                                        Text("\(realEstate.saleCategory.title)")
                                    }
                                    .padding(8)
                                     .background(customUltraThinMaterialColor).clipShape(RoundedRectangle(cornerRadius: 12))

                                    Spacer()
                                    Text("\(realEstate.price) TND")
                                        .padding(8)
                                         .background(customUltraThinMaterialColor).clipShape(RoundedRectangle(cornerRadius: 12))

                                }
                            }.padding()
                            //.padding(.bottom, -5)
                        )

                 }
                
                
                else {
                    TabView {
                        ForEach(realEstate.images, id: \.self) { imageUrlString in
                            if let imageUrl = URL(string: imageUrlString)
                            {
                                WebImage(url: imageUrl)
                                    .resizable()
                                    .placeholder {
                                        Rectangle().foregroundColor(.gray)
                                    }
                                    .indicator(.activity)
                                    .transition(.fade)
                                    .scaledToFill()
                                    .frame(width: UIScreen.main.bounds.width - 20, height: 340)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .offset(y: -20)
                            }

                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    .frame(height: 400)
                    .overlay(
                        VStack{
                            HStack{
                                HStack{
                                    Image(systemName: "photo")
                                    Text("\(realEstate.images.count)")
                                }
                                .padding(8)
                                .background(customUltraThinMaterialColor).clipShape(RoundedRectangle(cornerRadius: 12))

                                Spacer()
                                Button {
                                    if isBookMarked {
                                        firebaseRealEstateManager.removeRealEstateFromBookMarks(realEstate: realEstate)
                                    }else{
                                        firebaseRealEstateManager.bookMarkRealEstate(realEstate: realEstate, userId: firebaseUserManager.user.id)
                                    }

                                } label : {
                                    Image(systemName: isBookMarked ? "bookmark.fill" : "bookmark")
                                        .foregroundColor(customBackgroundColor)
                                        .padding(8)
                                        .background(customUltraThinMaterialColor).clipShape(Circle())
                                }

                            }
                            Spacer()
                            HStack{
                                HStack{
                                    Image(realEstate.saleCategory.imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 24, height: 20)
                                    Text("\(realEstate.saleCategory.title)")
                                }
                                .padding(8)
                                .background(customUltraThinMaterialColor).clipShape(RoundedRectangle(cornerRadius: 12))

                                Spacer()
                                Text("\(realEstate.price)")
                                    .padding(8)
                                    .background(customUltraThinMaterialColor).clipShape(RoundedRectangle(cornerRadius: 12))

                            }
                        }.padding().padding(.bottom, 40)
                    )

                }


            case .video:
               
                    if realEstate.videoUrlString != "" {
                        VideoPlayer(player: AVPlayer(url: URL(string: realEstate.videoUrlString)!))
                            .frame(width: UIScreen.main.bounds.width, height: 360)
                    }else {
                        Image(systemName: "play.slash")
                          .resizable()
                          .scaledToFill()
                          .frame(width: 100, height: 100)
                          .padding(.vertical, 18)
                    }
            
                

            }
            Divider()

            VStack(alignment: .leading){
                HStack{
                    Text("Info").foregroundColor(customBackgroundColor).font(.title)
                    Spacer()
                }
                Text(realEstate.description)
                    .font(.system(size: 16, weight: .semibold))
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 4)
            }.padding(.horizontal, 4)

            Divider()

            ApplianceView(realEstate: realEstate)

            Divider()

            AmnetiesView(realEstate: realEstate)

            Map(coordinateRegion: $coordinateRegion, annotationItems: [realEstate]){
                realEstate in
                MapAnnotation(coordinate: realEstate.location){
                    HStack{
                        Image(systemName: "info.circle")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 18, height: 20)
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(Color(UIColor.black))

                        Text("\(realEstate.price) TND")
                            .font(.system(size: 18, weight: .semibold))
                            .minimumScaleFactor(0.8)
                            .foregroundColor(Color(UIColor.black))

                        Image(realEstate.type.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color(UIColor.black).opacity(0.8))
                    }.padding(.bottom, 12)
                    .padding()
                    .background(
                        VStack(spacing: 0){
                            Spacer()
                            RoundedRectangle(cornerRadius: 12).fill(customBackgroundColor)
                            Triangle().fill(customBackgroundColor)
                                .frame(width: 20, height: 20).rotationEffect(.init(degrees: 180))
                        }
                    )
                }
            }.frame(width: UIScreen.main.bounds.width - 50, height: 240)
            .cornerRadius(12)
            .onAppear{
                coordinateRegion.center = realEstate.location
                coordinateRegion.span = realEstate.city.extraZoomLevel
                firebaseRealEstateManager.fetchOwnerDetail(userId: realEstate.ownerId) {
                    ownerUser in
                    self.ownerUser = ownerUser
                }
                
            }
            
            VStack(alignment: .leading, spacing: 8){
                HStack{
                    VStack{
                        WebImage(url: URL(string: ownerUser.profileImageUrl))
                            .resizable()
                            .placeholder {
                                Rectangle().foregroundColor(.gray)
                            }
                            .indicator(.activity)
                            .transition(.fade)
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .padding(2)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 0.4)
                            )
                        Text(ownerUser.username)
                    }
                
                VStack{
                    
                    HStack{
                        
                             Button(action: {
                              
                             }) {
                                 HStack{
                                     Image(systemName: "envelope")
                                     Text("Email")
                                 }
                                     
                                   .foregroundColor(Color.white)
                                     .frame(width: 150, height: 32)
                                     .background(customTerracottaOrangeColor)
                                 .cornerRadius(5)
                                 
                             }
                         
                         Button(action: {
                          
                         }) {
                             HStack{
                                 Image(systemName: "bubble.left")
                                 Text("WhatsApp")
                             }
                                 
                               .foregroundColor(Color.white)
                                 .frame(width: 140, height: 32)
                             .background(customForestGreenColor)
                             .cornerRadius(5)

                             
                         }
                        
                    }
                 
                    
                        Button(action: {
                         
                        }) {
                            HStack{
                                Image(systemName: "phone")
                                Text(ownerUser.phoneNumber)
                            }
                                
                              .foregroundColor(Color.white)
                                .frame(width: 300, height: 32)
                            .background(customDeepBlueColor)
                            .cornerRadius(5)
                        
                            
                        }.padding(.top, 2)
                }
                     
                }
                Spacer()
                ForEach(ownerUser.dayTimeAvailability, id:\.self){
                    dayTimeSelection in
                    
                    HStack{
                        Text(dayTimeSelection.day.title)
                        Spacer()
                        Text(dayTimeSelection.fromTime.convertDate(formattedString: .timeOnly))
                        Text("-")
                        Text(dayTimeSelection.toTime.convertDate(formattedString: .timeOnly))
                    }
                  
                    Divider()
                }
            }.padding(.horizontal, 4)
            .padding(.top, 8)
            
        }
        .onAppear{
            coordinateRegion.center = realEstate.location
            coordinateRegion.span = realEstate.city.extraZoomLevel
        }
        .navigationTitle("Details")
    }
    
    struct ApplianceView: View {
        @State var realEstate: RealEstate
        let customBackgroundColor = Color(UIColor(red: 237/255, green: 204/255, blue: 56/255, alpha: 1.0))
        //Appliance Buttons Colors
        let customDeepBlueColor = Color(UIColor(red: 29/255, green: 50/255, blue: 90/255, alpha: 1.0))
        let customForestGreenColor = Color(UIColor(red: 34/255, green: 102/255, blue: 68/255, alpha: 1.0))
        let customBurgundyColor = Color(UIColor(red: 103/255, green: 25/255, blue: 47/255, alpha: 1.0))
        let customSoftTealColor = Color(UIColor(red: 72/255, green: 156/255, blue: 154/255, alpha: 1.0))
        let customRichPurpleColor = Color(UIColor(red: 94/255, green: 53/255, blue: 177/255, alpha: 1.0))
        let customTerracottaOrangeColor = Color(UIColor(red: 204/255, green: 93/255, blue: 85/255, alpha: 1.0))
        let customSubtlePinkColor = Color(UIColor(red: 227/255, green: 156/255, blue: 167/255, alpha: 1.0))
        let customSteelGrayColor = Color(UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0))
        
        var body: some View {
            VStack(alignment: .center){
                HStack {
                    Text("Appliance").foregroundColor(customBackgroundColor).font(.title)
                    Spacer()
                }
                HStack(spacing : 7){
                    VStack {
                        Image("beds")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 25, height: 10)
                            .padding(.top, 8)

                        HStack {
                            Text("Beds \(realEstate.equipment.first?.beds ?? 0)")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .semibold))
                        }
                    }
                    .frame(width: 85, height: 48)
                    .background(customDeepBlueColor)
                    .cornerRadius(8)
                    .padding(.top, 2)
                    
                    
                    VStack{
                        Image("shower")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 23, height: 8)
                            .padding(.top, 8)

                        HStack {
                            Text("Baths \(realEstate.equipment.first?.baths ?? 0)")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .semibold))
                        }
                    }.frame(width: 85, height: 48)
                    .background(customSoftTealColor)
                    .cornerRadius(8)
                    .padding(.top, 2)
                    

                    VStack{
                        Image("sofa")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 10)
                            .padding(.top, 8)

                        HStack {
                            Text("Rooms \(realEstate.equipment.first?.livingRooms ?? 0)")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .semibold))

                        }
                    }.frame(width: 85, height: 48)
                    .background(customBurgundyColor)
                    .cornerRadius(8)
                    .padding(.top, 2)
                    

                    VStack{
                        Image("space")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 23, height: 8)
                            .padding(.top, 8)

                        HStack {
                            Text("Space \(realEstate.equipment.first?.space ?? 0)")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .semibold))

                        }
                    }.frame(width: 85, height: 48)
                    .background(customForestGreenColor)
                    .cornerRadius(8)
                    .padding(.top, 2)
                }

                HStack(spacing : 7){
                    VStack{
                        Image("ovens")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 23, height: 8)
                            .padding(.top, 8)

                        HStack {
                            Text("Ovens \(realEstate.equipment.first?.ovens ?? 0)")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .semibold))
                        }
                    }.frame(width: 85, height: 48)
                    .background(customRichPurpleColor)
                    .cornerRadius(8)
                    .padding(.top, 2)
                     
                    VStack{
                        Image("fridges")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 25, height: 8)
                            .padding(.top, 8)

                        HStack {
                            Text("Fridges \(realEstate.equipment.first?.fridges ?? 0)")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .semibold))

                        }
                    }.frame(width: 85, height: 48)
                    .background(customTerracottaOrangeColor)
                    .cornerRadius(8)
                    .padding(.top, 2)
                    
                    

                    VStack{
                        Image("micro")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 23, height: 8)
                            .padding(.top, 8)

                        HStack {
                            Text("Micro \(realEstate.equipment.first?.microwaves ?? 0)")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .semibold))

                        }
                    }.frame(width: 85, height: 48)
                    .background(customSubtlePinkColor)
                    .cornerRadius(8)
                    .padding(.top, 2)
                   

                    VStack{
                        Image("AC")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 25, height: 8)
                            .padding(.top, 8)

                        HStack {
                            Text("A/C \(realEstate.equipment.first?.airConditions ?? 0)")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .semibold))

                        }
                    }.frame(width: 85, height: 48)
                    .background(customSteelGrayColor)
                    .cornerRadius(8)
                    .padding(.top, 2)
                     
                }


            }.padding(.horizontal, 4)
        }
    }

    struct AmnetiesView: View {
        @State var realEstate: RealEstate
        let customBackgroundColor = Color(UIColor(red: 237/255, green: 204/255, blue: 56/255, alpha: 1.0))
        
        let customForestGreenColor = Color(UIColor(red: 34/255, green: 102/255, blue: 68/255, alpha: 1.0))
        let customTerracottaOrangeColor = Color(UIColor(red: 204/255, green: 93/255, blue: 85/255, alpha: 1.0))
        
        var body: some View{
            VStack(alignment: .center){
                HStack{
                    Text("Amenities").foregroundColor(customBackgroundColor).font(.title)
                    Spacer()
                }
                HStack(spacing: 7){
                    VStack(spacing: 2){
                        Image("smart")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 43, height: 30)
                        Text("Smart")
                            .font(.system(size: 14, weight: .semibold))
                            .padding(.top, 8)
                        Image(systemName: realEstate.equipment.first?.isSmart == true ? "checkmark.square.fill": "xmark.square.fill")
                            .foregroundColor(realEstate.equipment.first?.isSmart == true ? customForestGreenColor : customTerracottaOrangeColor)
                             .padding(.top, 4)
                    }.frame(width: 60)
                    Divider()
                    
                    VStack(spacing: 2){
                        Image("wifi")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 43, height: 30)
                        Text("WiFi")
                            .font(.system(size: 14, weight: .semibold))
                            .padding(.top, 8)
                        Image(systemName: realEstate.equipment.first?.hasWifi == true ? "checkmark.square.fill": "xmark.square.fill").foregroundColor(realEstate.equipment.first?.hasWifi == true ? customForestGreenColor : customTerracottaOrangeColor)
                            .padding(.top, 4)
                    }.frame(width: 60)
                    
                    Divider()
                    
                    VStack(spacing: 2){
                        Image("pool")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 43, height: 35)
                        
                        Text("Pool")
                            .font(.system(size: 14, weight: .semibold))
                            .padding(.top, 8)
                        Image(systemName: realEstate.equipment.first?.hasPool == true ? "checkmark.square.fill": "xmark.square.fill").foregroundColor(realEstate.equipment.first?.hasPool == true ? customForestGreenColor : customTerracottaOrangeColor)
                            .padding(.top, 4)
                    }.frame(width: 60)
                    Divider()
                    
                    VStack(spacing: 2){
                        Image("elevator")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 43, height: 20)
                            .offset(y: 9)
                        Text("Elevator")
                            .font(.system(size: 14, weight: .semibold))
                            .padding(.top, 25)
                        Image(systemName: realEstate.equipment.first?.hasElevator == true ? "checkmark.square.fill": "xmark.square.fill").foregroundColor(realEstate.equipment.first?.hasElevator == true ? customForestGreenColor : customTerracottaOrangeColor)
                            .padding(.top, 3)
                    }.frame(width: 60)
                    
                    Divider()
                    
                    VStack(spacing: 2){
                        Image("gym")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 43, height: 30)
                            .offset(y: 9)
                        Text("Gym")
                            .font(.system(size: 14, weight: .semibold))
                            .padding(.top, 15)
                        Image(systemName: realEstate.equipment.first?.hasGym == true ? "checkmark.square.fill": "xmark.square.fill").foregroundColor(realEstate.equipment.first?.hasGym == true ? customForestGreenColor : customTerracottaOrangeColor)
                            .padding(.top, 4)
                    }.frame(width: 60)
                }
                HStack{
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.5))
                        .frame(maxWidth: .infinity)
                        .frame(height: 1)
                    
                    
                    VStack(spacing: 2){
                        Image("age")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 53, height: 30)
                        Text("\(realEstate.age) \(realEstate.age == 1 ? "Year" : "Years")")
                            .font(.system(size: 14, weight: .semibold))
                            .padding(.top, 12)

                        
                    }.padding(.horizontal, 10)
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.5))
                        .frame(maxWidth: .infinity)
                        .frame(height: 1)
                }.padding(.top, 16)
            }.padding(.horizontal, 4)
        }
        
        
    }

}


struct RealEstateDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RealEstateDetailView(realEstate:  realEstateSample)
        }
            .preferredColorScheme(.dark)
            .environmentObject(FirebaseUserManager())
        .environmentObject(FirebaseRealEstateManager())
        
    }
}

let realEstateSample: RealEstate = RealEstate(
    images: ["person", "person", "person"],
    description: "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga.",
    equipment: [
        Equipment(
            beds: Int.random(in: 1...4),
            baths: Int.random(in: 1...4),
            livingRooms: Int.random(in: 1...4),
            space: Int.random(in: 100...200),
            ovens: Int.random(in: 1...4),
            fridges: Int.random(in: 1...4),
            microwaves: Int.random(in: 1...4),
            airConditions: Int.random(in: 1...4),
            isSmart: false, hasWifi: true, hasPool: false,
            hasElevator: true, hasGym: false
        )
    ],
    age: Int.random(in: 1...4),
    location: City.benArous.coordinate,
    saleCategory: .rent, city: .benArous, type: .apartment,
    offer: .monthly, isAvailable: true,
    price: Int.random(in: 1000...100000),
    videoUrlString: "https://bit.ly/swswift"
)
