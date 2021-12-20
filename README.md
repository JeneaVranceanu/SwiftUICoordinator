> ⚠️ This library is in alpha state and poorly tested especially performance wise.

# SwiftUICoordinator
A seemingly successful attempt at implementing Coordinator pattern in SwiftUI.

Custom coordinators are not yet supported out of the box. Currently, using provided custom views (`CoordinatorNavigationView` and `CoordinatorNavigationViewLink`) you get access to a coordinator that is capable of presenting any destination that you give it without the need to create multiple `NavigationLink`s and handling state of each navigation link individually.

## How to use

`CoordinatorNavigationView` must be used instead of `NavigationView`.
Subviews must use `CoordinatorNavigationViewLink` if you want to navigate from them. See examples.

## Difference in code

Example 1:
```
/// Default SwiftUI
var body: some View {
    VStack {
        NavigationLink {
            DestinationView()
        } label: {
            Text("Click me")
        }
    }
}

------------

/// With SwiftUICoordinator - a bit lenghty if there is only one link.
struct ContentView: View {
    var body: some View {
        CoordinatorNavigationView { _ in
            CoordinatorNavigationViewLink { coordinator in
                Button {
                    coordinator.navigateTo(SecondDestinationView().asDestination())
                } label: {
                    Text("Click me")
                }
            }
        }
    }
}
```

Example 2:
```
/// Default SwiftUI. Now SwiftUI takes more space.
struct ContentView: View {
    
    @State var isLink1Active = false
    @State var isLink2Active = false
    @State var isLink3Active = false
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(isActive: $isLink1Active) {
                    SomeDestinationView()
                } label: {
                    SomeLabelView()
                }
                
                NavigationLink(isActive: $isLink2Active) {
                    SomeDestinationView2()
                } label: {
                    SomeLabelView2()
                }
                
                NavigationLink(isActive: $isLink3Active) {
                    SomeDestinationView3()
                } label: {
                    SomeLabelView3()
                }
                
                Button {
                    isLink1Active = true
                } label: {
                    Text("Activate first link")
                }
                
                Button {
                    isLink2Active = true
                } label: {
                    Text("Activate second link")
                }
                
                Button {
                    isLink3Active = true
                } label: {
                    Text("Activate third link")
                }
            }
        }
    }
}

------------

/// With SwiftUICoordinator
struct ContentView: View {
    var body: some View {
        CoordinatorNavigationView { _ in
            CoordinatorNavigationViewLink { coordinator in
                VStack {
                    Button {
                        coordinator.navigateTo(FirstDestinationView().asDestination())
                    } label: {
                        Text("Activate first link")
                    }
                    
                    Button {
                        coordinator.navigateTo(SecondDestinationView().asDestination())
                    } label: {
                        Text("Activate second link")
                    }
                    
                    Button {
                        coordinator.navigateTo(ThirdDestinationView().asDestination())
                    } label: {
                        Text("Activate third link")
                    }
                }
            }
        }
    }
}
```

Example 3 - _No predifined destination_ - :

```
/// Default SwiftUI - not really possible without custom views/code(?)
...

------------

/// With SwiftUICoordinator
struct ContentView: View {
    var body: some View {
        CoordinatorNavigationView { _ in
            CoordinatorNavigationViewLink { coordinator in
                VStack {
                    Button {
                        coordinator.navigateTo(getNextDestination())
                    } label: {
                        Text("Activate first link")
                    }
                }
            }
        }
    }
    
    /// Do your calculations and decide where to go next.
    /// Probably quite rare case but a possible one
    /// - Returns: next destination
    func getNextDestination() -> DestinationWrapper {
        if Bool.random() {
            return SecondDestinationView().asDestination()
        } else {
            return ThirdDestinationView().asDestination()
        }
    }
}
```

# Demo

https://user-images.githubusercontent.com/36865532/146835356-9f15dea5-cd34-4a06-907c-26d071211223.mov


# Contribution
This repository is following [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).
Feel free to fork and send PRs to this repository. 
