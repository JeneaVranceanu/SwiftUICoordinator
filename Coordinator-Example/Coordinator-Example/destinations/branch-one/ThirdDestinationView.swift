//
//  ThirdDestinationView.swift
//  Coordinator-Example
//
//  MIT License
//
//  Copyright (c) 2022 Jenea Vranceanu
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

struct ThirdDestinationView: View {

    /// An object that allows transmission of a request to replace the first branch with the second branch.
    @EnvironmentObject private var secondBranchHandle: SecondBranchHandle

    var body: some View {
        VStack {
            Text("Hello, World!\nFinally 💻☕️")
                .padding(32)

            Text("or...")
                .padding(8)

            Button {
                secondBranchHandle.handleFunc?()
            } label: {
                HStack {
                    Text("Navigate to a destination on a different branch")
                    Image(systemName: "arrow.triangle.branch")
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray, lineWidth: 2)
                )
            }
            .padding()
        }
    }
}

struct ThirdDestinationView_Previews: PreviewProvider {
    static var previews: some View {
        ThirdDestinationView()
    }
}
