//
//  AdminControls.swift
//  UnlockIT
//
//  Created by Anton Lage on 21/02/2023.
//

import SwiftUI
import LocalAuthentication
import LocalAuthenticationEmbeddedUI

struct AdminControls: View {
    @EnvironmentObject private var userState: UserState

    var body: some View {
        
        VStack{
            
            if userState.isValidated {
                Text("Hello, Admin")
            }
            else {
                Text("Not Authorized")
            }
        }
        .onAppear() {
            userState.validateUser()
        }
        .onDisappear() {
            userState.resetUserValidation()
        }
    }
}



struct AdminControls_Previews: PreviewProvider {
    static var previews: some View {
        AdminControls()
    }
}
