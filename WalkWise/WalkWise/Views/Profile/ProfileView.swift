import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var profileVM: ProfileViewModel

    @State private var showImagePicker = false
    @State private var image: UIImage?

    var body: some View {
        GradientBackgroundView {
            ScrollView {
                VStack(spacing: 16) {
                    // Avatar
                    Button(action: { showImagePicker = true }) {
                        if let data = profileVM.profile?.profileImageData, let ui = UIImage(data: data) {
                            Image(uiImage: ui)
                                .resizable().scaledToFill().frame(width: 100, height: 100).clipShape(Circle())
                        } else {
                            ZStack {
                                Circle().fill(.thinMaterial).frame(width: 100, height: 100)
                                Image(systemName: "person.fill").font(.largeTitle)
                            }
                        }
                    }

                    // Name & email
                    TextField("Name", text: Binding(
                        get: { profileVM.profile?.displayName ?? "" },
                        set: { profileVM.updateName($0) }
                    ))
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                    Text(profileVM.profile?.email ?? authVM.userProfile?.email ?? "")
                        .foregroundStyle(.secondary)

                    // Goal and units
                    VStack(spacing: 8) {
                        Stepper("Daily step goal: \(Int(profileVM.profile?.dailyStepGoal ?? 8000))", value: Binding(
                            get: { Int(profileVM.profile?.dailyStepGoal ?? 8000) },
                            set: { profileVM.updateGoal($0) }
                        ), in: 1000...30000, step: 500)
                        Picker("Units", selection: Binding(
                            get: { profileVM.profile?.units ?? "km" },
                            set: { profileVM.updateUnits($0) }
                        )) {
                            Text("km").tag("km")
                            Text("mi").tag("mi")
                        }.pickerStyle(.segmented)
                    }
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(12)
                    .padding(.horizontal)

                    // Actions
                    VStack(spacing: 12) {
                        Button("Log Out") { authVM.logOut() }
                            .buttonStyle(.borderedProminent)
                        Button(role: .destructive, action: {
                            confirmDelete()
                        }) { Text("Delete Account") }
                    }.padding(.horizontal)
                }
                .padding(.top)
            }
            .navigationTitle("Profile")
            .onAppear { profileVM.loadOrCreateProfile(defaultEmail: authVM.userProfile?.email) }
            .sheet(isPresented: $showImagePicker) {
                PhotosPickerView(image: $image) { img in
                    if let data = img.jpegData(compressionQuality: 0.8) { profileVM.updateImage(data) }
                }
            }
        }
    }

    private func confirmDelete() {
        // You can add a confirmation alert here; simplified for brevity
        authVM.deleteAccount()
    }
}

// Simple wrapper over PHPickerViewController using PhotosPicker
import PhotosUI
struct PhotosPickerView: View {
    @Binding var image: UIImage?
    var onPicked: (UIImage) -> Void

    @State private var item: PhotosPickerItem?

    var body: some View {
        PhotosPicker("Choose Photo", selection: $item, matching: .images)
            .onChange(of: item) { newItem in
                guard let newItem else { return }
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self), let ui = UIImage(data: data) {
                        image = ui
                        onPicked(ui)
                    }
                }
            }
    }
}
