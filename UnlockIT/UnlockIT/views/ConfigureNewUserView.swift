//
//  ConfigureNewUserView.swift
//  UnlockIT
//
//  Created by Anton Lage on 21/02/2023.
//

import SwiftUI

struct ConfigureNewUserView: View {
    
    @State private var name : String = ""
    @State private var employeeNumber : String = ""
    @State private var email : String = ""
    @State private var password : String = ""
    @State private var passwordConfirm : String = ""
    @State private var authorizationLevel : Int = 0
    @State private var isUserAdmin : Bool = false
    
    var body: some View {
     
        NavigationView {
            VStack {
                Form {
                    Section (header: Text("Credentials")){
                        TextField("Email", text: $email)
                        SecureField("Password", text: $password)
                        SecureField("Confirm Password", text: $password)
                    }
                    
                    Section (header: Text("User Settings")) {
                        TextField("Name", text: $email)
                        TextField("Employee Number", text: $employeeNumber)
                        Picker("Privilige", selection: $authorizationLevel) {
                            Text("Level 1")
                            Text("Level 2")
                            Text("Level 3")
                        }
                        //.pickerStyle(SegmentedPickerStyle())
                        Toggle("Administrator Privilige", isOn: $isUserAdmin)
                    }
                }
            }
            .navigationBarTitle("Create New User")
        }
    }
}

struct ConfigureNewUserView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigureNewUserView()
    }
}
