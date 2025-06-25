import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    // Notifican cambios a la vista
    @Published var discoveredDevices: [CBPeripheral] = []
    @Published var selectedDevice: CBPeripheral?
    @Published var bluetoothState: CBManagerState = .unknown
    @Published var isScanning: Bool = false

    private var centralManager: CBCentralManager!

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: .main)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        bluetoothState = central.state
        if central.state == .poweredOn {
            startScan()
        } else {
            stopScan()
            print("Bluetooth is off or not available")
        }
    }

    func startScan() {
        discoveredDevices.removeAll()
        centralManager.scanForPeripherals(withServices: nil, options: nil)
        isScanning = true
    }

    func stopScan() {
        centralManager.stopScan()
        isScanning = false
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredDevices.contains(where: { $0.identifier == peripheral.identifier }) {
            discoveredDevices.append(peripheral)
        }
    }

    func connect(to peripheral: CBPeripheral) {
        selectedDevice = peripheral
        stopScan()
        centralManager.connect(peripheral, options: nil)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to: \(peripheral.name ?? "Unknown")")
        // Aquí puedes explorar servicios/características
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect: \(error?.localizedDescription ?? "Unknown error")")
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected: \(peripheral.name ?? "Unknown")")
        selectedDevice = nil
    }

    func printTest(to peripheral: CBPeripheral) {
        // Ejemplo: texto de prueba en ASCII (puedes modificar por el comando correcto de tu impresora)
        let printData = "Test print from SwiftUI\n".data(using: .utf8)!
        // Descubre servicios primero si no lo has hecho
        peripheral.delegate = self
        // Aquí asume que el periférico ya está conectado y conoces la característica de escritura
        // Debes reemplazar 'yourCharacteristic' por la característica real de escritura de tu impresora
        if let characteristic = findWriteCharacteristic(for: peripheral) {
            peripheral.writeValue(printData, for: characteristic, type: .withResponse)
        }
    }

    private func findWriteCharacteristic(for peripheral: CBPeripheral) -> CBCharacteristic? {
        // Busca la característica correcta entre los servicios y características del periférico
        // Ejemplo genérico (ajusta según tu impresora)
        for service in peripheral.services ?? [] {
            for characteristic in service.characteristics ?? [] {
                if characteristic.properties.contains(.write) {
                    return characteristic
                }
            }
        }
        return nil
    }
    
}
