//
//  NFCSimulator.swift
//  UnlockIT
//
//  Created by Anton Lage on 23/02/2023.
//

import SwiftUI

struct NFCSimulator: View {
    @Binding var scanNow : Bool
    @Binding var selectedLevel : Int
    @EnvironmentObject private var user: User
    
    @State private var lockResponseData = ""
    @State private var isLoading = false
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(.white)
                .frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height - 300, alignment: .bottom)
            
            VStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .opacity(1.0)
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .opacity(0.0)
                }
                
                Spacer()
                Text("NFC Simulator", comment: "Text decriping NFC simulator")
                    .font(Font.system(.largeTitle).bold())
                    .foregroundColor(.gray)
                Text("(Which actually uses WiFi, but don't tell anyone...)", comment: "Text decribing how the NFC simulator acutally works")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                    
                Spacer()
                Image(systemName: "iphone.gen2.radiowaves.left.and.right")
                    .font(.system(size: 100.0))
                    .foregroundColor(.blue)
                Spacer()
                Button("Unlock") {
                    Task {
                        do {
                            
                            DispatchQueue.main.async {
                                isLoading = true // show loading indicator
                            }
                            
                            defer {
                                
                                DispatchQueue.main.async {
                                    self.isLoading = false // hide loading indicator
                                    //showAlert = true
                                }
                                
                            }
                            lockResponseData = try await initChallenge(id: "13")
                            print(lockResponseData)
                            lockResponseData = try await respondChallenge(id: "13")
                            print(lockResponseData)
                        } catch {
                            print("Error fetching data: \(error.localizedDescription)")
                        }
                    }
                }
                .disabled(isLoading) // disable button while loading
                .frame(width: UIScreen.main.bounds.width - 100, height: 50)
                .foregroundColor(.black)
                .buttonStyle(.bordered)
                .cornerRadius(15)
                .tint(.blue)
                
                Button() {
                    selectedLevel = 0
                    scanNow = false
                } label: {
                    Text("Cancel", comment: "Text on cancel button in NFC simulator")
                }
                .frame(width: UIScreen.main.bounds.width - 100, height: 50)
                .foregroundColor(.black)
                .buttonStyle(.bordered)
                .cornerRadius(15)
                .tint(.gray)
                
                Spacer()
            }
        }
        .frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height - 300, alignment: .bottom)
        .onDisappear() {
            user.resetUserValidation()
        }
    }
}

struct NFCSimulator_Previews: PreviewProvider {
    static var previews: some View {
        NFCSimulator(scanNow: .constant(true), selectedLevel: .constant(0))
    }
}
