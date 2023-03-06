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
    
    @State private var passwordNotMathing = false;
    
    var body: some View {
        Text("Hello \(user.username)! Since this is you first login, we need you to set a password. Please do so below")
        Form {
            Section(header: Text("Password").fontWeight(.bold)) {
                SecureField("Password", text: $password)
                SecureField("Confirm Password", text: $confirmPassword)
            }
        }
        .frame(height: 150)
        Button("Continue") {
            guard password == confirmPassword else { passwordNotMathing = true; return}
            
        }
        .alert(isPresented: $passwordNotMathing) {
            Alert(title: Text("Passwords does not match"))
        }
    }
}

struct ChangePasswordOnFirstLoginView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordOnFirstLoginView()
    }
}
