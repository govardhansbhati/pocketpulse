//
//  SectionHeaderView.swift
//  PocketPulse
//
//  Created by govardhan singh on 27/07/25.
//

import SwiftUI

struct SectionHeaderView: View {
    let title: String
    let buttonTitle: String
    let buttonAction: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Button(action: buttonAction) {
                Label(buttonTitle, systemImage: "plus.circle")
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    SectionHeaderView(title: "", buttonTitle: "", buttonAction: {})
}
