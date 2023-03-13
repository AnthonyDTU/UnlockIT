//
//  EditUserView.swift
//  UnlockIT
//
//  Created by Anton Lage on 08/03/2023.
//

import SwiftUI

struct EditUserView: View {
    
    @Binding var user: User
    
    @State private var name : String = ""
    @State private var employeeNumber : String = ""
    @State private var email : String = ""
    @State private var password : String = ""
    @State private var passwordConfirm : String = ""
    @State private var position : String = ""
    @State private var department : String = ""
    @State private var privilege : String = "Level 1"
    @State private var isUserAdmin : Bool = false
    
    @State private var errorUpdatingUser = false
    @State private var userCreatedSuccessfully = false
    @State private var errorInData = false
    
    @State private var confirmDeleteUser = false
    
    var body: some View {
        
        VStack {
            Form {
                Section (header: Text("User Details")) {
                    
                    TextField("Email", text: $user.email).disabled(true)
                    TextField("Name", text: $user.username)
                    TextField("Employee Number", text: $employeeNumber).disabled(true)
                    TextField("Postition", text: $user.position)
                    TextField("Department", text: $user.department)
                    Picker("Privilige", selection: $user.privilege) {
                        Text("Level 1")
                        Text("Level 2")
                        Text("Level 3")
                    }
                    Toggle("Administrator Privilige", isOn: $user.isAdmin)
                }
                
                // Update User button
                Button {
                    let firebaseController = FirebaseController()
                    user.configureUserData(userID: user.userID,
                                           employeeNumber: user.employeeNumber,
                                           username: user.username,
                                           email: user.email,
                                           company: user.company,
                                           department: department,
                                           companyPosition: position,
                                           privilege: 1,
                                           isAdmin: isUserAdmin,
                                           isFirstLogin: user.isFirstLogin)
                    
                    Task {
                        // Update user here
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Update User")
                        Spacer()
                    }
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.accentColor)
                .cornerRadius(8)
                .alert(isPresented: $errorUpdatingUser) {
                    Alert(title: Text("Error While Updating User..."))
                }
                .alert(isPresented: $userCreatedSuccessfully) {
                    Alert(title: Text("User Updated Succesfully!"))
                }
                
                // Delete User button
                Button {
                    let firebaseController = FirebaseController()
                    confirmDeleteUser = true
                    
                } label: {
                    HStack {
                        Spacer()
                        Text("Delete User")
                        Spacer()
                    }
                }
                .foregroundColor(.white)
                .padding()
                .background(.red)
                .cornerRadius(8)
                .alert(isPresented: $confirmDeleteUser) {
                    Alert(title: Text("Are you sure you want to delete this user?"),
                          message: Text("This action cannot be undone!"),
                          primaryButton: .destructive(Text("Delete")) {
                            // Delete user here
                          },
                          secondaryButton: .cancel())
                }
            }
        }
        .navigationBarTitle("Edit User")
    }
}

struct EditUserView_Previews: PreviewProvider {
    @State static var user = User()
    static var previews: some View {
        EditUserView(user: $user)
    }
}
