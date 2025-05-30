import SwiftUI

struct SearchBar: View {
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
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .animation(.easeInOut, value: isTextFieldFocused)

            if isTextFieldFocused {
                Button("Cancel") {
                    // make it async so that it does not crash.
                    DispatchQueue.main.async {
                        searchText = ""
                        isTextFieldFocused = false
                    }
                }
                .foregroundColor(.blue)
                .transition(.move(edge: .trailing).combined(with: .opacity))
                .animation(.smooth, value: isTextFieldFocused)
            }
        }
    }
}

#Preview {
    SearchBar(searchText: .constant(""))
}
