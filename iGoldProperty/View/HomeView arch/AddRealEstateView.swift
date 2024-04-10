//
//  AddRealEstateView.swift
//  iGoldProperty
//
//  Created by Mariem Derbali on 12/3/2

import SwiftUI
import PhotosUI
import AVKit
import MapKit
import SDWebImageSwiftUI


struct AddRealEstateView: View {
    
    @StateObject var viewModel = AddRealEstateViewModel()
    @Environment(\.presentationMode) private var presentationMode
    @State private var selectedImages: [UIImage] = []
    @State var isImagePickerPresented: Bool = false
    @State private var selectedImage: UIImage? = nil
    @State private var isVideoPickerPresented: Bool = false
    
    @State var dayTimeSelection: [DayTimeSelection] = [
        .init(day: .monday, fromTime: Date(), toTime: Date()),
        .init(day: .tuesday, fromTime: Date(), toTime: Date()),
        .init(day: .wednesday, fromTime: Date(), toTime: Date()),
        .init(day: .thursday, fromTime: Date(), toTime: Date()),
        .init(day: .friday, fromTime: Date(), toTime: Date()),
        .init(day: .saturday, fromTime: Date(), toTime: Date()),
        .init(day: .sunday, fromTime: Date(), toTime: Date()),
    ]
    @EnvironmentObject var firebaseUserManager: FirebaseUserManager
    
    
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
    
    @Binding var isShowingAddingRealEstateView: Bool
    


    var body: some View {
     NavigationView{
            
       ScrollView{
          Group{
                    VStack{
                        HStack{
                            Text("Location")
                                .foregroundColor(customBackgroundColor)

                            Spacer()
                        }

                        HStack{
                            Text("City: ")
                            Spacer()
                            Menu{
                                ForEach(City.allCases, id:\.self){ city in
                                    Button(action: {
                                        viewModel.realEstate.city = city
                                    }, label: {
                                        Text(city.title)
                                    })
                                }
                            } label : {
                                HStack{
                                    Text(viewModel.realEstate.city.title)
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.white)
                                }
                            }
                        }.padding(.horizontal, 4)
                    }.padding(.horizontal, 4)
                    Divider()

                    VStack{
                        HStack{
                            Text("Type")
                                .foregroundColor(customBackgroundColor)

                            Spacer()
                        }

                        HStack{
                            Text("Category: ")
                            Spacer()
                            Menu{
                                ForEach(RealEstateType.allCases, id:\.self){ realEstateType in
                                    Button(action: {
                                        viewModel.realEstate.type = realEstateType
                                    }, label: {
                                        HStack{
                                            Text(realEstateType.title)
                                            Image(realEstateType.imageName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                        }
                                        
                                    })

                                }
                            } label : {
                                HStack{
                                    Text(viewModel.realEstate.type.title)
                                Image(viewModel.realEstate.type.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.white)
                                }
                            }
                        }.padding(.horizontal, 4)
                    }.padding(.horizontal, 4)
                    VStack{
                        HStack{
                            Text("Sale")
                                .foregroundColor(customBackgroundColor)

                            Spacer()
                        }

                        HStack{
                            Text("Offer: ")
                            Spacer()
                            Menu{
                                ForEach(SaleCategory.allCases, id:\.self){ saleCategory in
                                    Button(action: {
                                        viewModel.realEstate.saleCategory = saleCategory
                                    }, label: {
                                        HStack{
                                            Text(saleCategory.title)
                                            Image(saleCategory.imageName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                        }
                                              
                                        
                                    })
                                }
                            } label : {
                                HStack{
                                    Text(viewModel.realEstate.saleCategory.title)
                                    Image(viewModel.realEstate.saleCategory.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.white)
                                }
                            }
                        }.padding(.horizontal, 4)
                    }.padding(.horizontal, 4)
                    VStack{
                        HStack{
                            Text("Duration")
                                .foregroundColor(customBackgroundColor)

                            Spacer()
                        }

                        HStack{
                            Text("Time: ")
                            Spacer()
                            Menu{
                                ForEach(OfferType.allCases, id:\.self){ offerType in
                                    Button(action: {
                                        viewModel.realEstate.offer = offerType
                                    }, label: {
                                        Text(offerType.title)
                                    })
                                }
                            } label : {
                                HStack{
                                    Text(viewModel.realEstate.offer.title)
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.white)
                                }
                            }
                        }.padding(.horizontal, 4)
                    }.padding(.horizontal, 4)
                    VStack{
                        HStack{
                            Text("Price")
                                .foregroundColor(customBackgroundColor)

                            Spacer()
                        }

//                        HStack{
//                            Text("Amount: ")
//                            Spacer()
//                            TextField("0.0", value: $viewModel.realEstate.price, formatter: NumberFormatter())
//                        }.padding(.horizontal, 4)
                        
                        HStack {
                            Text("Amount: ")
                            Spacer()
                            TextField("0.0", text: Binding(
                                get: {
                                    viewModel.realEstate.price.description
                                },
                                set: { newValue in
                                    if let value = Double(newValue) {
                                        viewModel.realEstate.price = Int(value)
                                    }
                                }
                            ))
                        }
                        .padding(.horizontal, 4)

                        
                    }.padding(.horizontal, 4)
                    Divider()

                }

          Group{
                    VStack{
                    HStack{
                        Text("Photos:")
                            .foregroundColor(customBackgroundColor)

                        Spacer()
                    }
                    LazyVGrid(columns: [GridItem.init(.adaptive(minimum: 140))]) {
                        ForEach(selectedImages, id: \.self) { image in
                            VStack {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 180, height: 180)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))

                                Button(action: {
                                    // Remove selected image
                                    withAnimation(.spring()){
                                        if let index = selectedImages.firstIndex(of: image) {
                                            selectedImages.remove(at: index)
                                        }
                                    }
                                }) {
                                    Label("Delete", systemImage: "trash")
                                        .foregroundColor(.red)
                                        .frame(width: 160, height: 40)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.red, lineWidth: 0.8)
                                        )
                                }
                                .padding(.vertical, 8)
                            }
                        }

                                    Button(action: {
                                        isImagePickerPresented.toggle()
                                    }) {

                                        VStack{
                                            VStack {
                                                Image(systemName: selectedImages.isEmpty ? "icloud.and.arrow.up" : "plus")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 40, height: 40)


                                                Label(selectedImages.isEmpty ? "Upload" : "Add More", systemImage: "photo")

                                            }
                                            .frame(width: 180, height: 180)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12).strokeBorder(style: StrokeStyle(lineWidth: 2 , dash: [10]))
                                            )
                                            RoundedRectangle(cornerRadius: 0)
                                                .fill(Color.clear)
                                                .frame(width: 160, height: 40)
                                        }

                                    }
                                    .sheet(isPresented: $isImagePickerPresented) {
                                        ImagePicker(sourceType: .photoLibrary) { pickedImage in
                                            selectedImages.append(pickedImage)
                                        }
                                    }
                                }.padding(.horizontal, 4)
                }.padding(.horizontal, 4)
                Divider()

                VStack{
                    HStack{
                        Text("Video:")
                            .foregroundColor(customBackgroundColor)

                        Spacer()
                    }

                    if let videoUrl = viewModel.videoUrl {
                                  VideoPlayer(player: AVPlayer(url: videoUrl))
                                      .frame(width: UIScreen.main.bounds.width - 50, height: 160)
                              }

                    if viewModel.videoUrl != nil {
                        Button(action: {
                            withAnimation(.spring()){
                                viewModel.videoUrl = nil
                            }
                        }) {
                            Label("Delete", systemImage: "trash")
                                .foregroundColor(.red)
                                .frame(width: 160, height: 40)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.red, lineWidth: 0.8)
                                )
                        }
                    }
                    Button(action: {
                        isVideoPickerPresented.toggle()
                    }) {
                        VStack {
                            Image(systemName: "icloud.and.arrow.up")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)

                            Label("Upload", systemImage: "play")
                        }
                        .isHidden(viewModel.videoUrl == nil, remove: viewModel.videoUrl == nil)

                        .frame(width: UIScreen.main.bounds.width - 50, height: 160)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12).strokeBorder(style: StrokeStyle(lineWidth: 2 , dash: [10]))
                        )
                    }
                    .sheet(isPresented: $isVideoPickerPresented) {
                                    VideoPicker { videoUrl in
                                        viewModel.videoUrl = videoUrl
                                    }
                                }


                }.padding(.horizontal, 4)
                Divider()}
                
          VStack(alignment: .center){
                HStack {
                    Text("Appliance").foregroundColor(customBackgroundColor).font(.title)
                    Spacer()
                }
                HStack(spacing : 7){
                    
                    Menu{
                        ForEach(0...10, id:\.self){ beds in
                            Button(action: {
                            viewModel.realEstate.equipment[0].beds = beds
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
                                 Text("\(viewModel.realEstate.equipment[0].beds ) Beds")
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
                                viewModel.realEstate.equipment[0].baths = baths
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
                                Text("\(viewModel.realEstate.equipment[0].baths ) Baths")
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
                                viewModel.realEstate.equipment[0].livingRooms = rooms
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
                                Text("\(viewModel.realEstate.equipment[0].livingRooms ) Rooms")
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
                                viewModel.realEstate.equipment[0].space = spaces
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
                            Text("\(viewModel.realEstate.equipment[0].space) M2")
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
                                viewModel.realEstate.equipment[0].ovens = ovens
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
                            Text("\(viewModel.realEstate.equipment[0].ovens) Ovens")
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
                                viewModel.realEstate.equipment[0].fridges = fridges
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
                            Text("\(viewModel.realEstate.equipment[0].fridges) Fridges")
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
                                viewModel.realEstate.equipment[0].microwaves = microwaves
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
                            Text("\(viewModel.realEstate.equipment[0].microwaves) Microwaves")
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
                                viewModel.realEstate.equipment[0].airConditions = airConditions
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
                            Text("\(viewModel.realEstate.equipment[0].airConditions) A/C")
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

            
            }.padding(.horizontal, 4)
          Divider()
        Group{
          VStack{
                    HStack {
                        Text("Info:").foregroundColor(customBackgroundColor).font(.title)
                        Spacer()
                    }
               
                    TextEditor(text: $viewModel.realEstate.description)
                        .padding()
                        .frame(minHeight: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.white, lineWidth: 0.5)
                        )
                        .overlay(
                            viewModel.realEstate.description.isEmpty ?
                                Text("Enter Description")
                                    .foregroundColor(Color.gray)
                                    .padding(8) : nil
                        )
                        
                   
                    
                }.padding(.horizontal, 4)
                
         Divider()
                
          VStack(alignment: .center){
                HStack{
                    Text("Amenities").foregroundColor(customBackgroundColor).font(.title)
                    Spacer()
                }
                HStack(spacing: 7){
                    
                    Button(action: {
                        viewModel.realEstate.equipment[0].isSmart.toggle()
                    }, label: {
                        
                        VStack(spacing: 2){
                            Image("smart")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 43, height: 30)
                            Text("Smart")
                                .font(.system(size: 14, weight: .semibold))
                                .padding(.top, 8)
                            Image(systemName: viewModel.realEstate.equipment[0].isSmart ? "checkmark.square.fill": "square").foregroundColor(viewModel.realEstate.equipment[0].isSmart  ? customForestGreenColor : .white)
                                .padding(.top, 4)
                        }.frame(width: 60)
                        .foregroundColor(.white)
                    })
                    
                    Divider()
                    
                    Button(action : {
                        viewModel.realEstate.equipment[0].hasWifi.toggle()
                    }, label : {
                        
                        VStack(spacing: 2){
                            Image("wifi")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 43, height: 30)
                            Text("WiFi")
                                .font(.system(size: 14, weight: .semibold))
                                .padding(.top, 8)
                            Image(systemName: viewModel.realEstate.equipment[0].hasWifi == true ? "checkmark.square.fill": "square").foregroundColor(viewModel.realEstate.equipment[0].hasWifi ? customForestGreenColor : .white)
                                .padding(.top, 4)
                        }.frame(width: 60)
                        .foregroundColor(.white)
                    })
                    
                    Divider()
                    
                    Button(action: {
                        viewModel.realEstate.equipment[0].hasPool.toggle()
                    }, label :{
                        
                        VStack(spacing: 2){
                            Image("pool")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 43, height: 35)
                            
                            Text("Pool")
                                .font(.system(size: 14, weight: .semibold))
                                .padding(.top, 8)
                            Image(systemName: viewModel.realEstate.equipment[0].hasPool ? "checkmark.square.fill": "square").foregroundColor(viewModel.realEstate.equipment[0].hasPool == true ? customForestGreenColor : .white)
                                .padding(.top, 4)
                        }.frame(width: 60)
                        .foregroundColor(.white)
                    })
                    
                    
                    Divider()
                    
                    Button(action : {
                        viewModel.realEstate.equipment[0].hasElevator.toggle()
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
                            Image(systemName: viewModel.realEstate.equipment[0].hasElevator ? "checkmark.square.fill": "square").foregroundColor(viewModel.realEstate.equipment[0].hasElevator ? customForestGreenColor : .white)
                                .padding(.top, 3)
                        }.frame(width: 60)
                        .foregroundColor(.white)
                    })
                    
                    Divider()
                    
                    Button(action: {
                        viewModel.realEstate.equipment[0].hasGym.toggle()
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
                            Image(systemName: viewModel.realEstate.equipment[0].hasGym ? "checkmark.square.fill": "square")
                                .foregroundColor(viewModel.realEstate.equipment[0].hasGym  ? customForestGreenColor : .white)
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
                                viewModel.realEstate.age = age
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
                                Text("\(viewModel.realEstate.age) \(viewModel.realEstate.age == 1 ? "Year" : "Years")")
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
            }.padding(.horizontal, 4)
        }
        Group{
            MapUIKitView(realEstate: $viewModel.realEstate)
                .frame(width: UIScreen.main.bounds.width - 50, height: 300)
                .cornerRadius(12)
                .id(self.viewModel.refreshMapViewId)
                .overlay(
                    Image(systemName: "mappin.and.ellipse")
                        .padding(4)
                        .background(Color.red)
                        .clipShape(Circle())
                    ,alignment: .center
                ).onChange(of: viewModel.realEstate.city){ _ in
                    self.viewModel.refreshMapViewId = UUID()
                    viewModel.coordinateRegion.center = viewModel.realEstate.city.coordinate
                    viewModel.coordinateRegion.span = viewModel.realEstate.city.zoomLevel
                    
                }
    Text("Lat: \(viewModel.realEstate.location.latitude) - Long: \(viewModel.realEstate.location.longitude)")
    
    VStack(alignment: .leading, spacing: 10){
        HStack{
            VStack{
                WebImage(url: URL(string: firebaseUserManager.user.profileImageUrl))
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
                Text(firebaseUserManager.user.username)
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
                        Text(firebaseUserManager.user.phoneNumber)
                    }
                        
                      .foregroundColor(Color.white)
                        .frame(width: 300, height: 32)
                    .background(customDeepBlueColor)
                    .cornerRadius(5)
                
                    
                }.padding(.top, 2)
        }
             
        }
        Spacer()
        ForEach(firebaseUserManager.user.dayTimeAvailability, id:\.self){
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
        Group{
        NavigationLink(
            destination: SampleRealEstate(
                realEstate: $viewModel.realEstate,
                images: $selectedImages,
                videoUrl: $viewModel.videoUrl,
                coordinateRegion: $viewModel.coordinateRegion,
                isShowingAddingRealEstateView: $isShowingAddingRealEstateView
            )
        ) {
            Text("Show Sample Before Upload")
                .foregroundColor(Color(UIColor.black))
                .frame(width: 300, height: 48)
                .background(customBackgroundColor.cornerRadius(7))
                .padding()
        }
        
        .padding()
        }
        
            }.environmentObject(viewModel)
            
              .navigationTitle("Add Real Estate")
              .navigationBarTitleDisplayMode(.large)
              .toolbar{
                        ToolbarItem(placement:.navigationBarLeading){
                          Button(action: {
                                presentationMode.wrappedValue.dismiss()
                              },
                        label: {
                               Text("Cancel")
                                })
                            }
                        }
            
                    }.preferredColorScheme(.dark)
    }
 

struct ImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController

    var sourceType: UIImagePickerController.SourceType
    var imagePicked: (UIImage) -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Update the view controller if needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.imagePicked(uiImage)
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}


struct VideoPicker: UIViewControllerRepresentable {
        typealias UIViewControllerType = UIImagePickerController

        var videoPicked: (URL) -> Void

        func makeUIViewController(context: Context) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.mediaTypes = ["public.movie"]
            picker.delegate = context.coordinator
            return picker
        }

        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
            // Update the view controller if needed
        }

        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            let parent: VideoPicker

            init(_ parent: VideoPicker) {
                self.parent = parent
            }

            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
                if let videoUrl = info[.mediaURL] as? URL {
                    parent.videoPicked(videoUrl)
                }
                picker.dismiss(animated: true)
            }

            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                picker.dismiss(animated: true)
            }
        }
    }


}



struct MapUIKitView: UIViewRepresentable {
    @Binding var realEstate: RealEstate
    let mapView = MKMapView()

    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.setRegion(.init(center: realEstate.city.coordinate, span: realEstate.city.zoomLevel), animated: true)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        var parent: MapUIKitView

        init(_ parent: MapUIKitView) {
            self.parent = parent
            super.init()
        }

        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
             self.parent.realEstate.location = mapView.centerCoordinate
        }
    }
}

struct AddRealEstateView_Previews: PreviewProvider {
    static var previews: some View {
        AddRealEstateView(isShowingAddingRealEstateView: .constant(false))
            .environmentObject(FirebaseUserManager())
            .preferredColorScheme(.dark)
    }
}
