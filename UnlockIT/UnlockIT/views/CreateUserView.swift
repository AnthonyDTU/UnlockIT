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
    
    @State private var name : String = ""
    @State private var employeeNumber : String = ""
    @State private var email : String = ""
    @State private var password : String = ""
    @State private var passwordConfirm : String = ""
    @State private var position : String = ""
    @State private var department : String = ""
    @State private var privilege : String = "Level 1"
    @State private var isUserAdmin : Bool = false
    
    @State private var errorCreatingUser = false
    @State private var userCreatedSuccessfully = false
    @State private var errorInData = false
    
    @State private var newUser = User()
    
    var body: some View {
     
        VStack {
            Form {
                Section (header: Text("Credentials")){
                    TextField("Email", text: $email)
                    SecureField("Password", text: $password)
                    SecureField("Confirm Password", text: $passwordConfirm)
                }
                
                Section (header: Text("User Details")) {
                    TextField("Name", text: $name)
                    TextField("Employee Number", text: $employeeNumber).keyboardType(.numberPad)
                    TextField("Postition", text: $position)
                    TextField("Department", text: $department)
                    Picker("Privilige", selection: $privilege) {
                        Text("Level 1")
                        Text("Level 2")
                        Text("Level 3")
                    }
                    Toggle("Administrator Privilige", isOn: $isUserAdmin)
                }
                
                Button {
                                        
                    guard validateData() else { errorInData = true; return }
                    let firebaseController = FirebaseController()
                    let newUser = User()
                    newUser.configureUserData(userID: "0",
                                              employeeNumber: Int(employeeNumber) ?? 0,
                                              username: name,
                                              email: email,
                                              department: department,
                                              companyPosition: position,
                                              privilege: 1,
                                              isAdmin: isUserAdmin,
                                              isFirstLogin: true)
                    
                    Task {
                        userCreatedSuccessfully = await firebaseController.CreateNewUser(adminUser: user, newUser: newUser, newUserPassword: password)
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
                .alert(isPresented: $errorCreatingUser) {
                    Alert(title: Text("Error While Creating User..."))
                }
                .alert(isPresented: $errorInData) {
                    Alert(title: Text("Error In User Data..."))
                }
                .alert(isPresented: $userCreatedSuccessfully) {
                    Alert(title: Text("User Created Succesfully!"))
                }
            }
        }
        .navigationBarTitle("Create New User")
    }
    
    func validateData() -> Bool {
        guard email != "" else { return false }
        guard email.contains("@") else { return false }
        guard password == passwordConfirm else { return false }
        return true
    }

}

struct ConfigureNewUserView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserView()
    }
}
