//
//  AllUsersView.swift
//  UnlockIT
//
//  Created by Jonas Stenhold  on 24/03/2023.
//

import SwiftUI

struct AllUsersView: View {
    var allUsers : [String]
    @Binding var selectedUsers: [String]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            List {
                ForEach(allUsers, id: \.self) { user in
                    HStack {
                        Text(user)
                        Spacer()
                        if selectedUsers.contains(user) {
                            Image(systemName: "checkmark")
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if selectedUsers.contains(user) {
                            selectedUsers.removeAll(where: { $0 == user })
                        } else {
                            selectedUsers.append(user)
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            
            Button(action: save) {
                Text("Save", comment: "Text on button, which saves authorized users")
            }
            .padding()
        }
    }
    
    func save() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct AllUsersView_Previews: PreviewProvider {
    
    static var previews: some View {
        Text("hello")
    }
    
//    static var previews: some View {
//        let sampleUsers = ["User 1", "User 2", "User 3"]
//        let usersState = State(initialValue: sampleUsers)
//        AllUsersView(allUsers: sampleUsers, selectedUsers: usersState.projectedValue)
//    }
}
