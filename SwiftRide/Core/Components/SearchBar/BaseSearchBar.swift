import SwiftUI

struct SearchBar: View, Sendable {
    @Binding var searchText: String
    @FocusState.Binding var focus: Bool

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)

                TextField("Search Bus Stop", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .focused($focus)
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
            .animation(.easeInOut, value: focus)

            if focus {
                Button("Cancel") {
                    // make it async so that it does not crash.
                    //DispatchQueue.main.async {
                    searchText = ""
                    focus = false
                    //}
                }
                .foregroundColor(.blue)
                .transition(.move(edge: .trailing).combined(with: .opacity))
                .animation(.smooth, value: focus)
            }
        }
    }
}

#Preview {
    @FocusState var focus
    SearchBar(searchText: .constant(""), focus: $focus)
}
