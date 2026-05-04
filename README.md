> ⚠️ This library is under active development. Performance has not been thoroughly benchmarked.

# SwiftUICoordinator

An implementation of the Coordinator pattern for SwiftUI navigation. Instead of managing individual `NavigationLink` state properties per view, you call `coordinator.navigateTo(...)` from anywhere in your view hierarchy and the library handles the rest.

## Requirements

- iOS 14+
- Swift 5.5+

## Installation

### Swift Package Manager

Add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/JeneaVranceanu/SwiftUICoordinator.git", branch: "main")
]
```

Or add it via Xcode: **File → Add Packages**, paste the repository URL, and select the version rule.

## Core concepts

| Type | Role |
|---|---|
| `Coordinator` | Manages a stack of `DestinationWrapper`s and exposes navigation methods. Injected as an `EnvironmentObject`. |
| `CoordinatorNavigationView` | Wraps `NavigationView` and owns a `Coordinator`. Use this instead of `NavigationView`. |
| `CoordinatorNavigationViewLink` | Wraps `NavigationLink`. Listens to the coordinator and activates/deactivates automatically. Use this inside `CoordinatorNavigationView`. |
| `DestinationWrapper` | Wraps a view with an ID and lifecycle (attach/detach). Created via `.asDestination()`. |
| `NavigationStackId` | Identifies a coordinator's navigation stack. Required when using multiple coordinators (e.g. inside a `TabView`). |

## Quick start

Replace `NavigationView` with `CoordinatorNavigationView` and use `CoordinatorNavigationViewLink` in place of `NavigationLink`.

```swift
struct ContentView: View {
    var body: some View {
        CoordinatorNavigationView { _ in
            CoordinatorNavigationViewLink { coordinator in
                Button("Go somewhere") {
                    coordinator.navigateTo(DetailView().asDestination())
                }
            }
        }
    }
}
```

## Navigation API

### Navigate to a destination

```swift
coordinator.navigateTo(SomeView().asDestination())
```

### Navigate to one of several destinations

The coordinator decides which view to push at call time — no predefined links required.

```swift
coordinator.navigateTo(nextScreen()) // returns a DestinationWrapper

func nextScreen() -> DestinationWrapper {
    if user.isLoggedIn {
        return DashboardView().asDestination()
    } else {
        return LoginView().asDestination()
    }
}
```

### Replace the current screen

Pass a `DestinationWrapper` with the same ID to swap the view in-place without pushing a new entry.

```swift
let screenId = "profile-screen"

// First navigation — pushes the screen
coordinator.navigateTo(ProfileView(mode: .view).asDestination(screenId))

// Later — replaces it without adding a new stack entry
coordinator.navigateTo(ProfileView(mode: .edit).asDestination(screenId))
```

Use `onlySwap: true` to replace and keep any screens pushed on top of it:

```swift
coordinator.navigateTo(updatedDestination, onlySwap: true)
```

### Pop to a destination

```swift
coordinator.popTo(someDestinationWrapper)
// or by ID string
coordinator.popTo("profile-screen")
```

### Pop everything (return to root)

```swift
coordinator.popAll()
```

## Multiple coordinators (TabView)

Each tab needs its own coordinator with a unique `NavigationStackId` so they don't interfere with each other.

```swift
struct ContentView: View {
    var body: some View {
        TabView {
            CoordinatorNavigationView(id: NavigationStackId("tab-one")) { _ in
                FirstTabRootView()
            }
            .tabItem { Text("First") }

            CoordinatorNavigationView(id: NavigationStackId("tab-two")) { _ in
                SecondTabRootView()
            }
            .tabItem { Text("Second") }
        }
    }
}
```

`NavigationStackId` has two built-in constants (`.main`, `.secondary`) for simple cases.

## Injecting an existing coordinator

If you need to share a coordinator instance created outside the view (e.g. for testing or a parent coordinator pattern), pass it to the initializer:

```swift
let myCoordinator = Coordinator(id: NavigationStackId("my-stack"))

CoordinatorNavigationView(coordinator: myCoordinator) { _ in
    RootView()
}
```

## Comparison with plain SwiftUI

### Multiple destinations from one view

**Plain SwiftUI** — one `@State` variable per link:

```swift
struct ContentView: View {
    @State var isLink1Active = false
    @State var isLink2Active = false
    @State var isLink3Active = false

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(isActive: $isLink1Active) { View1() } label: { Label1() }
                NavigationLink(isActive: $isLink2Active) { View2() } label: { Label2() }
                NavigationLink(isActive: $isLink3Active) { View3() } label: { Label3() }

                Button("Go to first") { isLink1Active = true }
                Button("Go to second") { isLink2Active = true }
                Button("Go to third") { isLink3Active = true }
            }
        }
    }
}
```

**SwiftUICoordinator** — no state variables:

```swift
struct ContentView: View {
    var body: some View {
        CoordinatorNavigationView { _ in
            CoordinatorNavigationViewLink { coordinator in
                VStack {
                    Button("Go to first") { coordinator.navigateTo(View1().asDestination()) }
                    Button("Go to second") { coordinator.navigateTo(View2().asDestination()) }
                    Button("Go to third") { coordinator.navigateTo(View3().asDestination()) }
                }
            }
        }
    }
}
```

## Demo

https://user-images.githubusercontent.com/36865532/146835356-9f15dea5-cd34-4a06-907c-26d071211223.mov

## Contribution

This repository follows [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).
Feel free to fork and send PRs.

## License

MIT License — see [LICENSE](LICENSE).
