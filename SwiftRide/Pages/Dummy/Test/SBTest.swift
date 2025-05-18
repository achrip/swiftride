//
//  SBTest.swift
//  SwiftRide
//
//  Created by Ashraf Alif Adillah on 17/05/25.
//

import SwiftUI

struct ScrollViewWithHiddenSearchTitle: View {
    @State private var searchText = ""
    @EnvironmentObject var helper: Helper

    var body: some View {
        NavigationView {
            ScrollView {
                if searchText.isEmpty {
                    Text("Empty??")
                } else {
                    ForEach(0..<50) { i in
                        Text("Row \(i)")
                            .padding()
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle(Text("Searchable List"))
            .searchPresentationToolbarBehavior(.avoidHidingContent)
        }
        .sheet(isPresented: .constant(true)) {
            TestSheetView()
                .presentationDetents(
                    [.fraction(0.1), .fraction(0.3), .medium, .fraction(0.7), .fraction(0.9)],
                    selection: $helper.det
                )
                .presentationBackgroundInteraction(.enabled)
                .presentationContentInteraction(.resizes) // 👈 this line fixes the keyboard jump
        }
        .onChange(of: helper.det) { oldValue, newValue in
            print("Sheet height changed from \(oldValue) to \(newValue)")
        }
        .onChange(of: helper.f) { oldValue, newValue in
            print("value of focus changed from \(oldValue) to \(newValue)")
        }
    }
}

struct TestSheetView: View {
    @EnvironmentObject var helper: Helper
    @FocusState private var focus: Bool

    var body: some View {
        ScrollView {
            TextField("Type here...", text: $helper.st)
                .focused($focus)
                .textFieldStyle(.roundedBorder)
                .padding()

            ForEach(0..<10) { i in
                Text("Row \(i)")
                    .padding(10)
            }
        }
        .onChange(of: focus) { oldValue, newValue in
            helper.f = newValue
            if newValue {
                // 👇 proactively bump to .fraction(0.7) if it's smaller
                if helper.det != .fraction(0.7) && helper.det != .fraction(0.9) {
                    helper.det = .fraction(0.7)
                }
            }
        }
    }
}

class Helper: ObservableObject {
    static let shared = Helper()
    @Published var det: PresentationDetent = .medium
    @Published var st: String = ""
    @Published var f: Bool = false
}

#Preview {
    ScrollViewWithHiddenSearchTitle()
        .environmentObject(Helper.shared)
}
