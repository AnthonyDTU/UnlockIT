//
//  ChangePasswordOnFirstLoginView.swift
//  UnlockIT
//
//  Created by Anton Lage on 06/03/2023.
//

import SwiftUI

struct ChangePasswordOnFirstLoginView: View {
    
    @EnvironmentObject private var appStyle : AppStyle
    @EnvironmentObject private var user: User
    @Environment(\.dismiss) var dismiss
    
    @State private var newPassword: String = ""
    @State private var confirmNewPassword: String = ""
    @State private var passwordNotMathing = false;
    @State private var errorMessage: String = "Error"
    @State private var showErrorMessageAlert : Bool = false
    
    var body: some View {
            VStack {
                Spacer()
                Image("UnlockItLogo.png")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(appStyle.cornerRadiusLarge)
                    .padding()

                Form {
                    Section (header: Text("Password", comment: "Section title for password entry, when changing the users password on first login").fontWeight(.semibold)){
                        
                        SecureField(String(localized: "New Password", comment: "Placeholder for password entry secure text field in ChangePasswordOnFirstLoginView"), text: $newPassword)
                            .accessibilityIdentifier("NewPasswordSecureEntry")
                        
                        SecureField(String(localized: "Confirm Password", comment: "Placeholder for confirm password entry secure text field in ChangePasswordOnFirstLoginView"), text: $confirmNewPassword)
                            .accessibilityIdentifier("ConfirmNewPasswordSecureEntry")
                    }
                }
                .frame(height: 150)

                HStack {
                    Button {
                        Task {
                            // Update password
                            guard newPassword == confirmNewPassword else {
                                errorMessage = String(localized: "Different passwords", comment: "Error Message");
                                showErrorMessageAlert = true;
                                return
                            }
                            
                            let firebaseUserController = FirebaseUserController()
                            do {
                                try await firebaseUserController.UpdateUserPassword(user: user, newPassword: newPassword)
                                dismiss()
                            }
                            catch {
                                errorMessage = String(localized: "Something whent wrong when updating your password in Firebase", comment: "Error Message")
                                showErrorMessageAlert = true
                                print(error)
                            }
                        }
                    }
                    label: {
                        HStack {
                            Spacer()
                            Text("Update Password")
                            Spacer()
                        }
                    }
                    .accessibilityIdentifier("PerformChangePasswordButton")
                    .foregroundColor(.white)
                    .padding(15)
                    .background(Color.accentColor)
                    .cornerRadius(appStyle.cornerRadiusSmall)
                    .alert(isPresented: $showErrorMessageAlert) {
                        Alert(title: Text(errorMessage))
                    }
                }
                .padding()
                Spacer()


            }
        }
}

struct ChangePasswordOnFirstLoginView_Previews: PreviewProvider {
    @State static var showChangePasswordView = true
    static var previews: some View {
        ChangePasswordOnFirstLoginView()
    }
}
