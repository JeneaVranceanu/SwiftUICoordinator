//
//  Coordinator.swift
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

import Foundation
import SwiftUI

/// An update has been made to a stack of some coordinator. Notification object myst contain key-value entry in `userInfo`
/// with key being ``NAVIGATION_STACK_ID`` and value must be either nil or of type ``NavigationStackId``.
public let COORDINATOR_STACK_NOTIFICATION = Notification.Name(rawValue: "COORDINATOR_STACK_NOTIFICATION")
/// Key for the value in `userInfo` dictionary of a notification object. Value must be either nil or of type ``NavigationStackId``.
public let NAVIGATION_STACK_ID = "NAVIGATION_STACK_ID"

/// Default implementation of coordinator pattern. Manages a stack of ``DestinationWrapper``s.
open class Coordinator: ObservableObject {
    
    private let initialDestinationID = DestinationID()
    private let id: NavigationStackId
    
    @Published private(set) var stack: [DestinationWrapper] = []
    private lazy var destinationHandle: DestinationHandle = {
        DestinationHandle { [weak self] destinationWrapper in
            guard let self = self, let idx = self.stack.firstIndex(of: destinationWrapper) else { return }
            self.stack.remove(at: idx)
            self.postNotificationStackUpdate()
        }
    }()
    
    /**
     Debouncer for preventing multiple stack notifications in a short period of time, e.g. when popping all destinations to root.
     */
    private let stackUpdateDebouncer: Debouncer
    
    public init(id: NavigationStackId) {
        self.id = id
        stackUpdateDebouncer = Debouncer {
            NotificationCenter.default.post(name: COORDINATOR_STACK_NOTIFICATION,
                                            object: nil,
                                            userInfo: [NAVIGATION_STACK_ID: id])
        }
    }
    
    public func getId() -> NavigationStackId {
        id
    }
    
    public func popAll() {
        stack.forEach { destination in
            destination.detach(destinationHandle)
        }
        stack.removeAll()
        
        postNotificationStackUpdate()
    }
    
    public func lastDestinationID() -> DestinationID {
        return stack.last?.id ?? initialDestinationID
    }
    
    /**
     Navigates to a destination wrapped by given destination wrapper only if wrapper is not already attached to a stack.
     */
    public func navigateTo(_ dw: DestinationWrapper) {
        if dw.isAttached() || stack.contains(dw) {
            return
        }
        
        dw.attach(destinationHandle)
        stack.append(dw)
        
        postNotificationStackUpdate()
    }
    
    /**
     Pops all destinations that are preceeded by given destination wrapper.
     If this wrapper is not in the stack of this coordinator calling this function has no effect,
     */
    public func popTo(_ dw: DestinationWrapper) {
        guard let index = stack.firstIndex(of: dw) else { return }
        stack[index..<stack.count].forEach { destination in
            destination.detach(destinationHandle)
        }
        stack = stack.dropLast(stack.count - index)
        
        postNotificationStackUpdate()
    }
    
    /**
     - Returns:
     `true` if there is a next destination or `false` otherwise.
     */
    public func hasDestination(after destinationId: DestinationID) -> Bool {
        if destinationId == initialDestinationID {
            return stack.count == 1
        }
        
        guard let index = stack.firstIndex(where: {
            $0.id == destinationId
        }) else {
            return false
        }
        
        return stack.count - 1 > index
    }
    
    /**
     Call `hasDestination` to check if there is a destination to show before calling `destination`.
     If `hasDestination` returns `false` then `destination` will fail with index out of bounds error.
     */
    @ViewBuilder
    public func destination(after destinationId: DestinationID) -> some View {
        if destinationId == initialDestinationID {
            stack.first!.destination()
        } else {
            stack[stack.firstIndex(where: { $0.id == destinationId })! + 1].destination()
        }
    }
    
    public func destination(after destinationId: DestinationID) -> DestinationWrapper? {
        if destinationId == initialDestinationID {
            return stack.first
        } else if let idx = stack.firstIndex(where: { $0.id == destinationId }), idx + 1 < stack.count {
            return stack[idx + 1]
        }
        return nil
    }
    
    public func isActive(_ destinationWrapper: DestinationWrapper?) -> Bool {
        return destinationWrapper != nil && destinationWrapper!.isAttached() && isTopOfTheStack(destinationWrapper)
    }
    
    public func isTopOfTheStack(_ destinationWrapper: DestinationWrapper?) -> Bool {
        guard let destinationWrapper = destinationWrapper else { return false }
        return (stack.firstIndex(of: destinationWrapper) ?? 0) >= stack.count-1
    }
    
    private func postNotificationStackUpdate() {
        stackUpdateDebouncer.call()
    }
}

