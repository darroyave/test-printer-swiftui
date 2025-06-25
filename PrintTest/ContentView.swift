//
//  ContentView.swift
//  PrintTest
//
//  Created by Dannover Arroyave on 25/06/25.
//

import SwiftUI
import CoreBluetooth

struct ContentView: View {
    private var bluetoothManager = BluetoothManager()
    @State private var selectedDevice: CBPeripheral?

    var body: some View {
        NavigationView {
            List(bluetoothManager.discoveredDevices, id: \ .identifier) { device in
                NavigationLink(destination: BluetoothDetailView(peripheral: device)) {
                    Text(device.name ?? "Unknown Device")
                        .onTapGesture {
                            selectedDevice = device
                            bluetoothManager.connect(to: device)
                        }
                }
            }
            .navigationTitle("Bluetooth Scanner")
        }
    }
}

#Preview {
    ContentView()
}
