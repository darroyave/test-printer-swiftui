//
//  ContentView.swift
//  PrintTest
//
//  Created by Dannover Arroyave on 25/06/25.
//

import SwiftUI
import CoreBluetooth

struct ContentView: View {
    
    @StateObject private var bluetoothManager = BluetoothManager()
    @State private var selectedDevice: CBPeripheral?

    var body: some View {
        
        NavigationView {
            
            VStack {
                
                if bluetoothManager.bluetoothState == .poweredOff {
                    
                    List(bluetoothManager.discoveredDevices, id: \ .identifier) { device in
                        NavigationLink(destination: BluetoothDetailView(peripheral: device)) {
                            Text(device.name ?? "Unknown Device")
                                .onTapGesture {
                                    selectedDevice = device
                                    bluetoothManager.connect(to: device)
                                }
                        }
                    }
                    
                    if !bluetoothManager.isScanning {
                        Button("Start Scanning") {
                            bluetoothManager.startScan()
                        }
                    } else {
                        Button("Stop Scanning") {
                            bluetoothManager.stopScan()
                        }
                    }
                    
                } else {
                    Text("Bluetooth is not powered on.")
                }
            }
            .navigationTitle("Bluetooth Scanner")
            
        }
    }
}

#Preview {
    ContentView()
}
