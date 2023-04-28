//
//  MainScreenSheetView.swift
//  UnlockIT
//
//  Created by Anton Lage on 28/04/2023.
//

import SwiftUI

enum RequestableViews {
    case loginView
    case changePasswordView
}

struct MainScreenSheetView: View {
    
    @Binding var requestedView: RequestableViews
    
    var body: some View {
        if requestedView == .loginView {
            LoginView()
        }
        else if requestedView == .changePasswordView {
            ChangePasswordOnFirstLoginView()
        }
    }
}

struct MainScreenSheetView_Previews: PreviewProvider {
    @State static var requestedView = RequestableViews.loginView
    static var previews: some View {
        MainScreenSheetView(requestedView: $requestedView)
    }
}
