import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: TollPassStore
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingAdd = false
    @State private var showingPaywall = false
    @State private var showingSettings = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.transponders) { entry in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.name).font(Theme.headlineFont)
                        Text("\(entry.region)")
                            .font(Theme.captionFont)
                            .foregroundStyle(.secondary)
                    }
                }
                .onDelete { store.remove(at: $0) }
            }
            .navigationTitle("Roadtrip Toll Pass")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { showingSettings = true } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("main.settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAdd(isPro: purchases.isPro) {
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("main.addButton")
                }
            }
            .sheet(isPresented: $showingAdd) { AddTransponderView() }
            .sheet(isPresented: $showingPaywall) { PaywallView() }
            .sheet(isPresented: $showingSettings) { SettingsView() }
        }
    }
}

struct AddTransponderView: View {
    @EnvironmentObject var store: TollPassStore
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var region = ""
    @State private var balance = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Name", text: $name)
                        .accessibilityIdentifier("addTransponder.nameField")
                    TextField("Region", text: $region)
                    TextField("Balance", text: $balance).keyboardType(.decimalPad)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture { hideKeyboard() }
            .navigationTitle("Add Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let entry = Transponder(name: name.isEmpty ? "Name" : name, region: region.isEmpty ? "Region" : region, balance: Double(balance) ?? 0)
                        _ = store.add(entry, isPro: purchases.isPro)
                        dismiss()
                    }
                    .accessibilityIdentifier("addTransponder.saveButton")
                }
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
