//
//  MultiSelectComboBox.swift
//  firestore-demo
//
//  Created by Jonas Stenhold  on 12/03/2023.
//

import Foundation
import SwiftUI

struct MultiSelectComboBox: View {
    let description: String
    let options: [String]
    @Binding var selectedOptions: [String]

    var body: some View {
        VStack(alignment: .center) {
            Text(description)
                .font(.headline)
            List(options, id: \.self) { option in
                Toggle(option, isOn: Binding(
                    get: { self.selectedOptions.contains(option) },
                    set: { if $0 {
                        self.selectedOptions.append(option)
                    } else {
                        self.selectedOptions.removeAll(where: { $0 == option })
                    }}
                ))
            }
            .listStyle(PlainListStyle())
            .frame(height: CGFloat(options.count * 44))
        }
    }
}
