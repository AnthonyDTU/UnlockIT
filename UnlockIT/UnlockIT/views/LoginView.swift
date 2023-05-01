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
                Section (header: Text("Credentials", comment: "Section header for credentials section in LoginView").fontWeight(.semibold)){
                    TextField(String(localized: "Email", comment: "Placeholder for Email text field in Login View"), text: $email)
                    SecureField(String(localized: "Password", comment: "Placeholder for password secure textfield in LoginView"), text: $password)
                }
               
            }
            .frame(height: 150)
        
            HStack {
                Button {
                    Task {
                        let firebaseController = FirebaseUserController()
                        do {
                            try await firebaseController.SignIn(user, email, password)
                            try await firebaseController.GetUserDataFromFirestore(user: user)
                            dismiss()
                        }
                        catch AuthErrorCode.invalidCredential {
                            errorMessage = String(localized: "Invalid Credentials", comment: "Error Message")
                            showErrorPrompt = true
                        }
                        catch AuthErrorCode.internalError {
                            errorMessage = String(localized: "Server Error", comment: "Error Message")
                            showErrorPrompt = true
                        }
                        catch AuthErrorCode.networkError {
                            errorMessage = String(localized: "Network Error", comment: "Error Message")
                            showErrorPrompt = true
                        }
                        catch FirebaseUserControllerError.userIDNotAvailiable {
                            errorMessage = String(localized: "Failed Getting UserID", comment: "Error Message")
                            showErrorPrompt = true
                        }
                        catch FirebaseUserControllerError.companyNameNotAvaliable {
                            errorMessage = String(localized: "Failed Getting Company Name", comment: "Error Message")
                            showErrorPrompt = true
                        }
                        catch {
                            errorMessage = String(localized: "Unexpected Error", comment: "Error Message")
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
                .accessibilityIdentifier("PerformLoginButton")
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
    }
}


struct LoginView_Previews: PreviewProvider {
    @StateObject static var appStyle = AppStyle()
    @State static var showView = false
    static var previews: some View {
        LoginView().environmentObject(appStyle)
    }
}
