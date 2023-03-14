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
    @EnvironmentObject private var user : User
    @EnvironmentObject private var userState : UserState
    
    
    @Binding var showLoginView: Bool
    
    @State private var email : String = ""
    @State private var password : String = ""
    @State private var showErrorPrompt: Bool = false
    @State private var showPasswordErrorPrompt: Bool = false
    @State private var showResetPasswordControls = false
    
    
    var body: some View {
        
        VStack {
            Spacer()
            Image("UnlockItLogo.png")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(appStyle.cornerRadiusLarge)
                .padding()
                
                
            Form {
                Section (header: Text("Credentials").fontWeight(.semibold)){
                    TextField("Email", text: $email)
                    SecureField("Password", text: $password)
                }
               
            }
            .frame(height: 150)
        
            HStack {
                Button {
                    Task {
                        let firebaseController = FirebaseController()
                        do {
                            try await firebaseController.SignIn(user, email, password)
                            try await firebaseController.GetUserDataFromFirestore(user: user)
                            dismiss()
                        }
                        catch {
                            showErrorPrompt = true
                            print(error)
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
    @State static var showView = false
    static var previews: some View {
        LoginView(showLoginView: $showView).environmentObject(appStyle)
    }
}
