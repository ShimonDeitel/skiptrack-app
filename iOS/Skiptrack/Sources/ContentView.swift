import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingAdd = false
    @State private var showingPaywall = false
    @State private var showingSettings = false

    @State private var draftName: String = ""
    @State private var draftAllowedAbsences: Int = 0
    @State private var draftAbsencesUsed: Int = 0

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                List {
                    ForEach(store.items) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name)
                                .font(Theme.bodyFont)
                                .foregroundStyle(.primary)
                            if !("allowedAbsences: \(item.allowedAbsences)" + " · " + "absencesUsed: \(item.absencesUsed)".isEmpty) {
                                Text("allowedAbsences: \(item.allowedAbsences)" + " · " + "absencesUsed: \(item.absencesUsed)")
                                    .font(Theme.captionFont)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .listRowBackground(Theme.cardBackground)
                    }
                    .onDelete { offsets in
                        store.delete(at: offsets)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Skiptrack")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAddMore {
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("addButton")
                }
            }
            .sheet(isPresented: $showingAdd) {
                addSheet
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
                    .environmentObject(purchases)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
                    .environmentObject(store)
                    .environmentObject(purchases)
            }
        }
    }

    private var addSheet: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $draftName)
                    .accessibilityIdentifier("field_name")
                TextField("Allowedabsences", value: $draftAllowedAbsences, format: .number)
                    .keyboardType(.numberPad)
                    .accessibilityIdentifier("field_allowedAbsences")
                TextField("Absencesused", value: $draftAbsencesUsed, format: .number)
                    .keyboardType(.numberPad)
                    .accessibilityIdentifier("field_absencesUsed")
            }
            .navigationTitle("Add Class")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingAdd = false
                    }
                    .accessibilityIdentifier("cancelAddButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let item = Class(name: draftName, allowedAbsences: draftAllowedAbsences, absencesUsed: draftAbsencesUsed)
                        store.add(item)
                        resetDraft()
                        showingAdd = false
                    }
                    .accessibilityIdentifier("saveAddButton")
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }

    private func resetDraft() {
        draftName = ""
        draftAllowedAbsences = 0
        draftAbsencesUsed = 0
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
