//
//  ColorDetail.swift
//  UnlockIT
//
//  Created by Jonas Stenhold  on 17/02/2023.
//

import SwiftUI
import FirebaseAuth

struct AccountSummary: View {
    
    @EnvironmentObject var user: User
    
    var body: some View {
        VStack {
            VStack (alignment: .leading){
                HStack{
                    Text("Name: ", comment: "Text label in account summary")
                    Spacer()
                    Text("\(user.username)").bold()
                }
                HStack{
                    Text("Email: ", comment: "Text label in account summary")
                    Spacer()
                    Text("\(user.email)").bold()
                }
                HStack {
                    Text("Department: ", comment: "Text label in account summary")
                    Spacer()
                    Text("\(user.department)").bold()
                }
                HStack {
                    Text("Job Title: ", comment: "Text label in account summary")
                    Spacer()
                    Text("\(user.position)").bold()
                }
                HStack {
                    Text("Privilege: ", comment: "Text label in account summary")
                    Spacer()
                    Text("\(user.privilege)").bold()
                }
                HStack {
                    Text("Is Administrator: ", comment: "Text label in account summary")
                    Spacer()
                    Text(String(user.isAdmin)).bold()
                }
            }
            .padding()
            
            Button(){
                do {
                    try Auth.auth().signOut()
                }
                catch {
                    print(error)
                }
            } label:  {
                Text("Log Out", comment: "Text on button, for logging a user out.")
            }
            
        }
    }
}

struct AccountSummary_Previews: PreviewProvider {
    static var previews: some View {
        AccountSummary()
    }
}
