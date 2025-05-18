import SwiftUI

struct SearchBar: View {
    @EnvironmentObject var sheetService: SheetService
    @FocusState var isTextFieldFocused: Bool
    @Binding var searchText: String

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)

                TextField("Search Bus Stop", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .focused($isTextFieldFocused)
                    .submitLabel(.search)

                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .transition(.opacity)
                }
            }
            .padding(8)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .animation(.easeInOut, value: isTextFieldFocused)

            if isTextFieldFocused {
                Button("Cancel") {
                    // make it async so that it does not crash.
                    DispatchQueue.main.async {
                        searchText = ""
                        isTextFieldFocused = false
                        sheetService.isSearchBarFocused = false
                    }
                }
                .foregroundColor(.blue)
                .transition(.move(edge: .trailing).combined(with: .opacity))
                .animation(.easeInOut, value: isTextFieldFocused)
            }
        }
        .onChange(of: isTextFieldFocused) { _, focused in
            if sheetService.isSearchBarFocused != focused {
                let prevDetent = sheetService.detent
                sheetService.isSearchBarFocused = focused
                sheetService.detent = focused ? .fraction(0.9) : prevDetent
            }
        }
        .onChange(of: sheetService.isSearchBarFocused) { _, focused in
            if isTextFieldFocused != focused {
                isTextFieldFocused = focused
            }
        }
    }
}

#Preview {
    SearchBar(searchText: .constant(""))
        .environmentObject(SheetService.shared)
}
