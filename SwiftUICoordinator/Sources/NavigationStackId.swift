//
//  NavigationStackId.swift
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

/**
 `NavigationStackId` specifies which stack (which ``SwiftUI.NavigationView``) it represents.
 */
public class NavigationStackId: Equatable {
    public static func == (lhs: NavigationStackId, rhs: NavigationStackId) -> Bool {
        lhs.internalId == rhs.internalId
    }
    
    public static let main = NavigationStackId(UUID().uuidString)
    public static let secondary = NavigationStackId(UUID().uuidString)
    
    public let internalId: String
    
    public init(_ id: String) {
        internalId = id
    }
}
