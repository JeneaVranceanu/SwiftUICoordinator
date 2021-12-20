//
//  RootCoordinator.swift
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

/**
 Your application should have a custom defined coordinator that will be responsible for creating root views that are wrapped with
 `NavigationView` or that have a `NavigationView` inside. Note: that if `NavigationView` is not a root view you must make
 sure that all `NavigationLink`s will be hierarchicaly inside of `NavigationView`. Otherwise navigation will not work.
 */


import Foundation
import SwiftUI

enum RootDestination: String {
    case destination1
    case destination2
}

class RootCoordinator: ObservableObject {
    static let shared = RootCoordinator()
    
    private(set) var destination: RootDestination {
        didSet {
            rawDestination = destination.rawValue
        }
    }
    @Published var rawDestination: String!
    
    private init() {
        // Write your business logic here that will decide which destination should be
        // the first one.
        destination = .destination1
    }
    
    func navigateTo(_ destination: RootDestination) {
        withAnimation {
            DestinationCoordinator.shared.popAll()
            self.destination = destination
        }
    }
    
    @ViewBuilder
    func destinationView() -> some View {
        switch destination {
            case .destination1:
                CoordinatorNavigationView {
                    VStack {
                        Text("This is real!")
                        
                        Button {
                            
                        } label: {
                            Text("Press me!")
                                .foregroundColor(Color.cyan)
                        }
                        
                        CoordinatorNavigationViewLink { coordinator in
                            VStack {
                                Button {
                                    
                                } label: {
                                    
                                    Text("Press me too!")
                                        .foregroundColor(Color.cyan)
                                }
                                
                            }
                        }
                        
                    }
                }
                NavigationView {
                    EmptyView() // Replace with your primary root destination
                }.transition(.slide)
            case .destination2:
                NavigationView {
                    EmptyView() // Replace with your secondary root destination
                }.transition(.slide)
        }
    }
    
    /**
     As an alternative you could wrap whole switch with `NavigationView`.
     Add custom overlays, effects, paddings etc.
     */
    //    @ViewBuilder
    //    func destinationView() -> some View {
    //        CoordinatorNavigationView {
    //            switch destination {
    //                case .destination1:
    //                    EmptyView() // Replace with your primary root destination
    //                        .transition(.slide)
    //                case .destination2:
    //                    EmptyView() // Replace with your secondary root destination
    //                        .transition(.slide)
    //            }
    //        }
    //    }
}



private let NewProfileSetPasswordDestination = DestinationWrapper(DestinationCreator({
    AnyView(VStack {
        
    }
                .navigationBarTitle("Create password", displayMode: .inline))
}))

