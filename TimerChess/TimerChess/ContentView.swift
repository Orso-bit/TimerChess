//
//  ContentView.swift
//  TimerChess
//
//  Created by Giovanni Jr Di Fenza on 17/03/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var vm = ViewModel()
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
                                    vm.stopTopRect()
                                }
                            }
                        Text(vm.topRectTime)
                            .font(.system(size: 100, weight: .medium, design: .rounded))
                            .rotationEffect(.degrees(-180))
                            .onTapGesture {
                                if !vm.isTopRectActive {
                                    vm.startTopRect(minutes: vm.minutes)
                                } else {
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
                                ForEach(1...15, id: \.self) { minute in
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
                                    vm.stopBottomRect()
                                }
                            }
                        Text(vm.bottomRectTime)
                            .font(.system(size: 100, weight: .medium, design: .rounded))
                            .onTapGesture {
                                if !vm.isBottomRectActive {
                                    vm.startBottomRect(minutes: vm.minutes)
                                } else {
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
