//
//  HomeView.swift
//  UnlockIT
//
//  Created by Jonas Stenhold  on 17/02/2023.
//

import SwiftUI
import LocalAuthentication

struct HomeView: View {
    
    @EnvironmentObject var user : User
    @EnvironmentObject private var userState: UserState
    
    @State private var scanNow : Bool = false
    @State private var selectedLevel : Int = 0
    @State private var showAccountView : Bool = false
    
    var scanLockTapGesture: some Gesture {
        TapGesture()
            .onEnded {
                
                userState.validateUser()
                scanNow = true
            }
    }
    
    var body: some View {
        
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showAccountView = true
                    } label: {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 30.0))
                            .foregroundColor(.blue)
                    }
                }
                Spacer()
                HStack {
                    Spacer(minLength: 20)
                    Image("UnlockItLogo.png")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(25)
                        .gesture(scanLockTapGesture)
                    Spacer(minLength: 20)
                }
                Spacer()
            }
            
            if scanNow && userState.isValidated {
                NFCSimulator(scanNow: $scanNow, selectedLevel: $selectedLevel)
            }
        }
        .sheet(isPresented: $showAccountView, content: {
            AccountSummary()
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
