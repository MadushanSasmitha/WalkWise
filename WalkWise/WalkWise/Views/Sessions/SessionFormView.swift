import SwiftUI

struct SessionFormView: View {
    @EnvironmentObject var sessionVM: SessionViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var targetMinutes: Int = 30
    @State private var targetDistanceKm: Double = 2.0
    @State private var scheduledTime: Date = Date()
    @State private var hasTime: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Session") {
                    TextField("Name", text: $name)
                    Stepper(value: $targetMinutes, in: 5...240, step: 5) { Text("Target minutes: \(targetMinutes)") }
                    HStack {
                        Text("Target distance (km)")
                        Spacer()
                        Text(String(format: "%.1f", targetDistanceKm))
                    }
                    Slider(value: $targetDistanceKm, in: 0...20, step: 0.1)
                    Toggle("Schedule time", isOn: $hasTime)
                    if hasTime {
                        DatePicker("Time", selection: $scheduledTime, displayedComponents: .hourAndMinute)
                    }
                }
            }
            .navigationTitle(sessionVM.selectedSession == nil ? "Add Session" : "Edit Session")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let s = sessionVM.selectedSession {
                            sessionVM.updateSession(session: s, name: name, targetMinutes: targetMinutes, targetDistanceKm: targetDistanceKm, scheduledTime: hasTime ? scheduledTime : nil)
                        } else {
                            sessionVM.addSession(name: name, targetMinutes: targetMinutes, targetDistanceKm: targetDistanceKm, scheduledTime: hasTime ? scheduledTime : nil)
                        }
                        dismiss()
                    }.bold()
                }
            }
            .onAppear(perform: load)
        }
    }

    private func load() {
        if let s = sessionVM.selectedSession {
            name = s.name
            targetMinutes = Int(s.targetMinutes)
            targetDistanceKm = s.targetDistanceKm
            if let t = s.scheduledTime { hasTime = true; scheduledTime = t }
        }
    }
}
