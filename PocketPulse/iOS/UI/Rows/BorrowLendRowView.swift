//
//  BorrowLendRowView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 10/08/25.
//
import SwiftUI

struct BorrowLendRowView: View {
    let item: BorrowLendModel
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name).font(.headline)
                if let contact = item.contact, !contact.isEmpty {
                    Text(contact).font(.caption).foregroundColor(.secondary)
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(item.amount, format: .currency(code: "INR"))
                Text(item.type.rawValue)
                    .font(.caption)
                    .foregroundColor(item.type == .lent ? .red : .green)
            }
        }
    }
}
