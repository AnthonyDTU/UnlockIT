//
//  EditLockView.swift
//  firestore-demo
//
//  Created by Jonas Stenhold  on 13/03/2023.
//

import SwiftUI

struct EditLockView: View {
    @EnvironmentObject var roomsModel: RoomsModel
    @Binding var lock: Lock
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
            Form {
                TextField("Lock Description", text: $lock.description)
                TextField("Enter a number", value: $lock.authenticationLevel, formatter: NumberFormatter(), onCommit: {})
                            .keyboardType(.numberPad)
                Button("Save Lock") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
    }
}

struct EditLockView_Previews: PreviewProvider {
    @State static var lock = Lock(description: "Lock 1", authenticationLevel: 2, lastUnlock: NSDate(timeIntervalSinceNow: -10000) as Date)
    static var savedLock = State(initialValue: false)
    
    static var previews: some View {
        EditLockView(lock: $lock)
    }
}
