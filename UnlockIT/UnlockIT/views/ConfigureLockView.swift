//
//  ConfigureLockView.swift
//  UnlockIT
//
//  Created by Anton Lage on 21/02/2023.
//

import SwiftUI

struct ConfigureLockView: View {
    @Binding var lock: Lock
    var onSave: (Lock) -> Void
    let levels = [1, 2, 3, 4, 5]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            List {
                TextField("Lock Description", text: $lock.description)
                Picker("Authentication Level", selection: $lock.authenticationLevel) {
                    ForEach(0 ..< levels.count) {
                        Text("\(self.levels[$0])")
                    }
                }
            }
            Button("Save") {
                onSave(lock)
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct ConfigureLockView_Previews: PreviewProvider {
    
    static var previews: some View {
        Text("hello")
    }
    
//    static var previews: some View {
//            var lock = Lock(description: "Bedroom", authenticationLevel: 3)
//            var lockState = Binding<Lock>(
//                get: { lock },
//                set: { lock = $0 }
//            )
//        ConfigureLockView(lock: lockState, isConfiguringNewLock: true, onSave: <#(Lock) -> Void#>)
//        }
}
