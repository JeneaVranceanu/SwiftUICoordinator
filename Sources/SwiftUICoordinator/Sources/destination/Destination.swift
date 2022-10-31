//
//  Destination.swift
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

/**
 Class connecting `DestinationWrapper` with its Coordinator.
 */
public class DestinationHandle: Equatable {
    public static func == (lhs: DestinationHandle, rhs: DestinationHandle) -> Bool {
        lhs.id == rhs.id
    }
    
    public let id = UUID()
    private let detachDestination: (DestinationWrapper) -> Void
    
    public init(_ detachDestination: @escaping (DestinationWrapper) -> Void) {
        self.detachDestination = detachDestination
    }
    
    public func detach(_ dw: DestinationWrapper) {
        detachDestination(dw)
    }
}

/**
 Wrapper for View creation.
 */
public class DestinationCreator {
    
    private let instance: () -> AnyView
    
    public init(_ instance: @escaping () -> AnyView) {
        self.instance = instance
    }
    
    @ViewBuilder
    public func create() -> some View {
        instance()
    }
}

public class DestinationID: ObservableObject, Equatable, Hashable {
    public static func == (lhs: DestinationID, rhs: DestinationID) -> Bool {
        lhs.id == rhs.id
    }
    
    public let id: String
    
    public init(_ id: String = UUID().uuidString) {
        self.id = id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

/**
 Contains all the logic for attaching/detaching a destination (view) to hierarchy.
 */
public class DestinationWrapper: ObservableObject, Equatable, Hashable {
    public static func == (lhs: DestinationWrapper, rhs: DestinationWrapper) -> Bool {
        lhs.id == rhs.id
    }
    
    public let id: DestinationID
    
    private let destinationCreator: DestinationCreator
    private var destinationHandle: DestinationHandle? = nil
    
    private var _isActive = true
    public lazy var isActive: Binding<Bool> = {
        Binding {
            return self._isActive
        } set: {
            self._isActive = $0
            if !$0 {
                self.detach()
            }
        }
    }()
    
    public init(id: DestinationID = DestinationID(), _ destinationCreator: DestinationCreator) {
        self.id = id
        self.destinationCreator = destinationCreator
    }
    
    /// If the destination is dynamic, meaning it depends on the input, make sure that this input always has the same ID.
    public convenience init(id: String, _ destinationCreator: DestinationCreator) {
        self.init(id: DestinationID(id), destinationCreator)
    }
    
    public func isAttached() -> Bool {
        return destinationHandle != nil
    }
    
    public func attach(_ destinationHandle: DestinationHandle) {
        self.destinationHandle = destinationHandle
        _isActive = true
    }
    
    public func detach(_ destinationHandle: DestinationHandle) {
        guard self.destinationHandle == nil || self.destinationHandle == destinationHandle else {
            return
        }
        self.destinationHandle = nil
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public func detach() {
        destinationHandle?.detach(self)
    }
    
    @ViewBuilder
    public func destination() -> some View {
        destinationCreator.create()
    }
}
