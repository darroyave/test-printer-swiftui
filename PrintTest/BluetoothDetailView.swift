import SwiftUI
import CoreBluetooth

struct BluetoothDetailView: View {
    let peripheral: CBPeripheral
    @ObservedObject var bluetoothManager: BluetoothManager
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            Text("Device Name: \(peripheral.name ?? "Unknown")")
                .font(.headline)
            
            Text("Identifier: \(peripheral.identifier.uuidString)")

            Button("Print Test") {
                bluetoothManager.printTest(to: peripheral)
            }
            .padding(.top, 20)
            
        }
        .padding()
        .navigationTitle("Device Details")
    }
}
