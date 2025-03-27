//
//  ContentView.swift
//  Page4
//
//  Created by Ferdinand Lunardy on 26/03/25.
//

import SwiftUI

import SwiftUI

struct Page4: View {
    @State private var showAlert = false
    @State private var alertTime = Date()

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    BusStopCardP4(name: "SML PLAZA", distance: 100, color: .yellow)
                    BusCardP4(number: 7, name: "AEON - THE BREEZE", license: "B0000XXX", color: .yellow)
                    BusRouteP4()
                        .padding(.top, 10)

                    Spacer()

                    Button(action: {
                        showAlert = true
                    }) {
                        Label("Notify Me!", systemImage: "bell.fill")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(15)
                            .padding(.horizontal)
                    }
                }

                // Overlay Popup
                if showAlert {
                    VStack {
                        AlertPopup(
                            selectedTime: $alertTime,
                            onCancel: {
                                print("Cancel Pressed")
                                showAlert = false
                            },
                            onSave: {
                                print("Save Pressed")
                                showAlert = false
                            }
                        )
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.scale)
                    .zIndex(1)
                }
            }
            .animation(.easeInOut(duration: 0.25), value: showAlert)
        }
    }
}


#Preview {
    Page4()
}
