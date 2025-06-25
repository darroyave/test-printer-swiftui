import SwiftUI
import CoreBluetooth

struct BluetoothDetailView: View {
    let peripheral: CBPeripheral
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            Text("Device Name: \(peripheral.name ?? "Unknown")")
                .font(.headline)
            
            Text("Identifier: \(peripheral.identifier.uuidString)")
            
        }
        .padding()
        .navigationTitle("Device Details")
    }
}
