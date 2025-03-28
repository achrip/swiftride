//
//  ContentView.swift
//  Page2
//
//  Created by Ferdinand Lunardy on 26/03/25.
//

import SwiftUI

struct Page2: View {
    @State private var isNavToPage3: Bool = false
    @Binding var isSheetShown: Bool
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
                    BusCardP2(isNavToPage3: $isNavToPage3)
                }
                Spacer()
            }
            .navigationDestination(isPresented: $isNavToPage3){
                Page3()
                    .onAppear {
                        isSheetShown = false
                    }
            }
        }
    }
}

#Preview {
    Page2(isSheetShown: .constant(true))
}
