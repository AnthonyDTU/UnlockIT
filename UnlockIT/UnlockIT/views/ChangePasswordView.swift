//
//  ChangePasswordView.swift
//  UnlockIT
//
//  Created by Anton Lage on 13/03/2023.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var showChangePasswordView: Bool
    
    @EnvironmentObject private var appStyle : AppStyle
    @EnvironmentObject private var user : User
    
    @State private var newPassword: String = ""
    @State private var confirmNewPassword: String = ""
    
    @State private var showPasswordErrorPrompt = false
    
    var body: some View {
        VStack {
            Spacer()
            Image("UnlockItLogo.png")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(appStyle.cornerRadiusLarge)
                .padding()
            
            Form {
                Section (header: Text("New Password").fontWeight(.semibold)){
                    SecureField("New Password", text: $newPassword)
                    SecureField("Confirm New Password", text: $confirmNewPassword)
                }
            }
            .frame(height: 150)
            
            HStack {
                Button {
                    Task {
                        // Update password
                        guard newPassword == confirmNewPassword else { showPasswordErrorPrompt = true; return }
                        let firebaseController = FirebaseController()
    
                        do {
                            try await firebaseController.UpdateUserPassword(user: user, newPassword: newPassword)
                            showChangePasswordView = false
                            dismiss()
                        }
                        catch {
                            showPasswordErrorPrompt = true
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
                .foregroundColor(.white)
                .padding(15)
                .background(Color.accentColor)
                .cornerRadius(appStyle.cornerRadiusSmall)
                .alert(isPresented: $showPasswordErrorPrompt) {
                    Alert(title: Text("Error while updating the password"))
                }
            }
            .padding()
            Spacer()
            
            
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    @StateObject static var appStyle = AppStyle()
    @State static var showView = false
    static var previews: some View {
        ChangePasswordView(showChangePasswordView: $showView).environmentObject(appStyle)
    }
}
