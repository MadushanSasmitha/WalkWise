import SwiftUI

struct SessionsView: View {
    @EnvironmentObject var sessionVM: SessionViewModel

    var body: some View {
        GradientBackgroundView {
            List {
                ForEach(sessionVM.sessions, id: \.id) { s in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(s.name).font(.headline)
                            Spacer()
                            if let t = s.scheduledTime {
                                Text(t.formatted(date: .omitted, time: .shortened)).font(.caption)
                            }
                        }
                        HStack(spacing: 16) {
                            Label("\(s.targetMinutes) min", systemImage: "clock")
                            Label(String(format: "%.1f km", s.targetDistanceKm), systemImage: "map")
                        }.font(.subheadline).foregroundStyle(.secondary)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture { sessionVM.selectedSession = s; sessionVM.showAddEditSheet = true }
                }
                .onDelete(perform: sessionVM.deleteSession)
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Walk Sessions")
            .toolbar { Button(action: { sessionVM.selectedSession = nil; sessionVM.showAddEditSheet = true }) { Image(systemName: "plus") } }
            .sheet(isPresented: $sessionVM.showAddEditSheet) {
                SessionFormView()
                    .environmentObject(sessionVM)
            }
        }
        .onAppear { sessionVM.loadSessions() }
    }
}
