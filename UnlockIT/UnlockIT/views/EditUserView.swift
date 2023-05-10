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
    @State private var showAlert: Bool = false
    @State private var alertText: String = ""
    @State private var confirmDeleteUser = false
    @State private var privilegeOptions = [1, 2, 3, 4, 5]
    
    var body: some View {
        
        Form {
            Section (header: Text("User Details", comment: "Section title for User Detalais in EditUserView")) {
                TextField(String(localized: "Email", comment: "Placeholder text for Email textfield in EditUserView"), text: $user.email).disabled(true)
                TextField(String(localized: "Name", comment: "Placeholder text for Name textfield in EditUserView"), text: $user.username)
                TextField(String(localized: "Employee Number", comment: "Placeholder text for Employee Number textfield in EditUserView"), text: $employeeNumber).disabled(true)
                TextField(String(localized: "Job Title", comment: "Placeholder text for Job Title textfield in EditUserView"), text: $user.position)
                TextField(String(localized: "Department", comment: "Placeholder text for Department textfield in EditUserView"), text: $user.department)
                Picker(String(localized: "Privilige", comment: "Text for Privilige picker in EditUserView"), selection: $user.privilege) {
                    ForEach(privilegeOptions, id: \.self) { level in
                        Text(String(localized: "Level \(level)", comment: "Text for Level values in EditUserView")).tag(level)
                    }
                }
                Toggle(String(localized: "Administrator Privilige", comment: "Text for Administrator Privilige Toggle in EditUserView"), isOn: $user.isAdmin)
            }
            
            // Update User button
            Button {
                user.employeeNumber = Int(employeeNumber) ?? 0
                Task {
                    do {
                        // Update user in firestore
                        let firebaseController = FirebaseUserController()
                        try await firebaseController.UpdateUserData(updatedUser: user)
                        alertText = String(localized:"User updated successfully!", comment: "Success Message")
                    }
                    catch {
                        print(error)
                        alertText = String(localized:"Error updating user...", comment: "Error Message")
                    }
                    showAlert = true
                }
            } label: {
                HStack {
                    Spacer()
                    Text("Update User", comment: "Text on butten, which updates the user")
                    Spacer()
                }
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.accentColor)
            .cornerRadius(8)
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertText))
            }
            // Delete User button
            Button {
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
                Alert(title: Text("Are you sure you want to delete this user?", comment: "Question for the user, to make sure they are sure about what they are doing"),
                      message: Text("This action cannot be undone!", comment: "Statement to the user"),
                      primaryButton: .destructive(Text("Delete", comment: "Text on button in alert, which deletes a user")) {
                            Task {
                                do {
                                    // Update user in firestore
                                    let firebaseController = FirebaseUserController()
                                    try await firebaseController.DeleteUser(userToBeDeleted: user)
                                    alertText = String(localized:"User deleted successfully!", comment: "Success Message")
                                }
                                catch {
                                    print(error)
                                    alertText = String(localized:"Error deleting user...", comment: "Error Message")
                                }
                                showAlert = true
                            }
                      },
                      secondaryButton: .cancel())
            }
        }
        .navigationTitle(String(localized: "Edit User", comment: "Navigation Title for EditUserView"))
    }
}

struct EditUserView_Previews: PreviewProvider {
    @State static var user = User()
    static var previews: some View {
        EditUserView(user: $user)
    }
}
