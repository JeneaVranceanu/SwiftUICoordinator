//
//  DestinationCoordinator.swift
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

public class DestinationCoordinator: ObservableObject {
    
    private let initialDestinationID = DestinationID()
    
    public static let shared = DestinationCoordinator()
    
    @Published private var stack: [DestinationWrapper] = []
    private lazy var destinationHandle: DestinationHandle = {
        DestinationHandle { destinationWrapper in
            destinationWrapper.detach(self.destinationHandle)
            guard let idx = self.stack.firstIndex(of: destinationWrapper) else { return }
            self.stack.remove(at: idx)
        }
    }()
    
    private init() { }
    
    public func popAll() {
        stack.forEach { destination in
            destination.detach(destinationHandle)
        }
        stack.removeAll()
    }
    
    public func lastDestinationID() -> DestinationID {
        return stack.last?.id ?? initialDestinationID
    }
    
    public func navigateTo(_ dw: DestinationWrapper) {
        if dw.isAttached() || stack.contains(dw) {
            return
        }
        
        dw.attach(destinationHandle)
        stack.append(dw)
    }
    
    public func popTo(_ dw: DestinationWrapper) {
        guard let index = stack.firstIndex(of: dw) else { return }
        stack[index..<stack.count].forEach { destination in
            destination.detach(destinationHandle)
        }
        stack = stack.dropLast(stack.count - index)
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
}

