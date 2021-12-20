//
//  CoordinatorNavigationView.swift
//  SwiftUICoordinator
//
//  MIT License
//
//  Copyright (c) 2021 Jenea Vranceanu
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import SwiftUI

/// Wrapper around ``SwiftUI.NavigationView`` implementing coordinator pattern.
/// This view reacts to changes in an observed coordinator stack and activates/deactivates respective ``NavigationViewLink``s.
public struct CoordinatorNavigationView<Content> : View where Content : View  {
    
    private var content: (Coordinator) -> Content
    
    @StateObject private var coordinator: Coordinator
    
    /// Initializer.
    /// - Parameters:
    ///   - id: ``NavigationStackId`` to use In
    ///   - coordinator: injected coordinator created on side;
    ///   - content: a @ViewBuilder of the initial destination (the first entry in the stack).
    public init(id: NavigationStackId = .main,
                coordinator: Coordinator? = nil,
                @ViewBuilder content: @escaping (Coordinator) -> Content) {
        self.content = content
        _coordinator = StateObject(wrappedValue: coordinator ?? Coordinator(id: id))
    }
    
    public var body: some View {
        NavigationView {
            VStack {
                content(coordinator)
            }
        }
        /// Setting navigation style fixes crashes related to EnvironmentObjects not being found.
        /// Example of this issue being discussed online
        /// https://www.hackingwithswift.com/forums/swiftui/environment-object-not-being-inherited-by-child-sometimes-and-app-crashes/269/9551
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(coordinator)
    }
}
