
//
//  HomeView.swift
//  iGoldProperty
//
//  Created by Mariem Derbali on 10/30/23.
//

import SwiftUI
import SDWebImageSwiftUI
import MapKit


    struct HomeView: View {
        
        @EnvironmentObject var firebaseUserManager : FirebaseUserManager
        @EnvironmentObject var firebaseRealEstateManager : FirebaseRealEstateManager

        @State var isShowingProfileView: Bool = false
        @State var isShowingAuthView: Bool = false
        @State var isShowingAddingRealEstateView: Bool = false
        @State var isShowingFilterView: Bool = false
 
        @State var coordinateRegion : MKCoordinateRegion = .init(center: City.benArous.coordinate, span: .init(latitudeDelta: 0.06, longitudeDelta: 0.06))
        
          
        
        @State var popupBGColor = Color.black
        @StateObject var locationManager = LocationManager()
        
         let customBackgroundColor = Color(UIColor(red: 237/255, green: 204/255, blue: 56/255, alpha: 1.0))
        let customDeepBlueColor = Color(UIColor(red: 29/255, green: 50/255, blue: 90/255, alpha: 1.0))
        let customForestGreenColor = Color(UIColor(red: 34/255, green: 102/255, blue: 68/255, alpha: 1.0))
        let customBurgundyColor = Color(UIColor(red: 103/255, green: 25/255, blue: 47/255, alpha: 1.0))
        let customSoftTealColor = Color(UIColor(red: 72/255, green: 156/255, blue: 154/255, alpha: 1.0))

        let customUltraThinMaterialColor = Color(UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 0.7))
        
        @State var selectedRealEstate: RealEstate?
         


        var body: some View {
            
            content.fullScreenCover(isPresented: $isShowingAuthView){
                AuthView()
            }.preferredColorScheme(.dark)
            
            .sheet(isPresented: $isShowingFilterView){
                MapFilterView()
                    .preferredColorScheme(.dark)
            }

            
        }
        
        var content: some View {
            NavigationView {
                        
            
                 mapView
                 .overlay (
                            HStack {
                                Button(action: {
                                    if firebaseUserManager.isAuthenticated {
                                        isShowingProfileView.toggle()

                                    } else {
                                        isShowingAuthView.toggle()

                                    }

                                },label: {
                                    WebImage(url: URL(string: firebaseUserManager.user.profileImageUrl))
                                        .resizable()
                                        .placeholder {
                                            Rectangle().foregroundColor(.gray)
                                        }
                                        .animated()
                                        .indicator(.activity)
                                        .transition(.fade)
                                        .scaledToFill()
                                        .frame(width: 48, height: 48)
                                        .clipShape(Circle())
                                        .padding(4)
                                        .overlay(
                                            Circle().stroke(Color.white, lineWidth: 0.4)
                                        )
                                })
                                Text(firebaseUserManager.user.username)
                                    .fullScreenCover(isPresented: $isShowingProfileView){
                                        ProfileView()
                                    }.preferredColorScheme(.dark)

                                Spacer()
                                Button(action: {
                                    isShowingAddingRealEstateView.toggle()
                                }) { Text("Add Real Estate")
                                }.padding(.trailing, 12)
                                .fullScreenCover(isPresented: $isShowingAddingRealEstateView){
                                    AddRealEstateView(isShowingAddingRealEstateView: $isShowingAddingRealEstateView)
                                }.preferredColorScheme(.dark)

                            }
                            

                            .background(Color.black).opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/),alignment: .top


                        )
     
                 .overlay(
                                    VStack(spacing : 10){
                                        Button(action: {
                                            if let center = locationManager.userLocation?.coordinate {
                                                locationManager.region?.center = center
                                            }

                                        }) {
                                            Image(systemName: "scope")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 30, height: 30)
                                        }
                                        Divider()
                                        Button{
                                            isShowingFilterView.toggle()
                                        } label: {
                                            Image(systemName: "line.horizontal.3.decrease")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 18, height: 18)
                                        }
                                        Divider()
                                        Button(action: {
                                            withAnimation {
                                                guard let currentSpan = locationManager.region?.span else {
                                                    return
                                                }
                                                
                                                let newSpan = MKCoordinateSpan(
                                                    latitudeDelta: max(currentSpan.latitudeDelta / 2, 0.001),
                                                    longitudeDelta: max(currentSpan.longitudeDelta / 2, 0.001)
                                                )
                                                
                                                locationManager.region?.span = newSpan
                                            }

                                        }) {
                                            Image(systemName: "plus.circle")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 18, height: 18)
                                        }
                                        
                                        Button(action: {
                                            withAnimation {
                                                   guard let currentSpan = locationManager.region?.span else {
                                                       return
                                                   }
                                                   
                                                   let newSpan = MKCoordinateSpan(
                                                       latitudeDelta: min(currentSpan.latitudeDelta * 2, 180.0),
                                                       longitudeDelta: min(currentSpan.longitudeDelta * 2, 180.0)
                                                   )
                                                   
                                                   locationManager.region?.span = newSpan
                                               }
                                        }) {
                                            Image(systemName: "minus.circle")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 18, height: 18)
                                         }
                                    }.frame(width: 46, height: 170)
                                    .background(Color.black).opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                                    .clipShape(RoundedRectangle(cornerRadius: 12)

                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.6), lineWidth: 0.6)
                                                )
                                    .padding()
                                    , alignment: .bottomTrailing
                                )
                
        }
        

}
       
        var mapView: some View {
            Map(
                coordinateRegion: Binding(
                    get: { locationManager.region ?? MKCoordinateRegion(center: City.benArous.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)) },
                    set: { locationManager.region = $0 }
                ),
                interactionModes: .all,
                showsUserLocation: true,
                annotationItems: firebaseRealEstateManager.realEstates
            ) { realEstate in
                MapAnnotation(coordinate: realEstate.location) {
                    NavigationLink(destination: RealEstateDetailView(realEstate: realEstate)) {
                        realEstateCardView(realEstate: realEstate)
                    }.foregroundColor(.white)
                    Button(action : {
                        withAnimation(.spring()) {
                            selectedRealEstate = realEstate
                            locationManager.region?.center = realEstate.location
                        }

                        }, label: {
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
                                        .scaledToFill()
                                        .frame(width: 15, height: 8)
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
                        
                        })
                }
            }
         }
        
        @ViewBuilder
        private func realEstateCardView(realEstate: RealEstate) -> some View {
            Group {
                HStack {
                    if realEstate.images.isEmpty{
                       Image(systemName: "photo")

                    }else{
                        WebImage(url: URL(string: realEstate.images.first ?? ""))
                            .resizable()
                            .placeholder {
                                Rectangle().foregroundColor(.gray)
                            }
                            .animated()
                            .indicator(.activity)
                            .scaledToFill()
                            .frame(width: 90, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("\(realEstate.price) TND")
                            Text("•")
                            
                            HStack(spacing: 4) {
                                Image(realEstate.saleCategory.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 23, height: 8)
                                
                                Text(realEstate.saleCategory.title)
                            }
                            .foregroundColor(.blue)
                            .font(.system(size: 12, weight: .semibold))
                        }
                        
                        Text(realEstate.description)
                            .font(.system(size: 12, weight: .semibold))
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 2)
                            .multilineTextAlignment(.leading)
                        
                        HStack(spacing: 4) {
                            Image(realEstate.type.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 15, height: 8)
                            
                            Text(realEstate.type.title)
                        }
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color.white.opacity(0.6))
                        
                        Divider()
                        
                        HStack{
                                              HStack{
                                                  Image("beds")
                                                      .resizable()
                                                      .scaledToFill()
                                                      .frame(width: 15, height: 8)
                                                Text("\(realEstate.equipment[0].beds)")

                                               }.foregroundColor(.white)
                                              .font(.system(size: 12, weight: .semibold))
                                              .frame(width: 50, height: 28)
                                              .background(customDeepBlueColor)
                                              .cornerRadius(8)

                                              HStack{
                                                  Image("shower")
                                                      .resizable()
                                                      .scaledToFill()
                                                      .frame(width: 15, height: 8)
                                                Text("\(realEstate.equipment[0].baths)")
                                               }.foregroundColor(.white)
                                              .font(.system(size: 12, weight: .semibold))
                                              .frame(width: 50, height: 28)
                                              .background(customSoftTealColor)
                                              .cornerRadius(8)

                                              HStack{
                                                  Image("sofa")
                                                      .resizable()
                                                      .scaledToFill()
                                                      .frame(width: 20, height: 8)
                                                Text("\(realEstate.equipment[0].livingRooms)")

                                              }.foregroundColor(.white)
                                              .font(.system(size: 12, weight: .semibold))
                                              .frame(width: 50, height: 28)
                                              .background(customBurgundyColor)
                                              .cornerRadius(8)


                                              HStack{
                                                  Image("space")
                                                      .resizable()
                                                      .scaledToFill()
                                                      .frame(width: 15, height: 8)
                                                 Text("\(realEstate.equipment[0].space)")

                                              }.foregroundColor(.white)
                                              .font(.system(size: 12, weight: .semibold))
                                              .frame(width: 70, height: 28)
                                              .background(customForestGreenColor)
                                              .cornerRadius(8)
                                          }
                    }
                    
                    Spacer()
                }
            }
                .frame(width: UIScreen.main.bounds.width - 20)
                .padding(6)
                .background(popupBGColor.cornerRadius(12))
                
                .padding(.bottom, -14)
                .foregroundColor(.white)
            .overlay(
                Button(action: {
                    withAnimation {
                        selectedRealEstate = nil
                    }
                }) {
                    Image(systemName: "eye.slash")
                        .foregroundColor(.yellow)
                        .padding(3)
                }
                , alignment: .topTrailing
            )
            .modifier(ConditionalAnimationModifier(condition: selectedRealEstate == realEstate))
        }
        


    }

struct ConditionalAnimationModifier: ViewModifier {
    let condition: Bool

    func body(content: Content) -> some View {
        content
            .scaleEffect(condition ? 1 : 0)
            .opacity(condition ? 1 : 0)
            .animation(.spring(), value: condition)
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint (x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint (x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint (x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint (x: rect.midX, y: rect.minY))
        
        return path
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(FirebaseUserManager())
            .environmentObject(FirebaseRealEstateManager())
        
     }
}

