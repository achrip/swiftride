//
//  ContentView.swift
//  Page2
//
//  Created by Ferdinand Lunardy on 26/03/25.
//

import SwiftUI

struct Page2: View {
    @Binding var isNavToPage3: Bool
    @Binding var isNavToPage4: Bool
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
                Page3(isNavToPage4: $isNavToPage4, isSheetShown: $isSheetShown)
                    .onAppear {
                        isSheetShown = false
                    }
            }
        }
    }
}

#Preview {
    Page2(isNavToPage3: .constant(false), isNavToPage4: .constant(false), isSheetShown: .constant(true))
}
