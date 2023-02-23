//
//  LoginView.swift
//  UnlockIT
//
//  Created by Jonas Stenhold  on 16/02/2023.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    
    @State private var showErrorPrompt: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    @State private var email : String = ""
    @State private var password : String = ""
    
    @EnvironmentObject var user : User
    @EnvironmentObject var userState : UserState
    
    var body: some View {
        
        VStack {
            
            HStack {
                Spacer(minLength: 20)
                Image("UnlockItLogo.png")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(25)
                Spacer(minLength: 20)
            }
            
            HStack {
                Spacer(minLength: 20)
                Form {
                    TextField("Email", text: $email)
                    SecureField("Password", text: $password)
                }
                .frame(height: 150)
                Spacer(minLength: 20)
            }
            
            
            Button("Login") {
                Task {
                    let result = await userState.SignIn(email: email, password: password)
                    if result == true {
                        // Get User Data?
                        dismiss()
                    }
                    else {
                        showErrorPrompt = true
                    }
                }
            }
            .alert(isPresented: $showErrorPrompt) {
                Alert(title: Text("Email/Password incorrect"))
            }
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
