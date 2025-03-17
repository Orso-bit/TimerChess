//
//  ContentView.swift
//  TimerChess
//
//  Created by Giovanni Jr Di Fenza on 17/03/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var vm = ViewModel()
    @State private var moveTopCount: Int = 0
    @State private var moveBottomCount: Int = 0
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    
                    // Top Rectangle (Green)
                    ZStack {
                        Rectangle()
                            .fill(Color(red: 118/250, green: 150/250, blue: 86/250))
                            .frame(maxHeight: .infinity)
                            .onTapGesture {
                                if !vm.isTopRectActive {
                                    vm.startTopRect(minutes: vm.minutes)
                                } else {
                                    moveTopCount += 1
                                    vm.startBottomRect(minutes: vm.minutes)
                                    vm.stopTopRect()
                                }
                            }
                        Text("move: \(moveTopCount)")
                            .rotationEffect(.degrees(-180))
                            .offset(x: -140, y: 160)
                        Text(vm.topRectTime)
                            .font(.system(size: 100, weight: .medium, design: .rounded))
                            .rotationEffect(.degrees(-180))
                            .onTapGesture {
                                if !vm.isTopRectActive {
                                    vm.startTopRect(minutes: vm.minutes)
                                } else {
                                    moveTopCount += 1
                                    vm.startBottomRect(minutes: vm.minutes)
                                    vm.stopTopRect()
                                }
                            }
                    }

                    // Middle Section (Black Bar with Controls)
                    ZStack (alignment: .leading) {
                        Rectangle()
                            .fill(.black)
                            .frame(height: 80)
                        
                        HStack {
                            
                            // "Reset" Button
                            Button(action: {
                                vm.reset()
                                moveTopCount = 0
                                moveBottomCount = 0
                               
                            }) {
                                Label("", systemImage: "arrow.clockwise")
                                    .imageScale(.large)
                                    .font(.system(size: 30))
                                    .padding()
                            }
                            .onReceive(timer) { _ in
                                // Timer updates will be handled automatically in ViewModel's timers
                            }

                            // Picker with a popup menu to select time (Right aligned)
                            Picker("Select Time", selection: $vm.minutes) {
                                ForEach([3, 5, 10, 15, 30, 90], id: \.self) { minute in
                                    Text("\(minute) min").tag(Float(minute))
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(width: 250)
                            .onChange(of: vm.minutes) { newValue in
                                // Aggiorna i tempi di countdown quando il picker cambia
                                vm.updateTimesForSelectedMinutes()
                            }
                            .disabled(vm.isTopRectActive || vm.isBottomRectActive) // Disables selection if any timer is running
                        }
                        Spacer()
                    }
                    
                    // Bottom Rectangle (White)
                    ZStack {
                        Rectangle()
                            .fill(Color(red: 161/250, green: 102/250, blue: 47/250))
                            .frame(maxHeight: .infinity)
                            .onTapGesture {
                                if !vm.isBottomRectActive {
                                    vm.startBottomRect(minutes: vm.minutes)
                                } else {
                                    moveBottomCount += 1
                                    vm.startTopRect(minutes: vm.minutes)
                                    vm.stopBottomRect()
                                }
                            }
                        Text("move: \(moveBottomCount)")
                            .offset(x: 140, y: -160)
                        Text(vm.bottomRectTime)
                            .font(.system(size: 100, weight: .medium, design: .rounded))
                            .onTapGesture {
                                if !vm.isBottomRectActive {
                                    vm.startBottomRect(minutes: vm.minutes)
                                } else {
                                    moveBottomCount += 1
                                    vm.startTopRect(minutes: vm.minutes)
                                    vm.stopBottomRect()
                                }
                            }
                    }
                }
                .ignoresSafeArea()
            }
        }
    }
}


#Preview {
    ContentView()
}
