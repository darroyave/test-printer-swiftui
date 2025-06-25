import SwiftUI
import CoreBluetooth

struct ContentView: View {
    @StateObject private var bluetoothManager = BluetoothManager()
    @State private var selectedDevice: CBPeripheral?

    var body: some View {
        NavigationView {
            VStack {
                if bluetoothManager.bluetoothState == .poweredOn {
                    List(bluetoothManager.discoveredDevices, id: \.identifier) { device in
                        NavigationLink(
                            destination: BluetoothDetailView(peripheral: device, bluetoothManager: bluetoothManager)
                                .onAppear {
                                    selectedDevice = device
                                    bluetoothManager.connect(to: device)
                                }
                        ) {
                            Text(device.name ?? "Unknown Device")
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
