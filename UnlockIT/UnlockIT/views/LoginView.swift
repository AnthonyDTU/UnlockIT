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
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject private var appStyle : AppStyle
    @EnvironmentObject var user : User
    @EnvironmentObject var userState : UserState
    
    @State private var email : String = ""
    @State private var password : String = ""
    @State private var showErrorPrompt: Bool = false
    
    var body: some View {
        
        VStack {
            Spacer()
            Image("UnlockItLogo.png")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(appStyle.cornerRadiusLarge)
                .padding()
        
            Form {
                Section (header: Text("Credentials").fontWeight(.bold)){
                    TextField("Email", text: $email)
                    SecureField("Password", text: $password)
                }
               
            }
            .frame(height: 150)
        
            HStack {
                Button {
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
                label: {
                    HStack {
                        Spacer()
                        Text("Login")
                        Spacer()
                    }
                }
                .foregroundColor(.white)
                .padding(15)
                .background(Color.accentColor)
                .cornerRadius(appStyle.cornerRadiusSmall)
                .alert(isPresented: $showErrorPrompt) {
                    Alert(title: Text("Email/Password incorrect"))
                }
            }
            .padding()
            Spacer()
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    @StateObject static var appStyle = AppStyle()
    static var previews: some View {
        LoginView().environmentObject(appStyle)
    }
}
