//
//  BusCard.swift
//  Page2
//
//  Created by Ferdinand Lunardy on 26/03/25.
//
import SwiftUI

struct BusCardP4: View {
    var number: Int
    var name: String
    var license: String
    var color: Color
    var body: some View {
        HStack() {
            Image(systemName: "bus")
                .foregroundColor(color)
                .font(.system(size: 40))
            VStack(alignment: .leading) {
                Text(name)
                    .fontWeight(.bold)
                HStack {
                    Text("No.\(number)")
                        .font(.caption)
                    Text(license)
                        .font(.caption)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal)
    }
}

#Preview {
    BusCardP4(number: 7, name: "The Breeze", license: "B0000XXX", color: .yellow)
}
