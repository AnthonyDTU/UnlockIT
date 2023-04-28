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
                Button("Unlock") {
                    Task {
                        do {
                            isLoading = true // show loading indicator
                            defer {
                                isLoading = false // hide loading indicator
                                //showAlert = true
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
                Spacer()
                Text("NFC Simulator")
                    .font(Font.system(.largeTitle).bold())
                    .foregroundColor(.gray)
                Text("(Which actually uses WiFi, but don't tell anyone...)")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                    
                Spacer()
                Image(systemName: "iphone.gen2.radiowaves.left.and.right")
                    .font(.system(size: 100.0))
                    .foregroundColor(.blue)
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        selectedLevel = 1
                        scanNow = false
                    } label: {
                        Image(systemName: "1.circle.fill")
                            .font(.system(size: 56.0))
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    Button {
                        selectedLevel = 2
                        scanNow = false
                    } label: {
                        Image(systemName: "2.circle.fill")
                            .font(.system(size: 56.0))
                            .foregroundColor(.blue)
                    }

                    Spacer()
                    Button {
                        selectedLevel = 3
                        scanNow = false
                    } label: {
                        Image(systemName: "3.circle.fill")
                            .font(.system(size: 56.0))
                            .foregroundColor(.blue)
                    }
                    Spacer()
                }
                //Spacer()
                
                Button("Cancel") {
                    selectedLevel = 0
                    scanNow = false
                }
                .frame(width: UIScreen.main.bounds.width - 100, height: 50)
                .foregroundColor(.black)
                .buttonStyle(.bordered)
                .cornerRadius(15)
                .tint(.gray)
                
                //Spacer()
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
