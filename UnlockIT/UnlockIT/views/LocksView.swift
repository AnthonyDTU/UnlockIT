//
//  LocksView.swift
//  UnlockIT
//
//  Created by Jonas Stenhold  on 24/03/2023.
//

import SwiftUI

struct LocksView: View {
    @EnvironmentObject var roomsModel: RoomsModel
    var roomIndex: Int
    @State private var isShowingConfigureLockView = false
    @State private var lockToConfigure = Lock(description: "", authenticationLevel: 1)
    
    var body: some View {
        List {
            ForEach($roomsModel.rooms[roomIndex].locks) { lock in
                NavigationLink(destination: ConfigureLockView(lock: lock, onSave: { updatedLock in
                    if let index = roomsModel.rooms[roomIndex].locks.firstIndex(where: { $0.id == updatedLock.id }) {
                        roomsModel.rooms[roomIndex].locks[index] = updatedLock
                    } else {
                        roomsModel.rooms[roomIndex].locks.append(updatedLock)
                    }
                })) {
                    Text(lock.description.wrappedValue)
                }
            }
            .onDelete(perform: delete)
        }
        .navigationTitle(String(localized: "Attached Locks", comment: "Navigation Title for LockView"))
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    roomsModel.rooms[roomIndex].newLock.description = ""
                    roomsModel.rooms[roomIndex].newLock.authenticationLevel = 1
                    isShowingConfigureLockView = true
                }) {
                    Label {
                        Text("Add Lock", comment: "Text on button, which navigaties to ConfigureLockView")
                    } icon: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .onAppear() {
            print("Room Index in locks view: \(roomIndex)")
        }
        .sheet(isPresented: $isShowingConfigureLockView) {
            ConfigureLockView(lock: $roomsModel.rooms[roomIndex].newLock, onSave: { newLock in
                    roomsModel.rooms[roomIndex].locks.append(newLock)
                    isShowingConfigureLockView = false
                })
        }
    }
    
    func delete(at offsets: IndexSet) {
        roomsModel.rooms[roomIndex].locks.remove(atOffsets: offsets)
    }
}


//struct LocksView_Previews: PreviewProvider {
//
//    static var previews: some View {
//
//    }
//}
