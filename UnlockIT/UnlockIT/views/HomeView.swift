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
    
    @State private var showLoginView : Bool = false
    @State private var scanNow : Bool = false
    @State private var selectedLevel : Int = 0
    
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
                    Spacer(minLength: 20)
                    Image("UnlockItLogo.png")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(25)
                        .gesture(scanLockTapGesture)
                    Spacer(minLength: 20)
                }
                
            }
            
            
            if scanNow && userState.isValidated {
                NFCSimulator(scanNow: $scanNow, selectedLevel: $selectedLevel)
            }
        }
       
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
