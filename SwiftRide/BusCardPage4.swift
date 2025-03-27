//
//  BusCard.swift
//  Page2
//
//  Created by Ferdinand Lunardy on 26/03/25.
//
import SwiftUI

struct BusCardPage4: View {
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
                Text(license)
                    .font(.caption)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal)
    }
}

#Preview {
    BusCardPage4(name: "AEON - THE BREEZE", license: "B 0000 XXX", color: .yellow)
}
