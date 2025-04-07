import SwiftUI

struct AlertPopup: View {
    @Binding var selectedTime: Date
    @Binding var showConfirmation: Bool
    @State var btnText: String = "Save"
    var onClose: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Button("Back", action: onClose)
                Spacer()
                Text("Set Alert")
                    .font(.headline)
                Spacer()
                Button(btnText) {
                    showConfirmation = true // Tell parent to show alert
                    onClose()  // Then close popup
                }
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

            // Cancel button
            Button("Cancel", action: onClose)
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
        showConfirmation: .constant(false),
        onClose: {}
    )
}


#Preview {
    AlertPopup(
        selectedTime: .constant(Date()), showConfirmation: .constant(false),
        onClose: {}
    )
}
