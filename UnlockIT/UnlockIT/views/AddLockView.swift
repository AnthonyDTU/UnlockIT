//
//  AddLockView.swift
//  firestore-demo
//
//  Created by Jonas Stenhold  on 12/03/2023.
//

import SwiftUI

struct NumberPicker: View {
    @Binding var number: Int

    var body: some View {
        Stepper(value: $number, in: 0...100) {
            Text("Pick a number")
        }
    }
}

struct AddLockView: View {
    @EnvironmentObject var roomsModel: RoomsModel
    @Binding var locks: [Lock]
    
    @State var lockDescription: String = "Lock Description"
    @State var authenticationLevel: Int = 1
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
            Form {
                TextField("Lock Description", text: $lockDescription)
                TextField("Enter a number", value: $authenticationLevel, formatter: NumberFormatter(), onCommit: {})
                            .keyboardType(.numberPad)
                Button("Save Lock") {
                    locks.append(Lock(description: lockDescription, authenticationLevel: authenticationLevel))
                    
                    presentationMode.wrappedValue.dismiss()
                }
            }
    }
}

struct AddLockView_Previews: PreviewProvider {
    static var roomsDummyData = RoomsModel()
    static var room = Binding<Room>(get: { roomsDummyData.newRoom }, set: { roomsDummyData.newRoom = $0 })
    
    static var previews: some View {
        AddLockView(locks: room.locks)
    }
}
