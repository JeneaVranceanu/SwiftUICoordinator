//
//  FirstDestinationView.swift
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
import SwiftUICoordinator

class FirstDestinationViewModel: ObservableObject {
    let id = UUID().uuidString
    let secondDestination = SecondDestinationView().asDestination()
    
    @Published var borderColor: Color = Color(red: Double.random(in: 0...1),
                                              green: Double.random(in: 0...1),
                                              blue: Double.random(in: 0...1))
    
    init() {
        if TIMERS_ENABLED {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                withAnimation {
                    self.borderColor = Color(red: Double.random(in: 0...1),
                                             green: Double.random(in: 0...1),
                                             blue: Double.random(in: 0...1))
                }
            }
        }
    }
}

struct FirstDestinationView: View {

    static private(set) var INITIAL_DESTINATION_ID: String! = nil

    @State private var destinationId = UUID().uuidString

    @EnvironmentObject private var secondBranchHandle: SecondBranchHandle
    @StateObject private var viewModel = FirstDestinationViewModel()
    
    var body: some View {
        CoordinatorNavigationViewLink { coordinator in
            Button {
                coordinator.navigateTo(SecondDestinationView().asDestination(destinationId))
            } label: {
                HStack {
                    Text("Navigate to second destination")
                    Image(systemName: "2.square")
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(viewModel.borderColor,
                                lineWidth: 1)
                )
            }.onAppear {
                if FirstDestinationView.INITIAL_DESTINATION_ID == nil {
                    FirstDestinationView.INITIAL_DESTINATION_ID = destinationId
                }

                secondBranchHandle.handleFunc = {
                    coordinator.navigateTo(FirstDestinationBranchTwoView().asDestination(FirstDestinationView.INITIAL_DESTINATION_ID))
                }
            }
        }
    }
}

struct FirstDestinationView_Previews: PreviewProvider {
    static var previews: some View {
        FirstDestinationView()
    }
}
