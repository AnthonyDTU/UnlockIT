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
    
    @State private var lockResponseData = ""
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var showFailedAlert = false;

    
    var body: some View {
        VStack {
            List {
                TextField(String(localized: "Lock Description", comment: "Placeholder for lock description textfield in ConfigureLockView"), text: $lock.description)
                TextField(String(localized: "Lock ID", comment: "Placeholder for lock ID textfield in ConfigureLockView"), value: $lock.lockId, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                Picker(String(localized: "Authentication Level", comment: "Text on picker control in ConfigureLockView"), selection: $lock.authenticationLevel) {
                    ForEach(0 ..< levels.count) {
                        Text("\(self.levels[$0])")
                    }
                }
                Button("Activate") {
                    Task {
                        do {
                            isLoading = true // show loading indicator
                            defer {
                                isLoading = false // hide loading indicator
                                showAlert = true
                            }
                            lockResponseData = try await activateLock(id: String(lock.lockId))
                            print(lockResponseData)
                        } catch {
                            print(error)
                            showAlert = true
                            showFailedAlert = true
                        }
                    }
                }
                .disabled(isLoading) // disable button while loading
            }
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .opacity(1.0)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .opacity(0.0)
            }
            Button() {
                onSave(lock)
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save", comment: "Text on button, which saves the new lock")
            }
        }
        .alert(isPresented: $showAlert) {
            if !showFailedAlert {
                return Alert(title: Text("Lock Activation"),
                             message: Text("Lock Successfully activated"),
                             dismissButton: .default(Text("OK")))
            }
            else {
                showFailedAlert = false
                return Alert(title: Text("Lock Activation"),
                             message: Text("Lock Activation Failed"),
                             dismissButton: .default(Text("OK")))
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
