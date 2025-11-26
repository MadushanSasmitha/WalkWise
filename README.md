# WalkWise

WalkWise is an iOS application built with SwiftUI, organized using MVVM and Core Data for persistent storage.

## Features

- **SwiftUI UI**: Modern, declarative user interface defined in `ContentView.swift` and the `Views` folder.
- **MVVM Architecture**: View logic separated into the `ViewModels` folder.
- **Core Data Persistence**: Local data storage handled in the `CoreData` module.
- **Service Layer**: Reusable logic and integrations placed in the `Services` folder.

> Note: Update this section to describe the concrete features of your app (e.g., step tracking, route planning, etc.) once finalized.

## Project Structure

- **`WalkWiseApp.swift`** – App entry point and scene configuration.
- **`ContentView.swift`** – Main root view.
- **`Views/`** – Reusable SwiftUI views and screens.
- **`ViewModels/`** – View models for each screen, holding presentation logic and state.
- **`CoreData/`** – Core Data stack and related models.
- **`Services/`** – Service classes for data handling, networking, or utilities.
- **`Assets.xcassets/`** – App icons and image assets.
- **`Info.plist`** – App configuration and permissions.

## Requirements

- **Xcode**: 14 or later (recommended)
- **iOS**: 15.0+ deployment target (adjust based on your project settings)
- **Language**: Swift

## Getting Started

1. **Open the project**
   - Open `WalkWise.xcodeproj` or the workspace file in Xcode.

2. **Resolve signing & capabilities**
   - In Xcode, go to the project settings.
   - Set your Team and Bundle Identifier as needed.

3. **Build & run**
   - Choose an iOS Simulator or a connected device.
   - Press `Cmd + R` to build and run the app.

## Customization

- **App Name & Icons**: Update in `Assets.xcassets` and `Info.plist`.
- **Theme & Styles**: Modify colors, typography, and layout in your SwiftUI views.
- **Data Model**: Adjust Core Data entities and attributes according to your needs.

## License

This project is for educational / assignment purposes. Add a specific license here if you intend to share or publish the project.
