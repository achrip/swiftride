//
//  ContentView.swift
//  Page2
//
//  Created by Ferdinand Lunardy on 26/03/25.
//

import SwiftUI

struct Page2: View {
    var body: some View {
        NavigationStack{
            VStack {
                BusStopCardP2(name: "SML PLAZA", distance: 100, color: .yellow)
                Text("AVAILABLE BUS")
                    .font(.title.bold())
                    .padding()
            }
            ScrollView{
                VStack(spacing: 1){
                    BusCardP2()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    Page2()
}
