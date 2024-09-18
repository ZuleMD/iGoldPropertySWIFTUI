//
//  MyRealEstatesView.swift
//  iGoldProperty
//
//  Created by Mariem Derbali on 12/23/23.
//

import SwiftUI
import  SDWebImageSwiftUI


struct MyRealEstatesView: View {
    @EnvironmentObject var firebaseUserManager : FirebaseUserManager
    @EnvironmentObject var firebaseRealEstateManager : FirebaseRealEstateManager
    
            let customBackgroundColor = Color(UIColor(red: 237/255, green: 204/255, blue: 56/255, alpha: 1.0))
           let customDeepBlueColor = Color(UIColor(red: 29/255, green: 50/255, blue: 90/255, alpha: 1.0))
           let customForestGreenColor = Color(UIColor(red: 34/255, green: 102/255, blue: 68/255, alpha: 1.0))
           let customBurgundyColor = Color(UIColor(red: 103/255, green: 25/255, blue: 47/255, alpha: 1.0))
           let customSoftTealColor = Color(UIColor(red: 72/255, green: 156/255, blue: 154/255, alpha: 1.0))
    
           let customUltraThinMaterialColor = Color(UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 0.7))
    
    @State private var isDeleteConfirmationDialogShowing = false

  
    var body: some View {
                
            ScrollView {
              ForEach(firebaseRealEstateManager.myRealEstates){ realEstate in
                NavigationLink(
                    destination: RealEstateDetailView(realEstate: realEstate)
                ) {
                    HStack {
                   
                        if realEstate.images.isEmpty{
                           Image(systemName: "photo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 90, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 12))

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
                                        .frame(width: 23, height: 8).padding(.horizontal, 8)
                                    
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
                                                    Text("\(realEstate.equipment[0].beds )")


                                                   }.foregroundColor(.white)
                                                  .font(.system(size: 14, weight: .semibold))
                                                  .frame(width: 60, height: 28)
                                                  .background(customDeepBlueColor)
                                                  .cornerRadius(8)

                                                  HStack{
                                                      Image("shower")
                                                          .resizable()
                                                          .scaledToFill()
                                                          .frame(width: 15, height: 8)
                                                    Text("\(realEstate.equipment[0].baths )")
                                                   }.foregroundColor(.white)
                                                  .font(.system(size: 14, weight: .semibold))
                                                  .frame(width: 60, height: 28)
                                                  .background(customSoftTealColor)
                                                  .cornerRadius(8)

                                                  HStack{
                                                      Image("sofa")
                                                          .resizable()
                                                          .scaledToFill()
                                                          .frame(width: 20, height: 8)
                                                    Text("\(realEstate.equipment[0].livingRooms )")

                                                  }.foregroundColor(.white)
                                                  .font(.system(size: 14, weight: .semibold))
                                                  .frame(width: 60, height: 28)
                                                  .background(customBurgundyColor)
                                                  .cornerRadius(8)


                                                  HStack{
                                                      Image("space")
                                                          .resizable()
                                                          .scaledToFill()
                                                          .frame(width: 15, height: 8)
                                                    Text("\(realEstate.equipment[0].space)")


                                                  }.foregroundColor(.white)
                                                  .font(.system(size: 14, weight: .semibold))
                                                  .frame(width: 60, height: 28)
                                                  .background(customForestGreenColor)
                                                  .cornerRadius(8)
                                              }
                        }
                        
                        Spacer()
                        Image(systemName: "chevron.right").opacity(0.6).padding(.trailing, 8)
                    }
                  
                }.foregroundColor(Color(.label))
                
                .overlay(
                    
                    Menu {
                        ForEach(SaleCategory.allCases, id:\.self) { saleCategory in
                            Button {
                                var modifiedRealEstate = realEstate // Make a copy
                                
                                    switch saleCategory {
                                    
                                    case .investment:
                                        modifiedRealEstate.saleCategory = .investment
                                        if modifiedRealEstate.isAvailable {
                                            firebaseRealEstateManager.markRealEstateAs(realEstate: &modifiedRealEstate)
                                        } else {
                                            modifiedRealEstate.isAvailable = true
                                            firebaseRealEstateManager.reAddRealEstate(realEstate: modifiedRealEstate)
                                        }
                                        
                                        
                                case .rent:
                                    modifiedRealEstate.saleCategory = .rent
                                    if modifiedRealEstate.isAvailable {
                                        firebaseRealEstateManager.markRealEstateAs(realEstate: &modifiedRealEstate)
                                    } else {
                                        modifiedRealEstate.isAvailable = true
                                        firebaseRealEstateManager.reAddRealEstate(realEstate: modifiedRealEstate)
                                    }
                                case .sale:
                                    modifiedRealEstate.saleCategory = .sale
                                    if modifiedRealEstate.isAvailable {
                                        firebaseRealEstateManager.markRealEstateAs(realEstate: &modifiedRealEstate)
                                    } else {
                                        modifiedRealEstate.isAvailable = true
                                        firebaseRealEstateManager.reAddRealEstate(realEstate: modifiedRealEstate)
                                    }
                                }
                            } label: {
                                switch realEstate.saleCategory {
                                case .sale:
                                    if realEstate.isAvailable {
                                        Text("Mark as \(saleCategory.markedTitle)")
                                        Image(saleCategory.imageName)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 23, height: 8).padding(.horizontal, 8)
                                    }else {
                                        Text("Offer for \(saleCategory.title)")
                                        Image(saleCategory.imageName)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 23, height: 8).padding(.horizontal, 8)
                                    }
                                case .rent:
                                    if realEstate.isAvailable {
                                        Text("Mark as \(saleCategory.markedTitle)")
                                        Image(saleCategory.imageName)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 23, height: 8).padding(.horizontal, 8)
                                    }else {
                                        Text("Offer for \(saleCategory.title)")
                                        Image(saleCategory.imageName)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 23, height: 8).padding(.horizontal, 8)
                                    }
                                case .investment:
                                    if realEstate.isAvailable {
                                        Text("Mark as \(saleCategory.markedTitle)")
                                        Image(saleCategory.imageName)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 23, height: 8).padding(.horizontal, 8)
                                    }else {
                                        Text("Offer for \(saleCategory.title)")
                                        Image(saleCategory.imageName)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 23, height: 8).padding(.horizontal, 8)
                                    }
                                }
                            }
                        }

                        
                        Divider()


                        Button(action: {
                              isDeleteConfirmationDialogShowing.toggle()
                          }) {
                              Text("Delete")
                              Image("delete")
                          }
                       
                        
                        


                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.blue)
                            .padding(8)
                    }

                    
                    , alignment: .topTrailing
                ) .alert(isPresented: $isDeleteConfirmationDialogShowing) {
                    Alert(
                        title: Text("Delete Real Estate"),
                        message: Text("Are you sure you want to delete this real estate?"),
                        primaryButton: .destructive(Text("Delete")) {
                             firebaseRealEstateManager.deleteRealEstate(realEstate: realEstate)
                        },
                        secondaryButton: .cancel()
                    )
                }
                .overlay(

                    Text(realEstate.saleCategory.markedTitle)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.vertical, 4)
                        .frame(width: 380, height: 50)
                        .background(realEstate.saleCategory.saleColor.opacity(0.8))
                        .cornerRadius(12)
                        .rotationEffect(.init(degrees: -8))
                        .isHidden(!realEstate.isAvailable, remove: !realEstate.isAvailable)
                    
                    
                    
                    , alignment: .leading
                )
                Divider().padding(.vertical, 8)
                
                        }
                
                 
                    }
                    .navigationTitle("My Real Estates")
                    .navigationBarTitleDisplayMode(.inline)
      
    }
    

}


struct MyRealEstatesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            MyRealEstatesView()
        }
            .environmentObject(FirebaseUserManager())
            .environmentObject(FirebaseRealEstateManager())
            .preferredColorScheme(.dark)
    }
}
