//
//  SecondDestinationView.swift
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

class SecondDestinationViewModel: ObservableObject {
    let secondDestinationAgain = FirstDestinationView()
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("Running circles, huh?")
        .asDestination()
    
    let thirdDestination = ThirdDestinationView().asDestination()
    
    @Published var borderColor1: Color = Color(red: Double.random(in: 0...1),
                                              green: Double.random(in: 0...1),
                                              blue: Double.random(in: 0...1))

    @Published var borderColor2: Color = Color(red: Double.random(in: 0...1),
                                               green: Double.random(in: 0...1),
                                               blue: Double.random(in: 0...1))

    @Published var borderColor3: Color = Color(red: Double.random(in: 0...1),
                                               green: Double.random(in: 0...1),
                                               blue: Double.random(in: 0...1))
    
    
    @Published var cornerRadius1: CGFloat = CGFloat.random(in: 0...16)
    @Published var borderWidth1: CGFloat = CGFloat.random(in: 1...6)
    @Published var cornerRadius2: CGFloat = CGFloat.random(in: 0...16)
    @Published var borderWidth2: CGFloat = CGFloat.random(in: 1...6)
    @Published var cornerRadius3: CGFloat = CGFloat.random(in: 0...16)
    @Published var borderWidth3: CGFloat = CGFloat.random(in: 1...6)
    
    let id = UUID().uuidString
    
    init() {
        if TIMERS_ENABLED {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                withAnimation {
                    self.borderColor1 = Color(red: Double.random(in: 0...1),
                                              green: Double.random(in: 0...1),
                                              blue: Double.random(in: 0...1))
                    self.borderColor2 = Color(red: Double.random(in: 0...1),
                                              green: Double.random(in: 0...1),
                                              blue: Double.random(in: 0...1))
                    self.borderColor3 = Color(red: Double.random(in: 0...1),
                                              green: Double.random(in: 0...1),
                                              blue: Double.random(in: 0...1))
                    self.cornerRadius1 = CGFloat.random(in: 0...16)
                    self.borderWidth1 = CGFloat.random(in: 1...6)
                    self.cornerRadius2 = CGFloat.random(in: 0...16)
                    self.borderWidth2 = CGFloat.random(in: 1...6)
                    self.cornerRadius3 = CGFloat.random(in: 0...16)
                    self.borderWidth3 = CGFloat.random(in: 1...6)
                }
            }
        }
    }
}

struct SecondDestinationView: View {
    
    @StateObject private var viewModel = SecondDestinationViewModel()

    @State var notificationName: String

    var body: some View {
        CoordinatorNavigationViewLink { coordinator in
            VStack {
                Button {
                    coordinator.navigateTo(viewModel.thirdDestination)
                } label: {
                    HStack {
                        Text("Navigate to third destination")
                        Image(systemName: "3.square")
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: viewModel.cornerRadius1)
                            .stroke(viewModel.borderColor1,
                                    lineWidth: viewModel.borderWidth1)
                    )
                }
                .padding()

                Button {
                    coordinator.navigateTo(viewModel.secondDestinationAgain)
                } label: {
                    HStack {
                        Text("Or navigate to second destination again?!")
                        Image(systemName: "2.square.fill")
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: viewModel.cornerRadius2)
                            .stroke(viewModel.borderColor2,
                                    lineWidth: viewModel.borderWidth2)
                    )
                }
                .padding()

                if !notificationName.isEmpty {
                    Button {
                        NotificationCenter.default.post(name: NSNotification.Name(notificationName), object: self)
                    } label: {
                        HStack {
                            Text("Replace this screen")
                            Image(systemName: Bool.random() ? "3.square" : "3.square.fill")
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: viewModel.cornerRadius3)
                                .stroke(viewModel.borderColor3,
                                        lineWidth: viewModel.borderWidth3)
                        )
                    }
                    .padding()
                }
            }
        }
    }
}

struct SecondDestinationView_Previews: PreviewProvider {
    static var previews: some View {
        SecondDestinationView(notificationName: "")
    }
}
