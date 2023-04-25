//
//  ChangePasswordOnFirstLoginView.swift
//  UnlockIT
//
//  Created by Anton Lage on 06/03/2023.
//

import SwiftUI

struct ChangePasswordOnFirstLoginView: View {
    @EnvironmentObject private var user: User
    
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @Binding var showChangePasswordView: Bool
    @State private var passwordNotMathing = false;
    
    var body: some View {
        Text("Hello \(user.username)! Since this is you first login, we need you to set a password. Please do so below", comment: "Text telling the user that he/she has to change their password, since it is their first login")
        Form {
            Section(header: Text("Password", comment: "Section title for password entry, when changing the users password on first login").fontWeight(.bold)) {
                SecureField(String(localized: "Password", comment: "Placeholder for password entry secure text field in ChangePasswordOnFirstLoginView"), text: $password)
                SecureField(String(localized: "Confirm Password", comment: "Placeholder for confirm password entry secure text field in ChangePasswordOnFirstLoginView"), text: $confirmPassword)
            }
        }
        .frame(height: 150)
        Button() {
            guard password == confirmPassword else { passwordNotMathing = true; return}
            
        } label: {
            Text("Continue", comment: "Text on button, which continues, when changing password on first login")
        }
        .alert(isPresented: $passwordNotMathing) {
            Alert(title: Text("Passwords does not match", comment: "Error Message"))
        }
        .onDisappear(){
            showChangePasswordView = false
        }
    }
}

struct ChangePasswordOnFirstLoginView_Previews: PreviewProvider {
    @State static var showChangePasswordView = true
    static var previews: some View {
        ChangePasswordOnFirstLoginView(showChangePasswordView: $showChangePasswordView)
    }
}
