//
//  ConfigureNewUserView.swift
//  UnlockIT
//
//  Created by Anton Lage on 21/02/2023.
//

import SwiftUI
import Firebase

struct CreateUserView: View {
    
    @EnvironmentObject private var user : User
    
    @State private var employeeNumber : String = ""
    @State private var password : String = ""
    @State private var passwordConfirm : String = ""
    
    @State private var presentAlert : Bool = false
    @State private var alertText: String = ""
    @State private var errorCreatingUser = false
    @State private var userCreatedSuccessfully = false
    @State private var errorInData = false
    
    @State private var newUser = User()
    
    @State private var privilegeOptions = [1, 2, 3, 4, 5]
    
    
    var body: some View {
     
        NavigationStack {
            Form {
                Section (header: Text("Credentials")){
                    TextField("Email", text: $newUser.email)
                    SecureField("Password", text: $password)
                    SecureField("Confirm Password", text: $passwordConfirm)
                }
                
                Section (header: Text("User Details")) {
                    TextField("Name", text: $newUser.username)
                    TextField("Employee Number", text: $employeeNumber).keyboardType(.numberPad)
                    TextField("Postition", text: $newUser.position)
                    TextField("Department", text: $newUser.department)
                    Picker("Privilige", selection: $newUser.privilege) {
                        ForEach(privilegeOptions, id: \.self) { level in
                            Text("Level \(level)").tag(level)
                        }
                    }
                    Toggle("Administrator", isOn: $newUser.isAdmin)
                }
                
                // Create User Button
                Button {
                    // Store additional information in the new user
                    newUser.employeeNumber = Int(employeeNumber) ?? 0
                    newUser.isFirstLogin = true
                    
                    // Validate credentails before continuing to create the user
                    guard validateCredentials() else {
                        alertText = "Error In User Data..."
                        presentAlert = true
                        return
                    }
                    
                    // Create a task for async communication with firebase
                    Task {
                        // Create a firebaseController
                        let firebaseController = FirebaseController()
                        // Try to create the new user
                        do {
                            try await firebaseController.CreateNewUser(adminUser: user, newUser: newUser, newUserPassword: password)
                            alertText = "User Created Successfully!"
                        }
                        catch {
                            alertText = "Error While Creating User..."
                            print(error)
                        }
                        presentAlert = true
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Create User")
                        Spacer()
                    }
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.accentColor)
                .cornerRadius(8)
                .alert(isPresented: $presentAlert) {
                    Alert(title: Text(alertText))
                }
            }
        }
        .navigationBarTitle("Create New User")
    }
    
    func validateCredentials() -> Bool {
        guard newUser.email != "" else { return false }
        guard newUser.email.contains("@") else { return false }
        guard password == passwordConfirm else { return false }
        guard newUser.department != "" else { return false }
        guard newUser.position != "" else { return false }
        guard newUser.employeeNumber != 0 else { return false }
        return true
    }
}

struct ConfigureNewUserView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserView()
    }
}
