//
//  HomeView.swift
//  UnlockIT
//
//  Created by Jonas Stenhold  on 17/02/2023.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var user : User
    @ObservedObject var name : User
    
    @State private var showLoginView : Bool = false
    
    var scanLockTapGesture: some Gesture {
        TapGesture()
            .onEnded {
                print("Scanning Lock")
            }
    }
    
    
    var body: some View {
    
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
            
            
            
            if user.isAdmin {
                AdminControls()
            }
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
