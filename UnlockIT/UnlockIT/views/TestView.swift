//
//  TestView.swift
//  UnlockIT
//
//  Created by Jonas Stenhold  on 28/02/2023.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        VStack {
                    Text("Content Above the Line")
                    Divider()
                        .background(Color.red)
                    Divider()
                        .background(Color.blue)
                        .padding(.horizontal, 20)
                    Divider()
                        .background(Color.green)
                        .padding(.horizontal, 40)
                    Text("Content Below the Line")
                }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
