//
//  AuthView.swift
//  iGoldProperty
//
//  Created by Mariem Derbali on 10/17/23.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestoreSwift

struct AuthView: View {
    @State var isNewUser: Bool = false
    @State var email: String = ""
    @State var password: String = ""
    @State var username: String = ""
    @State var profileImage: UIImage?
    @State var displayedProfileImage: Image?
    @State var isImagePickerPresented: Bool = false
    
    @EnvironmentObject var firebaseUserManager : FirebaseUserManager
    @Environment(\.presentationMode) private var presentationMode

    
    @State var isLoading: Bool = false
    @State var isShowingHomeView: Bool = false
    
    @State var isAlertPresented: Bool = false
    @State var alertMessage: String = ""
    @StateObject var locationManager = LocationManager()
    let customBackgroundColor = Color(UIColor(red: 237/255, green: 204/255, blue: 56/255, alpha: 1.0))


    var body: some View {
            NavigationView{
            ScrollView{
                HStack{
                    Text("Welcome to\niGoldProperty")
                        .font(.system(size: 30, weight: .semibold))
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)

                    Spacer()
                    
                }.padding(.horizontal , 8)
                .padding(.top,-44)
                
                Picker(selection: $isNewUser, label: Text("Account Type")) {
                    Text("Login").tag(false)
                    Text("Create Account").tag(true)
                }.pickerStyle(SegmentedPickerStyle())
               
                Button(action: {
                    isImagePickerPresented.toggle()
                }) {
                    if displayedProfileImage != nil {
                        displayedProfileImage!
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle()).padding(2)
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 0.4))
                    } else {
                        Image("user")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle()).padding(2)
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 0.4))
                    }
                }.sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(sourceType: .photoLibrary) { pickedImage in
                        profileImage = pickedImage
                        displayedProfileImage = Image(uiImage: pickedImage)
                    }
                }
                .isHidden(isNewUser, remove: isNewUser)
                             
                
                TextField("Username", text: $username)
                    .modifier(AuthTextFieldModifier())
                    .isHidden(isNewUser, remove: isNewUser)
                
                TextField("Email", text: $email)
                    .modifier(AuthTextFieldModifier())
                
                SecureField("Password", text: $password)
                    .modifier(AuthTextFieldModifier())
                
                Button {
                    isLoading.toggle()
                    guard let location = locationManager.userLocation?.coordinate else {
                        return
                    }
                    if isNewUser {
                        guard !username.isEmpty else {
                            isAlertPresented = true
                            alertMessage = "Username is required."
                            return
                        }

                        let alphanumericCharacterSet = CharacterSet.letters
                        let firstCharacter = username.prefix(1)

                        guard firstCharacter != " " && username.rangeOfCharacter(from: alphanumericCharacterSet.inverted) == nil else {
                            isAlertPresented = true
                            alertMessage = "Username must contain only letters and cannot start with spaces."
                            return
                        }
                        
                        guard !email.isEmpty else {
                            isAlertPresented = true
                            alertMessage = "Failed to create an account. Email is required."
                    
                            return
                        }
                        guard !password.isEmpty else {
                            isAlertPresented = true
                            alertMessage = "Failed to create an account. Password is required."
                    
                            return
                        }
                    }else{
                        
                        guard !email.isEmpty else {
                            isAlertPresented = true
                            alertMessage = "Failed to log in. Email is required."
                    
                            return
                        }
                        guard !password.isEmpty else {
                            isAlertPresented = true
                            alertMessage = "Failed to log in. Password is required."
                    
                            return
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                        if isNewUser {
                            firebaseUserManager.createNewUser(email: email, password: password, username: username, profileImage: profileImage, location: location) { isSuccess in
                                
                                if isSuccess{
                                    isLoading.toggle()
                                    isShowingHomeView.toggle()

                                }else{
                                    isAlertPresented = true
                                    alertMessage = "Failed to create an account. Please check your credentials."
                                }
                   
                            }
                        }else{
                            firebaseUserManager.logUserIn(email: email, password: password) { isSuccess in
                                if isSuccess{
                                    isLoading.toggle()
                                    isShowingHomeView.toggle()

                                }else{
                                    isAlertPresented = true
                                    alertMessage = "Failed to log in. Please check your credentials."
                                }
                                
                            }
                        }
                    }
        
                } label: {
                    Text(isNewUser ? "Create Account" : "Login")
                        .foregroundColor(Color(UIColor.black))
                        .frame(width: 250, height: 50)
                        .background(customBackgroundColor.cornerRadius(7))
                    
                }
              

                
                
            }.alert(isPresented: $isAlertPresented) {
                Alert(
                    title: Text("Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(
                        Text("OK"),
                        action: {
                            isLoading.toggle()
                        }
                    )
                )
            }
            .animation(.linear, value : isNewUser)
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Button{
                        presentationMode.wrappedValue.dismiss()
                        
                    }label: {
                        Text("Dismiss")
                    }
                }
            }
            
        }.overlay(
            ZStack{
                Color.black.opacity(0.4).ignoresSafeArea()
                VStack(spacing: 20){
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle()).accentColor(Color.white)
                        .scaleEffect(2)
                    Text("Please wait...")
                }
            }.isHidden(isLoading, remove: isLoading)
        ).fullScreenCover(isPresented: $isShowingHomeView) {
            if firebaseUserManager.isAuthenticated {
          
                HomeView()
            } else {
                 AuthView()
            }

        }.preferredColorScheme(.dark)

    }
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


extension View {
    
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false)-> some View {
        if hidden {
            if !remove {
                self.hidden()
            }else{
                self
            }
        }
    }
}

struct AuthTextFieldModifier: ViewModifier {
    func body(content: Content)-> some View {
        content
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.white, lineWidth: 0.7)
            ).padding()
        
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AuthView()
                .environmentObject(FirebaseUserManager())
 
        }
    }
}



