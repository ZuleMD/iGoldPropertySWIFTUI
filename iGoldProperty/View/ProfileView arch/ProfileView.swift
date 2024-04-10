//
//  ProfileView.swift
//  iGoldProperty
//
//  Created by Mariem Derbali on 10/31/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @EnvironmentObject var firebaseUserManager: FirebaseUserManager
    @State var isLoading: Bool = false
    @Environment(\.presentationMode) private var presentationMode
    @State var profileImage: UIImage?
    @State var displayedProfileImage: Image?
    @State var isImagePickerPresented: Bool = false
    @State var isShowingAuthView: Bool = false
    
    let customDeepBlueColor = Color(UIColor(red: 29/255, green: 50/255, blue: 90/255, alpha: 1.0))
    let customForestGreenColor = Color(UIColor(red: 34/255, green: 102/255, blue: 68/255, alpha: 1.0))
    let customTerracottaOrangeColor = Color(UIColor(red: 204/255, green: 93/255, blue: 85/255, alpha: 1.0))



    var body: some View {
        NavigationView {
            Form {
                Section{
                    HStack{
                        Spacer()
                        Button(action: {
                            isImagePickerPresented.toggle()

                        }) {
                            WebImage(url: URL(string: firebaseUserManager.user.profileImageUrl))
                                .resizable()
                                .placeholder {
                                    Rectangle().foregroundColor(.gray)
                                }
                                .indicator(.activity)
                                .transition(.fade)
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .padding(4)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 0.4)
                                )
                                .overlay(
                                    Image(systemName: "pencil.and.outline")
                                        .foregroundColor(.blue)
                                        .padding(5)
                                    , alignment: .bottomTrailing
                                )
                        } .sheet(isPresented: $isImagePickerPresented) {
                            ImagePicker(sourceType: .photoLibrary) { pickedImage in
                               
                                isLoading = true
                                firebaseUserManager.updateProfileImage(image: pickedImage) { success in
                                    isLoading = false
                                 }
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())

                        Spacer()
                           
                    }.listRowBackground(Color.clear)
                }
                
    
                Section(header: Text("Account Info"), footer: Text("You can update your account")) {
                    HStack(spacing: 8) {
                        Image(systemName: "envelope")
                        Text(firebaseUserManager.user.email)
                    }

                    NavigationLink(destination: UpdateUserNameView()){
                            HStack(spacing: 8) {
                                Image(systemName: "person")
                                Text(firebaseUserManager.user.username)
                            }
                    
                    }

                    NavigationLink(destination: UpdatePhoneNumberView()) {
                            HStack(spacing: 8) {
                                Image(systemName: "phone")
                                Text(firebaseUserManager.user.phoneNumber)
                            }
                      
                    }
                }.onAppear {
                    firebaseUserManager.fetchUser()
                }
                
                Section(footer: Text("You can manage your properties at anytime, when you sell, rent and/or invest")){
                    
                    NavigationLink(destination: MyRealEstatesView()) {
                            HStack(spacing: 8) {
                                Image(systemName: "building")
                                Text("My Real Estates")
                            }
                    
                    }
                    
                }
                
                Section(header: Text("Bookmarks") ,footer: Text("Visit Real Estate you have booked")){
                    
                    NavigationLink(destination: BookMarkedRealEstateView()) {
                            HStack(spacing: 8) {
                                Image(systemName: "bookmark")
                                Text("Saved my Real Estates")
                            }
                    
                    }
                    
                }
                
                Section(header: Text("Simple View") ,footer: Text("When people visit your properties, your contact info will be displayed as it shown")){
                    
                
                    VStack{
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
                        Spacer()
                    VStack{
                        
                        HStack{
                            
                                 Button(action: {
                                  
                                 }) {
                                     HStack{
                                         Image(systemName: "envelope")
                                         Text("Email")
                                     }
                                         
                                       .foregroundColor(Color.white)
                                         .frame(width: 100, height: 32)
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
                                     .frame(width: 135, height: 32)
                                 .background(customForestGreenColor)
                                 .cornerRadius(5)

                                 
                             }
                            
                        }
                     Spacer()
                        
                            Button(action: {
                             
                            }) {
                                HStack{
                                    Image(systemName: "phone")
                                    Text(firebaseUserManager.user.phoneNumber)
                                }
                                    
                                  .foregroundColor(Color.white)
                                    .frame(width: 243, height: 32)
                                .background(customDeepBlueColor)
                                .cornerRadius(5)
                                
                                
                                
                            }.offset(y: -8)
                        }
                         
                    }
                    
                }
                    
                    ForEach(firebaseUserManager.user.dayTimeAvailability.indices, id: \.self) { index in
                        let dayTime = firebaseUserManager.user.dayTimeAvailability[index]
                        HStack {
                            Text(dayTime.day.title)
                            DatePicker("", selection: $firebaseUserManager.user.dayTimeAvailability[index].fromTime, displayedComponents: .hourAndMinute) .colorScheme(.light)
 
                            Text("-")
                                .padding(.leading, 12)
                            DatePicker("", selection: $firebaseUserManager.user.dayTimeAvailability[index].toTime, displayedComponents: .hourAndMinute)
                                .frame(width: 100)
                                .colorScheme(.light)
                         }
                    }
                    
                    Divider()
                    
                    Button(action: {
                        print(firebaseUserManager.user.dayTimeAvailability.map({$0.fromTime.convertDate(formattedString: .timeOnly)}))
                        
                        print(firebaseUserManager.user.dayTimeAvailability.map({$0.toTime.convertDate(formattedString: .timeOnly)}))
                        isLoading.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4){
                            firebaseUserManager.updateDayTimeAvailability()
                            isLoading.toggle()
                        }
                        
                    }) {
                        HStack{
                            Spacer()
                            Text("Update Schedule")
                            Spacer()
                        }
                        .padding(10)
                        .foregroundColor(Color(UIColor.black))
                        .background(Color(#colorLiteral(red: 0.9294117647, green: 0.7921568627, blue: 0.2196078431, alpha: 1)).cornerRadius(7))
                         
                    }

              }
                
                Section {
                    Button(action: {
                        isLoading.toggle()
                        firebaseUserManager.logOut { isSuccess in
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                                if isSuccess{
                                    isLoading.toggle()
                                    presentationMode.wrappedValue.dismiss()
                                }else {
                                    isLoading.toggle()

                                }
                            }
                            
                        }
                        if !firebaseUserManager.isAuthenticated {
                            isShowingAuthView.toggle()}
                    }) {
                        HStack{
                            Spacer()
                            Text("Logout")
                                .foregroundColor(Color(#colorLiteral(red: 0.6156862745, green: 0.2431372549, blue: 0.2431372549, alpha: 1)))
                            Spacer()
                        }
                    }
                }

                 
            }
            .navigationTitle("Profile")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Dismiss")
                    }
                }
            }

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
        .preferredColorScheme(.dark)
        .fullScreenCover(isPresented: $isShowingAuthView){
            AuthView()
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

}



struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
     
        Group {
            ProfileView()
                .environmentObject(FirebaseUserManager())
 
        }
 
    }
}


extension Date {
    /// To convert a date to specific type
    func convertDate(formattedString: DateFormattedType) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = formattedString.rawValue
        return formatter.string(from: self)
    }
    /// To print 1s ago , 4d ago, 1month ago
    func convertToTimeAgo(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth, .month, .year]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = style
        let now = Date()
        return formatter.string(from: self, to: now) ?? ""
    }
    
    func convertToTimeWill(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth, .month, .year]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = style
        let now = Date()
        return formatter.string(from: now, to: self) ?? ""
    }
    
    func interval(ofComponent comp: Calendar.Component, from date: Date) -> Float {
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0.0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0.0 }
        return Float(start - end)
    }
    
}



enum DateFormattedType: String, CaseIterable {
    /// Date sample  Sunday, Sep 6, 2020
    case formattedType1 = "EEEE, MMM d, yyyy"
    /// Date sample  09/24/2020
    case formattedType2 = "MM/dd/yyyy"
    /// Date sample  09-06-2020 02:45 AM
    case formattedType3 = "MM-dd-yyyy h:mm a"
    /// Date sample  Sep 6, 2:45 AM
    case formattedType4 = "MMM d, h:mm a"
    /// Date sample  02:45:07.397
    case formattedType5 = "HH:mm:ss.SSS"
    /// Date sample  02:45:07.397
    case formattedType6 = "dd.MM.yy"
    /// Date sample  Sep 6, 2020
    case formattedType7 = "MMM d, yyyy"
    /// Time sample  24/05/2020 ● 9:24:22 PM
    case formattedType8 = "dd/MM/yyyy • h:mm:ss a"
    /// Time sample  Fri23/Oct/2020
    case formattedType9 = "E d/MMM/yyy"
    /// Thu, 22 Oct 2020 5:56:22 pm
    case formattedType10 = "E, d MMM yyyy h:mm:ss a"
    /// Date sample for Month only JUNE
    case formattedType11 = "MMMM"
    /// Date sample for Day in Number only 04
    case formattedType12 = "dd"
    /// to get seconds only
    case formattedType13 = "ss"
    /// time only 9:24:22 PM
    case timeOnly = "h:mm a"
    /// Date sample Monday
    case dateDayOnly = "EEEE"
}

