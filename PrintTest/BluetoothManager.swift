//
//  BluetoothManager.swift
//  PrintTest
//
//  Created by Dannover Arroyave on 25/06/25.
//

import Foundation
import CoreBluetooth

@Observable
final class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var discoveredDevices: [CBPeripheral] = []
    var selectedDevice: CBPeripheral?
    private var centralManager: CBCentralManager!

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("Bluetooth is off or not available")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredDevices.contains(peripheral) {
            discoveredDevices.append(peripheral)
        }
    }

    func connect(to peripheral: CBPeripheral) {
        selectedDevice = peripheral
        centralManager.stopScan()
        centralManager.connect(peripheral, options: nil)
    }
}
