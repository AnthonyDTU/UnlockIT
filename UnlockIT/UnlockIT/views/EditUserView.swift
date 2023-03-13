//
//  EditUserView.swift
//  UnlockIT
//
//  Created by Anton Lage on 08/03/2023.
//

import SwiftUI

struct EditUserView: View {
    
    @Binding var user: User
    
    @State private var employeeNumber : String = ""
    
    @State private var errorUpdatingUser = false
    @State private var userCreatedSuccessfully = false
    @State private var errorInData = false
    
    @State private var confirmDeleteUser = false
    
    
    @State private var privilegeOptions = [1, 2, 3, 4, 5]
    
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
                        ForEach(privilegeOptions, id: \.self) { level in
                            Text("Level \(level)").tag(level)
                        }
                    }
                    Toggle("Administrator Privilige", isOn: $user.isAdmin)
                }
                
                // Update User button
                Button {
                    
                    user.employeeNumber = Int(employeeNumber) ?? 0
                    
                    Task {
                        // Update user in firestore
                        let firebaseController = FirebaseController()
                        
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
