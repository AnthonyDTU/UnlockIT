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
     
     
        Form {
            Section (header: Text("Credentials",
                                  comment: "Header text for the credentials section in CreateUserView")){
                TextField(String(localized: "Email", comment: "Placeholder text for email text field in CreateUserView"),
                          text: $newUser.email)
                
                SecureField(String(localized: "Password", comment: "Placeholder text for password secure text field in CreateUserView"),
                            text: $password)
                
                SecureField(String(localized: "Confirm Password", comment: "Placeholder text for confirm password secure text field in CreateUserView"),
                            text: $passwordConfirm)
            }
            
            Section (header: Text("User Details",
                                  comment: "Header text for the user detail section in CreateUserView")) {
                TextField(String(localized: "Name", comment: "Placeholder text for name text field in CreateUserView"), text: $newUser.username)
                TextField(String(localized: "Emplyee Number", comment: "Placeholder text for employee number text field in CreateUserView"), text: $employeeNumber).keyboardType(.numberPad)
                TextField(String(localized: "Job Title", comment: "Placeholder text for job titel text field in CreateUserView"), text: $newUser.position)
                TextField(String(localized: "Department", comment: "Placeholder text for department text field in CreateUserView"), text: $newUser.department)
                Picker(String(localized: "Privilege", comment: "Text for privelige picker in CreateUserView"), selection: $newUser.privilege) {
                    ForEach(privilegeOptions, id: \.self) { level in
                        Text("Level \(level)", comment: "Picker item for privilege in CreateUserView").tag(level)
                    }
                }
                Toggle(String(localized: "Administrator", comment: "Text for Administrator toggle in CreateUserView"), isOn: $newUser.isAdmin)
            }
            
            // Create User Button
            Button {
                // Store additional information in the new user
                newUser.employeeNumber = Int(employeeNumber) ?? 0
                newUser.firstLogin = true
                
                // Validate credentails before continuing to create the user
                do { try validateCredentials() }
                catch {
                    alertText = error.localizedDescription
                    presentAlert = true
                    return
                }
                
                // Create a task for async communication with firebase
                Task {
                    // Create a firebaseController
                    let firebaseController = FirebaseUserController()
                    // Try to create the new user
                    do {
                        try await firebaseController.CreateNewUser(adminUser: user, newUser: newUser, newUserPassword: password)
                        alertText = String(localized: "User Created Successfully!", comment: "Succes Message")
                    }
                    catch {
                        alertText = String(localized: "Error While Creating User...", comment: "Error Message")
                        print(error)
                    }
                    presentAlert = true
                }
            } label: {
                HStack {
                    Spacer()
                    Text("Create User", comment: "Text on button, which creates a new user in CreateUserView")
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
        .navigationBarTitle(String(localized: "Create User", comment: "Navigation Bar Titile for CreateUserView"))
    }
    
    func validateCredentials() throws {
        guard newUser.email != "" else { throw String(localized: "Email is empty", comment: "Error Message") }
        guard newUser.email.contains("@") else { throw String(localized: "Email does not contain @", comment: "Error Message") }
        guard password == passwordConfirm else { throw String(localized: "Passwords does not math", comment: "Error Message") }
        guard newUser.department != "" else { throw String(localized: "Department is empty", comment: "Error Message") }
        guard newUser.position != "" else { throw String(localized: "Position is empty", comment: "Error Message") }
        guard newUser.employeeNumber != 0 else { throw String(localized: "Employee number is empty", comment: "Error Message") }
    }
}




struct ConfigureNewUserView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserView()
    }
}
