//
//  UpdateUserNameView.swift
//  iGoldProperty
//
//  Created by Mariem Derbali on 11/1/23.
//

import SwiftUI

struct UpdateUserNameView: View {
    @EnvironmentObject var firebaseUserManager: FirebaseUserManager
    
    @State private var userName: String = ""
    @State private var isLoading: Bool = false
    @State private var showAlert: Bool = false
    @Environment(\.presentationMode) private var presentationMode
    @State private var alertMessage: String = ""
    let customBackgroundColor = Color(UIColor(red: 237/255, green: 204/255, blue: 56/255, alpha: 1.0))

    
    func showAlert(_ message: String) {
        showAlert = true
        alertMessage = message
    }

    var body: some View {
        VStack {
            TextField("Enter username", text: $userName)
                .modifier(AuthTextFieldModifier())

            Button(action: {
                let firstCharacter = userName.prefix(1)
                  let alphanumericCharacterSet = CharacterSet.letters

                  if userName.isEmpty {
                      showAlert("Username cannot be empty.")
                  } else if firstCharacter == " " {
                      showAlert("Invalid Username Format. Please ensure your username does not start with spaces.")
                  } else if userName.rangeOfCharacter(from: alphanumericCharacterSet.inverted) != nil {
                      showAlert("Invalid Username Format. Please ensure your username contains only letters.")
                  } else {
                     isLoading.toggle()
                    let documentID = firebaseUserManager.user.id
                    firebaseUserManager.updateUserName(username: userName, documentID: documentID) { isSuccess in
                        isLoading.toggle()
                        if isSuccess {
                            presentationMode.wrappedValue.dismiss()
                            print("Username updated successfully")
                        } else {
                            print("Failed to update username")
                        }
                    }
                }
            }, label: {
                Text("Save changes")
            })
            .padding()
            .foregroundColor(Color(UIColor.black))
            .frame(width: 250, height: 50)
            .background(customBackgroundColor.cornerRadius(7))
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }

        .overlay(
            ZStack {
                Color.black.opacity(0.4).ignoresSafeArea()
                VStack(spacing: 20) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle()).accentColor(Color.white)
                        .scaleEffect(2)
                    Text("Please wait...")
                }
            }
            .isHidden(isLoading, remove: isLoading)
        )
    }
}


struct UpdateUserNameView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateUserNameView()
            .preferredColorScheme(.dark)
            .environmentObject(FirebaseUserManager())
     }
}
