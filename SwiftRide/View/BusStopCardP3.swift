//
//  BusCard.swift
//  Page2
//
//  Created by Ferdinand Lunardy on 25/03/25.
//
import SwiftUI

struct BusStopCardP3: View {
    var name: String
    var distance: Int
    var color: Color
    var body: some View {
        HStack() {
            Circle().foregroundStyle(color)
                .frame(width: 40)
            VStack(alignment: .leading) {
                Text(name)
                    .font(.title.bold())
                Text("\(distance) m dari lokasi sekarang")
                    .font(.caption)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(25)
    }
}

#Preview {
    BusStopCardP3(name: "SML PLAZA", distance: 100, color: .yellow)
}
