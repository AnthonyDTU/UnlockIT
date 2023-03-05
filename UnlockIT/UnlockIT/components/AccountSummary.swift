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
                    Text("Name: ")
                    Spacer()
                    Text("\(user.username)").bold()
                }
                HStack{
                    Text("Email: ")
                    Spacer()
                    Text("\(user.email)").bold()
                }
                HStack {
                    Text("Department: ")
                    Spacer()
                    Text("\(user.department)").bold()
                }
                HStack {
                    Text("Position: ")
                    Spacer()
                    Text("\(user.position)").bold()
                }
                HStack {
                    Text("Privilege: ")
                    Spacer()
                    Text("\(user.privilege)").bold()
                }
                HStack {
                    Text("Is Administrator: ")
                    Spacer()
                    Text("false").bold()
                }
            }
            .padding()
            
            Button("Log Out"){
                do {
                    try Auth.auth().signOut()
                }
                catch {
                    print(error)
                }
            }
        }
    }
}

struct AccountSummary_Previews: PreviewProvider {
    static var previews: some View {
        AccountSummary()
    }
}
