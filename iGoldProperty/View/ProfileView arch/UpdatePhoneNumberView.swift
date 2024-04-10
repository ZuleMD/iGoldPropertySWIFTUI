//
//  UpdatePhoneNumberView.swift
//  iGoldProperty
//
//  Created by Mariem Derbali on 11/1/23.
//

import SwiftUI

struct UpdatePhoneNumberView: View {
    @EnvironmentObject var firebaseUserManager: FirebaseUserManager
 
    @State var phoneNumber: String = ""
    @State var isLoading: Bool = false
    @Environment(\.presentationMode) private var presentationMode
    let customBackgroundColor = Color(UIColor(red: 237/255, green: 204/255, blue: 56/255, alpha: 1.0))

    
    var body: some View {
        VStack{
            
            TextField("Enter phone number", text: $phoneNumber)
                
            .modifier(AuthTextFieldModifier())
            
             Button(action: {
                firebaseUserManager.updatePhoneNumber(phoneNumber : phoneNumber) { isSuccess in
                    if isSuccess {
                            isLoading.toggle()
                            presentationMode.wrappedValue.dismiss()
                        print("Phone Number updated successfully")
                    } else {
                        isLoading.toggle()
                        print("Failed to update Phone Number")
                    }


                }
            }, label: {
            Text("Save changes")
            })
            .padding()
            .foregroundColor(Color(UIColor.black))
            .frame(width: 250, height: 50)
             .background(customBackgroundColor.cornerRadius(7))
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
        )
        
    }
}
struct UpdatePhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        UpdatePhoneNumberView()
            .preferredColorScheme(.dark)
            .environmentObject(FirebaseUserManager())
    }
}
