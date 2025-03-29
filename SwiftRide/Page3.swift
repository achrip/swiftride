//
//  ContentView.swift
//  Page3
//
//  Created by Ferdinand Lunardy on 26/03/25.
//

import SwiftUI

struct Page3: View {
    @Binding var isNavToPage4: Bool
    @Binding var isSheetShown: Bool
    var body: some View {
        NavigationStack{
            VStack {
                BusStopCardP3(name: "SML PLAZA", distance: 100, color: .yellow)
                BusCardP3(number: 7, name: "AEON - THE BREEZE", license: "B0000XXX", color: .yellow)
                Text("AVAILABLE SCHEDULE")
                    .font(.title.bold())
                    .padding()
                ScheduleButtonP3(isNavToPage4: $isNavToPage4)
            }
            Spacer()
                .navigationDestination(isPresented: $isNavToPage4){
                    Page4()
                        .onAppear {
                            isSheetShown = false
                        }
                }

        }
    }
}

#Preview {
    Page3(isNavToPage4: .constant(false), isSheetShown: .constant(true))
}

