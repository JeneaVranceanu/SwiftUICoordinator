//
//  CoordinatorNavigationViewLinkModel.swift
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

/// View model for the ``CoordinatorNavigationViewLink`` (MVVM pattern).
public class CoordinatorNavigationViewLinkModel: ObservableObject {
    
    @Published public var isActive = false {
        didSet {
            guard let destinationWrapper = destinationWrapper,
                  let coordinator = coordinator else { return }
            // If was active and became inactive and is no longer attached - remove
            if oldValue && !isActive && coordinator.isTopOfTheStack(destinationWrapper) {
                destinationWrapper.detach()
                self.destinationWrapper = nil
            }
        }
    }
    
    private(set) var lastDestinationId: DestinationID!
    private(set) var coordinator: Coordinator!
    private var destinationWrapper: DestinationWrapper? = nil
    
    public init(_ coordinator: Coordinator? = nil) {
        setCoordinator(coordinator)
        NotificationCenter.default.addObserver(self, selector: #selector(stackChanged(_:)), name: COORDINATOR_STACK_NOTIFICATION, object: nil)
    }
    
    deinit {
        destinationWrapper?.detach()
        destinationWrapper = nil
    }
    
    public func setCoordinator(_ coordinator: Coordinator?) {
        if self.coordinator != nil {
            return
        }
        
        guard let coordinator = coordinator else {
            return
        }
        
        self.coordinator = coordinator
        self.lastDestinationId = coordinator.lastDestinationID()
    }
    
    @objc private func stackChanged(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let coordinatorId = userInfo[NAVIGATION_STACK_ID] as? NavigationStackId else {
            fatalError("\(COORDINATOR_STACK_NOTIFICATION) must ALWAYS include key-value entry with NAVIGATION_STACK_ID as the key and value being an instance of `NavigationStackId`.")
        }
        
        if coordinatorId != coordinator.getId() {
            // Navigation stack of a different coordinator has changed.
            // Should ignore this notification.
            return
        }
        
        if let destinationWrapper = destinationWrapper,
           !destinationWrapper.isAttached() {
            isActive = false
            self.destinationWrapper = nil
            return
        }
        
        destinationWrapper = coordinator.destination(after: lastDestinationId)
        let isActive = coordinator.isActive(destinationWrapper)
        if isActive {
            self.isActive = isActive
        }
    }
    
    @ViewBuilder
    public func destination() -> some View {
        if let destination = destinationWrapper {
            destination.destination()
        } else {
            EmptyView()
        }
    }
}
