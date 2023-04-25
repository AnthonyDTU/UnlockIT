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
    
    @Binding var showLoginView: Bool
    
    @State private var email : String = ""
    @State private var password : String = ""
    @State private var showErrorPrompt: Bool = false
    @State private var errorMessage: String = ""
    
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
                        catch AuthErrorCode.invalidCredential {
                            errorMessage = "Invalid Credentials"
                            showErrorPrompt = true
                        }
                        catch AuthErrorCode.internalError {
                            errorMessage = "Server Error"
                            errorMessage = "String For Localizing Test"
                            showErrorPrompt = true
                        }
                        catch AuthErrorCode.networkError {
                            errorMessage = "Network Error"
                            showErrorPrompt = true
                        }
                        catch FirebaseControllerError.userIDNotAvailiable {
                            errorMessage = "Failed Getting UserID"
                            showErrorPrompt = true
                        }
                        catch FirebaseControllerError.companyNameNotAvaliable {
                            errorMessage = "Failed Getting Company Name"
                            showErrorPrompt = true
                        }
                        catch {
                            errorMessage = String(localized: "Unexpected Error", comment: "Error message in loginview for when an unexpected errormessage occurs.")
                            showErrorPrompt = true
                            print(error)
                        }
                    }
                }
                label: {
                    HStack {
                        Spacer()
                        Text("Login", comment: "Text on button for logging in. Located in LoginView.")
                        Spacer()
                    }
                }
                .foregroundColor(.white)
                .padding(15)
                .background(Color.accentColor)
                .cornerRadius(appStyle.cornerRadiusSmall)
                .alert(isPresented: $showErrorPrompt) {
                    Alert(title: Text(errorMessage))
                }
            }
            .padding()
            
            
            Spacer()
        }
        .onDisappear {
            showLoginView = false
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
