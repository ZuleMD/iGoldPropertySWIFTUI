//
//  MapFilterView.swift
//  iGoldProperty
//
//  Created by Mariem Derbali on 12/25/23.
//

import SwiftUI

struct MapFilterView: View {
    
    @EnvironmentObject var firebaseUserManager : FirebaseUserManager
    @EnvironmentObject var firebaseRealEstateManager : FirebaseRealEstateManager
    @Environment(\.presentationMode) private var presentationMode
    
    @State var beds: Int = 0
    @State var baths: Int = 0
    @State var livingRooms: Int = 0
    @State var spaces: Int = 0
    @State var ovens: Int = 0
    @State var fridges: Int = 0
    @State var microwaves: Int = 0
    @State var airConditions: Int = 0
    
    @State var isSmart: Bool = false
    @State var hasWifi: Bool = false
    @State var hasPool: Bool = false
    @State var hasElevator: Bool = false
    @State var hasGym: Bool = false
    @State var age: Int = 0
    
    
    let customBackgroundColor = Color(UIColor(red: 237/255, green: 204/255, blue: 56/255, alpha: 1.0))
   let customApplyBtnColor = Color(#colorLiteral(red: 0, green: 0.3298943503, blue: 0.5749381781, alpha: 1))
 
   
    
    @State var selectedCity: City = .benArous
    @State var selectedType : RealEstateType = .apartment
    
    @State var isLoading: Bool = false
    
    var filteredRealEstates: [RealEstate] {
        firebaseRealEstateManager.realEstates
            .filter{
                $0.city == selectedCity
                    && $0.type == selectedType
            }
            .filter{
                $0.equipment[0].beds >= beds
                && $0.equipment[0].baths >= baths
                    && $0.equipment[0].livingRooms >= livingRooms
               && $0.equipment[0].space >= spaces
               && $0.equipment[0].ovens >= ovens
               && $0.equipment[0].fridges >= fridges
                && $0.equipment[0].microwaves >= microwaves
                && $0.equipment[0].airConditions >= airConditions
            }
            .filter{
                $0.equipment[0].hasGym == hasGym
                    || $0.equipment[0].isSmart == isSmart
                    || $0.equipment[0].hasElevator == hasElevator
                    || $0.equipment[0].hasPool == hasPool
                    || $0.equipment[0].hasWifi == hasWifi
            }
            .filter{
                $0.age >= age
            }
          
    }
    
 
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    
                LocationView(selectedCity: $selectedCity)
                Divider()
                TypeView(selectedType: $selectedType)
                Divider()
            
                ApplianceView(
                    beds: $beds,
                    baths: $baths,
                    livingRooms: $livingRooms,
                    spaces: $spaces,
                    ovens: $ovens,
                    fridges: $fridges,
                    microwaves: $microwaves,
                    airConditions: $airConditions
                )
              
                Divider()
                AmenityView(
                    
                    isSmart: $isSmart,
                    hasWifi: $hasWifi,
                    hasPool: $hasPool,
                    hasElevator: $hasElevator,
                    hasGym: $hasGym,
                    age: $age
                )
              
                Button(action: {
                    isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                        isLoading = false
                        presentationMode.wrappedValue.dismiss()
                        firebaseRealEstateManager.realEstates = filteredRealEstates
                    }
                    
                }) {
                    HStack {
                        Text("Apply for (\(filteredRealEstates.count))")
                    }
                    .foregroundColor(.black)
                    .font(.system(size: 18, weight: .semibold))
                    
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(customBackgroundColor)
                    .cornerRadius(12)
                    .padding(.horizontal, 24)
                    
                }.padding(.top, 18)
                
                Button(action: {
                    isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                        isLoading = false
                        presentationMode.wrappedValue.dismiss()
                        firebaseRealEstateManager.realEstates = firebaseRealEstateManager.realEstatesReset
                    }
                    
                }) {
                    HStack {
                        Text("Get All (\( firebaseRealEstateManager.realEstatesReset.count))")
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .semibold))
                    
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)

                    .background(customApplyBtnColor)
                    .cornerRadius(12)
                    .padding(.horizontal, 24)
                    
                }
                           
                .padding(.top, 3)

                HStack{
                    Spacer()
                }
                
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button{
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }.navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
        }
        .overlay(
            ZStack{
                Color.black.opacity(0.4).ignoresSafeArea()
                VStack(spacing: 20){
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle()).accentColor(Color.white)
                        .scaleEffect(2)
                    Text("Please wait...")
                }
            }.isHidden(isLoading, remove: isLoading)
        )
    }
    
    }
    
    struct LocationView: View {
        let customBackgroundColor = Color(UIColor(red: 237/255, green: 204/255, blue: 56/255, alpha: 1.0))
        @EnvironmentObject var firebaseRealEstateManager : FirebaseRealEstateManager

        @Binding var selectedCity: City
        
        var body: some View {
            VStack {
                HStack {
                    Text("Location:")
                        .foregroundColor(customBackgroundColor)
                        .font(.system(size: 20, weight: .semibold))
                    Spacer()
                }
                .padding(.top, 30)
                
                HStack{
                    Text("City:")
                    
                    Spacer()
                    Menu {
                        ForEach(City.allCases, id:\.self){ city in
                            Button{
                                selectedCity = city
                            } label:{
                                Text("(\(firebaseRealEstateManager.realEstates.filter{$0.city == city}.count))  ")
                                +
                                Text(city.title)
                            }
                        }
                    } label: {
                        HStack(spacing: 4){
                            Text("(\(firebaseRealEstateManager.realEstates.filter{$0.city == selectedCity}.count))")
                        
                            Text(selectedCity.title)
                            Image(systemName: "chevron.down")
                        }.foregroundColor(.white)
                        .frame(width: 140, alignment: .trailing)
                    }
                }.padding(.horizontal, 18)
            }
            .padding(.horizontal, 8)
           
        }
    }
    
    struct TypeView: View {
        let customBackgroundColor = Color(UIColor(red: 237/255, green: 204/255, blue: 56/255, alpha: 1.0))
        @EnvironmentObject var firebaseRealEstateManager : FirebaseRealEstateManager

        @Binding var selectedType: RealEstateType

        var body: some View {
            VStack {
                HStack {
                    Text("Type:")
                        .foregroundColor(customBackgroundColor)
                        .font(.system(size: 20, weight: .semibold))
                    Spacer()
                }
                .padding(.top, 30)
                
                HStack{
                    Text("Category:")
                    
                    Spacer()
                    Menu {
                        ForEach(RealEstateType.allCases, id:\.self){ type in
                            Button{
                                selectedType = type
                            } label:{
                                Text("(\(firebaseRealEstateManager.realEstates.filter{$0.type == type}.count))  ")
                                +
                                Text(type.title)
                                Image(type.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                            }
                        }
                    } label: {
                        HStack(spacing: 4){
                            Text("(\(firebaseRealEstateManager.realEstates.filter{$0.type == selectedType}.count))")
                            
                            Text(selectedType.title)
                            Image(selectedType.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            
                            Image(systemName: "chevron.down")
                        }.foregroundColor(.white)
                        .frame(width: 180, alignment: .trailing)
                    }
                }.padding(.horizontal, 18)
            }
            .padding(.horizontal, 8)
           
        }
    }

    struct ApplianceView: View {
      
        @Binding var beds: Int
        @Binding var baths: Int
        @Binding var livingRooms: Int
        @Binding var spaces: Int
         
        @Binding var ovens: Int
        @Binding var fridges: Int
        @Binding var microwaves: Int
        @Binding var airConditions: Int
        
        @EnvironmentObject var firebaseRealEstateManager : FirebaseRealEstateManager

        
        
        let customBackgroundColor = Color(UIColor(red: 237/255, green: 204/255, blue: 56/255, alpha: 1.0))

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
                      
                      Menu{
                          ForEach(0...10, id:\.self){ beds in
                              Button(action: {
                                self.beds = beds
                              }, label: {
                                  switch beds{
                                  case 0:
                                      Text("0 Bed")
                                  case 1:
                                      Text("\(beds) Bed")
                                  case 2...:
                                      Text("\(beds) Beds")
                                  default:
                                      Text("\(beds) Beds")
                                  
                                  }
                              })
                          }
                      } label : {
                          VStack{
                              Image("beds")
                                  .resizable()
                                  .scaledToFill()
                                  .frame(width: 25, height: 10)
                                  .padding(.top, 8)

                              HStack(spacing: 2){
                                  Image(systemName: "chevron.down")
                                Text("\(self.beds) Beds")
                                      .foregroundColor(.white)
                                      .font(.system(size: 14, weight: .semibold))

                              }
                          }
                          .foregroundColor(.white)
                          .frame(width: 85, height: 48)
                          .background(customDeepBlueColor)
                          .cornerRadius(8)
                          .padding(.top, 2)
                      }
                      
                      Menu{
                          ForEach(0...10, id:\.self){ baths in
                              Button(action: {
                                self.baths = baths
                              }, label: {
                                  switch baths{
                                  case 0:
                                      Text("0 Bath")
                                  case 1:
                                      Text("\(baths) Bath")
                                  case 2...:
                                      Text("\(baths) Baths")
                                  default:
                                      Text("\(baths) Baths")
                                  
                                  }
                              })
                          }
                      } label : {
                          VStack{
                              Image("shower")
                                  .resizable()
                                  .scaledToFill()
                                  .frame(width: 23, height: 8)
                                  .padding(.top, 8)

                              HStack(spacing: 2){
                                  Image(systemName: "chevron.down")
                                Text("\(self.baths) Baths")
                                      .foregroundColor(.white)
                                      .font(.system(size: 14, weight: .semibold))

                              }
                          }
                          .foregroundColor(.white)
                          .frame(width: 85, height: 48)
                          .background(customSoftTealColor)
                          .cornerRadius(8)
                          .padding(.top, 2)
                      }
                      
                      Menu{
                          ForEach(0...10, id:\.self){ rooms in
                              Button(action: {
                                self.livingRooms = rooms
                              }, label: {
                                  switch rooms{
                                  case 0:
                                      Text("0 Room")
                                  case 1:
                                      Text("\(rooms) Room")
                                  case 2...:
                                      Text("\(rooms) Rooms")
                                  default:
                                      Text("\(rooms) Rooms")
                                  
                                  }
                              })
                          }
                      } label : {
                          VStack{
                              Image("sofa")
                                  .resizable()
                                  .scaledToFill()
                                  .frame(width: 30, height: 10)
                                  .padding(.top, 8)

                              HStack(spacing: 2){
                                  Image(systemName: "chevron.down")
                                Text("\(self.livingRooms ) Rooms")
                                      .foregroundColor(.white)
                                      .font(.system(size: 14, weight: .semibold))

                              }
                          }.foregroundColor(.white)
                          .frame(width: 85, height: 48)
                          .background(customBurgundyColor)
                          .cornerRadius(8)
                          .padding(.top, 2)
                      }
                      
                      Menu{
                          ForEach((50...2000).filter{$0.isMultiple(of: 10)}, id:\.self){ spaces in
                              Button(action: {
                                self.spaces = spaces
                              }, label: {
                                  switch spaces{
                                  case 0:
                                      Text("0 M2")
                                  case 1:
                                      Text("\(spaces) M2")
                                  case 2...:
                                      Text("\(spaces) M2")
                                  default:
                                      Text("\(spaces) M2")
                                  
                                  }
                              })
                          }
                      } label : {
                          
                          
                      VStack{
                          Image("space")
                              .resizable()
                              .scaledToFill()
                              .frame(width: 23, height: 8)
                              .padding(.top, 8)

                          HStack(spacing: 2){
                              Image(systemName: "chevron.down")
                            Text("\(self.spaces) M2")
                                  .foregroundColor(.white)
                                  .font(.system(size: 14, weight: .semibold))

                          }
                      }.foregroundColor(.white)
                      .frame(width: 85, height: 48)
                      .background(customForestGreenColor)
                      .cornerRadius(8)
                      .padding(.top, 2)
                  }
              }
                  
                  HStack(spacing : 7){
                      
                      
                      
                      Menu{
                          ForEach(0...10, id:\.self){ ovens in
                              Button(action: {
                                self.ovens = ovens
                              }, label: {
                                  switch ovens{
                                  case 0:
                                      Text("0 Ovens")
                                  case 1:
                                      Text("\(ovens) Ovens")
                                  case 2...:
                                      Text("\(ovens) Ovens")
                                  default:
                                      Text("\(ovens) Ovens")
                                  
                                  }
                              })
                          }
                      } label : {
                          
                          
                      VStack{
                          Image("ovens")
                              .resizable()
                              .scaledToFill()
                              .frame(width: 23, height: 8)
                              .padding(.top, 8)


                          HStack(spacing: 2){
                              Image(systemName: "chevron.down")
                            Text("\(self.ovens) Ovens")
                                  .foregroundColor(.white)
                                  .font(.system(size: 14, weight: .semibold))

                          }
                      }.foregroundColor(.white)
                      .frame(width: 85, height: 48)
                      .background(customRichPurpleColor)
                      .cornerRadius(8)
                      .padding(.top, 2)
                  }
                      
          
                      Menu{
                          ForEach(0...10, id:\.self){ fridges in
                              Button(action: {
                                self.fridges = fridges
                              }, label: {
                                  switch fridges{
                                  case 0:
                                      Text("0 Fridges")
                                  case 1:
                                      Text("\(fridges) Fridges")
                                  case 2...:
                                      Text("\(fridges) Fridges")
                                  default:
                                      Text("\(fridges) Fridges")
                                  
                                  }
                              })
                          }
                      } label : {
                          
                          
                      VStack{
                          Image("fridges")
                              .resizable()
                              .scaledToFill()
                              .frame(width: 25, height: 8)
                              .padding(.top, 8)
                          
                          HStack(spacing: 2){
                              Image(systemName: "chevron.down")
                            Text("\(self.fridges) Fridges")
                                  .foregroundColor(.white)
                                  .font(.system(size: 14, weight: .semibold))

                          }
                      }.foregroundColor(.white)
                      .frame(width: 85, height: 48)
                      .background(customTerracottaOrangeColor)
                      .cornerRadius(8)
                      .padding(.top, 2)


                  }
                              
              
                      
                      Menu{
                          ForEach(0...10, id:\.self){ microwaves in
                              Button(action: {
                                self.microwaves = microwaves
                              }, label: {
                                  switch microwaves{
                                  case 0:
                                      Text("0 Micro")
                                  case 1:
                                      Text("\(microwaves) Micro")
                                  case 2...:
                                      Text("\(microwaves) Micro")
                                  default:
                                      Text("\(microwaves) Micro")
                                  
                                  }
                              })
                          }
                      } label : {
                          
                          
                      VStack{
                          Image("micro")
                              .resizable()
                              .scaledToFill()
                              .frame(width: 23, height: 8)
                              .padding(.top, 8)

                          HStack(spacing: 2){
                              Image(systemName: "chevron.down")
                            Text("\(self.microwaves) Microwaves")
                                  .foregroundColor(.white)
                                  .font(.system(size: 14, weight: .semibold))
                          }
                      }.foregroundColor(.white)
                      .frame(width: 85, height: 48)
                      .background(customSubtlePinkColor)
                      .cornerRadius(8)
                      .padding(.top, 2)


                      }
                      
                      
                      
                      Menu{
                          ForEach(0...10, id:\.self){ airConditions in
                              Button(action: {
                                self.airConditions = airConditions
                              }, label: {
                                  switch airConditions {
                                  case 0:
                                      Text("0 A/C")
                                  case 1:
                                      Text("\(airConditions) A/C")
                                  case 2...:
                                      Text("\(airConditions) A/C")
                                  default:
                                      Text("\(airConditions) A/C")
                                  
                                  }
                              })
                          }
                      } label : {
                          
                          
                      VStack{
                          Image("AC")
                              .resizable()
                              .scaledToFill()
                              .frame(width: 25, height: 8)
                              .padding(.top, 8)

                          HStack(spacing: 2){
                              Image(systemName: "chevron.down")
                            Text("\(self.airConditions) A/C")
                                  .foregroundColor(.white)
                                  .font(.system(size: 14, weight: .semibold))

                          }
                      }.foregroundColor(.white)
                      .frame(width: 85, height: 48)
                      .background(customSteelGrayColor)
                      .cornerRadius(8)
                      .padding(.top, 2)
                  }
                      

              }

              
              }
            .padding(.horizontal, 8)
        }
        
     
    }
    
    struct AmenityView: View {
        @Binding var isSmart: Bool
        @Binding var hasWifi: Bool
        @Binding var hasPool: Bool
        @Binding var hasElevator: Bool
        @Binding var hasGym: Bool
        @Binding var age: Int
        
        @EnvironmentObject var firebaseRealEstateManager : FirebaseRealEstateManager
        
        let customBackgroundColor = Color(UIColor(red: 237/255, green: 204/255, blue: 56/255, alpha: 1.0))
        
        let customForestGreenColor = Color(UIColor(red: 34/255, green: 102/255, blue: 68/255, alpha: 1.0))
        var body: some View {
            VStack(alignment: .center){
                  HStack{
                      Text("Amenities").foregroundColor(customBackgroundColor).font(.title)
                      Spacer()
                  }
                  HStack(spacing: 7){
                      
                      Button(action: {
                          isSmart.toggle()
                      }, label: {
                          
                          VStack(spacing: 2){
                              Image("smart")
                                  .resizable()
                                  .scaledToFill()
                                  .frame(width: 43, height: 30)
                              Text("Smart")
                                  .font(.system(size: 14, weight: .semibold))
                                  .padding(.top, 8)
                              Image(systemName: isSmart ? "checkmark.square.fill": "square").foregroundColor(isSmart  ? customForestGreenColor : .white)
                                  .padding(.top, 4)
                          }.frame(width: 60)
                          .foregroundColor(.white)
                      })
                      
                      Divider()
                      
                      Button(action : {
                          hasWifi.toggle()
                      }, label : {
                          
                          VStack(spacing: 2){
                              Image("wifi")
                                  .resizable()
                                  .scaledToFill()
                                  .frame(width: 43, height: 30)
                              Text("WiFi")
                                  .font(.system(size: 14, weight: .semibold))
                                  .padding(.top, 8)
                              Image(systemName: hasWifi == true ? "checkmark.square.fill": "square").foregroundColor(hasWifi ? customForestGreenColor : .white)
                                  .padding(.top, 4)
                          }.frame(width: 60)
                          .foregroundColor(.white)
                      })
                      
                      Divider()
                      
                      Button(action: {
                          hasPool.toggle()
                      }, label :{
                          
                          VStack(spacing: 2){
                              Image("pool")
                                  .resizable()
                                  .scaledToFill()
                                  .frame(width: 43, height: 35)
                              
                              Text("Pool")
                                  .font(.system(size: 14, weight: .semibold))
                                  .padding(.top, 8)
                              Image(systemName: hasPool ? "checkmark.square.fill": "square").foregroundColor(hasPool == true ? customForestGreenColor : .white)
                                  .padding(.top, 4)
                          }.frame(width: 60)
                          .foregroundColor(.white)
                      })
                      
                      
                      Divider()
                      
                      Button(action : {
                          hasElevator.toggle()
                      }, label : {
                          
                          VStack(spacing: 2){
                              Image("elevator")
                                  .resizable()
                                  .scaledToFill()
                                  .frame(width: 43, height: 20)
                                  .offset(y: 9)
                              Text("Elevator")
                                  .font(.system(size: 14, weight: .semibold))
                                  .padding(.top, 25)
                              Image(systemName: hasElevator ? "checkmark.square.fill": "square").foregroundColor(hasElevator ? customForestGreenColor : .white)
                                  .padding(.top, 3)
                          }.frame(width: 60)
                          .foregroundColor(.white)
                      })
                      
                      Divider()
                      
                      Button(action: {
                          hasGym.toggle()
                      }, label : {
                          
                          VStack(spacing: 2){
                              Image("gym")
                                  .resizable()
                                  .scaledToFill()
                                  .frame(width: 43, height: 30)
                                  .offset(y: 9)
                              Text("Gym")
                                  .font(.system(size: 14, weight: .semibold))
                                  .padding(.top, 15)
                              Image(systemName: hasGym ? "checkmark.square.fill": "square")
                                  .foregroundColor(hasGym  ? customForestGreenColor : .white)
                                  .padding(.top, 4)
                          }.frame(width: 60)
                          .foregroundColor(.white)
                      })
                  }
                  
                  
                  HStack{
                      RoundedRectangle(cornerRadius: 12)
                          .fill(Color.gray.opacity(0.5))
                          .frame(maxWidth: .infinity)
                          .frame(height: 1)
                      
                      Menu{
                          ForEach(0...10, id :\.self){ age in
                              Button(action: {
                                self.age = age
                              },label: {
                                  switch age {
                                  case 0:
                                      Text("\(age) Year")
                                  case 1:
                                      Text("\(age) Year")
                                  case 2...:
                                      Text("\(age) Years")
                                  default:
                                      Text("\(age) Years")
                                  
                                  }
                              })
                          }
                      } label : {
                          VStack(spacing: 2){
                              Image("age")
                                  .resizable()
                                  .scaledToFill()
                                  .frame(width: 53, height: 30)
                              HStack(spacing: 4){
                                  Image(systemName: "chevron.down")
                                Text("\(self.age == 1 ? "Year" : "Years")")
                                      .font(.system(size: 14, weight: .semibold))
                                      
                              }.padding(.top, 12)
          
                          }.padding(.horizontal, 10)
                      }.foregroundColor(.white)
                      .padding(.top, 8)
                      
                      RoundedRectangle(cornerRadius: 12)
                          .fill(Color.gray.opacity(0.5))
                          .frame(maxWidth: .infinity)
                          .frame(height: 1)
                      
                  }.padding(.top, 16)
              }
            .padding(.horizontal, 8)
        }
    }
    

    
}

struct MapFilterView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(FirebaseUserManager())
            .environmentObject(FirebaseRealEstateManager())
            .preferredColorScheme(.dark)
    }
}
