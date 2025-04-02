//
//  AlertTime.swift
//  Page4
//
//  Created by Ferdinand Lunardy on 26/03/25.
//

import SwiftUI

struct AlertPopup: View {
    @Binding var selectedTime: Date
    var onCancel: () -> Void
    var onSave: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Button("Back", action: onCancel)
                Spacer()
                Text("Set Alert")
                    .font(.headline)
                Spacer()
                Button("Save", action: onSave)
            }
            .padding(.top)
            .padding(.horizontal)
            
            // Time Picker
            DatePicker(
                "",
                selection: $selectedTime,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .frame(height: 150)
            
            // Cancel button
            Button("Cancel", action: onCancel)
                .foregroundColor(.red)
                .padding(.bottom)

        }
        .frame(width: 300)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

#Preview {
    AlertPopup(
        selectedTime: .constant(Date()),
        onCancel: {},
        onSave: {}
    )
}


