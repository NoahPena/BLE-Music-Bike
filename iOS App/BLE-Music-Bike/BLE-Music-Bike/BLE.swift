//
//  BLE.swift
//  BLE-Music-Bike
//
//  Created by Tyrone on 4/12/17.
//  Copyright © 2017 Noah Peña. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLE : NSObject, CBCentralManagerDelegate, CBPeripheralDelegate
{
    
    var manager : CBCentralManager!
    var connectedPeripheral : CBPeripheral!
    var mainCharacteristic : CBCharacteristic?
    
    var deviceName : String!
    
    
    init(_ name: String)
    {
        super.init();
        
        deviceName = name;
        
        manager = CBCentralManager(delegate: self, queue: DispatchQueue.main);
    }
    
    
    //MARK:- scan for devices
    func centralManagerDidUpdateState(_ central: CBCentralManager)
    {
        
        switch central.state
        {
            
        case .poweredOn:
            print("powered on")
            
        case .poweredOff:
            print("powered off")
            
        case .resetting:
            print("resetting")
            
        case .unauthorized:
            print("unauthorized")
            
        case .unknown:
            print("unknown")
            
        case .unsupported:
            print("unsupported")
        }
    }
    
    
    //MARK:- connect to a device
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
    {
        
        if (peripheral.name == deviceName)
        {
            print("Connecting");
            
            self.manager.stopScan()
            self.connectedPeripheral = peripheral
            self.connectedPeripheral.delegate = self
            
            manager.connect(peripheral, options: nil);
        }
        
    }
    
    //MARK:- get services on devices
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        print("We connected");
        peripheral.discoverServices(nil)
        
    }
    
    //MARK:- get characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        guard let services = peripheral.services else {
            return
        }
        
        for service in services
        {
            
            peripheral.discoverCharacteristics(nil, for: service)
            
        }
    }
    
    //MARK:- notification
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        guard let characteristics = service.characteristics else {
            return
        }
        
        for characteristic in characteristics
        {
            
            self.mainCharacteristic = characteristic
            
            peripheral.readValue(for: characteristic)
            
            
        }
        
    }
    
    //MARK:- characteristic change
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?)
    {
        
        print(String(data: characteristic.value!, encoding: String.Encoding.utf8) as String!);
        
//        receiveText.text = String(data: characteristic.value!, encoding: String.Encoding.utf8) as String!;
        
    }
    
    
    
    //MARK:- disconnect
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        central.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func scanForPeripherals()
    {
        manager.scanForPeripherals(withServices: nil, options: nil);
    }
    
    func stopScanning()
    {
        manager.stopScan();
    }
    
    func disconnectFromPeripheral()
    {
        manager.cancelPeripheralConnection(connectedPeripheral);
    }
    
    
//    //MARK:- send switch value to peripheral
//    func sendSwitchValue(value: UInt8)
//    {
//        
//        let data = Data(bytes: [value])
//        
//        guard let ledChar = bikeCharacterstic else {
//            return
//        }
//        
//        
//        connectedPeripheral.writeValue(data, for: ledChar, type: .withResponse)
//        
//    }
    

}
