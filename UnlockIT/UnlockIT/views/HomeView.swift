//
//  HomeView.swift
//  UnlockIT
//
//  Created by Jonas Stenhold  on 17/02/2023.
//

import SwiftUI
import LocalAuthentication

struct HomeView: View {
    
    @EnvironmentObject private var appStyle : AppStyle
    @EnvironmentObject private var user : User
    
    @State private var scanNow : Bool = false
    @State private var selectedLevel : Int = 0
    @State private var showAccountView : Bool = false
    
    var scanLockTapGesture: some Gesture {
        TapGesture()
            .onEnded {
                user.validateUser()
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
                        Image(systemName: "person.circle")
                            .font(.system(size: 28.0))
                            .foregroundColor(.blue)
                    }
                    .padding()
                }
                Spacer()
                Image("UnlockItLogo.png")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(appStyle.cornerRadiusLarge)
                    .gesture(scanLockTapGesture)
                    .padding()
                
                Spacer()
            }
            
            if scanNow && user.isValidated {
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
