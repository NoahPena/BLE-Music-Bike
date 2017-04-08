//
//  ViewController.swift
//  BLE-Music-Bike
//
//  Created by Noah Peña on 4/5/17.
//  Copyright © 2017 Noah Peña. All rights reserved.
//

import UIKit
import CoreBluetooth
import BlueCapKit


public enum AppError : Error
{
    case dataCharactertisticNotFound
    case enabledCharactertisticNotFound
    case updateCharactertisticNotFound
    case serviceNotFound
    case invalidState
    case resetting
    case poweredOff
    case unknown
    case unlikley
}


class ViewController: UIViewController
{
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var sendText: UITextField!
    @IBOutlet weak var receiveText: UILabel!


    //UUID: "000000ff-0000-1000-8000-00805f9b34fb"
    
    let BLE_DEVICE_NAME = "ESP_GATTS_DEMO";
    
    let manager = CentralManager(options: [CBCentralManagerOptionRestoreIdentifierKey : "us.gnos.BlueCap.central-manager-documentation" as NSString])
    
//    let serviceUUID = CBUUID(string: "000000ff-0000-1000-8000-00805f9b34fb");
//    let serviceUUID = CBUUID(string: "FE6670D3-BFD3-4150-8709-1BB3524BDA2D");
    let serviceUUID = CBUUID(string: "CDAB");
    
    var peripheral : Peripheral?
    
    var bikeDataCharacteristic : Characteristic?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func scanButtonPressed(_ sender: UIButton)
    {
        
        print("pressed");
    
        let scanFuture = manager.whenStateChanges().flatMap
        {
            [weak manager] state -> FutureStream<Peripheral> in
                guard let manager = manager
            else
            {
                throw AppError.unlikley;
            }
            
            switch state
            {
            case .poweredOn:
//                return manager.startScanning(forServiceUUIDs: [self.serviceUUID]);
                return manager.startScanning();
            default:
                throw AppError.unknown;
            }
        }
        
        scanFuture.onFailure
        {
            [weak manager] error in
                guard let appError = error as? AppError
            else
            {
                return;
            }
            
            switch appError
            {
            case .invalidState:
                break;
            case .resetting:
                manager?.reset();
            case .poweredOff:
                break;
            default:
                break;
            }
        }
        
        let connectionFuture = scanFuture.flatMap
        {
            [weak manager] discoveredPeripheral -> FutureStream<Void> in
                manager?.stopScanning();
            print(discoveredPeripheral.name);
                self.peripheral = discoveredPeripheral;
                return self.peripheral!.connect(connectionTimeout: 10.0);
        }
        
        let discoveryFuture = connectionFuture.flatMap
        {
            [weak peripheral] () -> Future<Void> in
            guard let peripheral = peripheral
            else
            {
                throw AppError.unlikley
            }
//                return peripheral.discoverServices([self.serviceUUID])
                print("got here");
                return peripheral.discoverAllServices();
            }.flatMap
            {
                [weak peripheral] () -> Future<Void> in
//                guard let peripheral = peripheral, let service = peripheral.services(withUUID: self.serviceUUID)?.first
                guard let peripheral = peripheral, let service = peripheral.services.first
                else
                {
                    throw AppError.serviceNotFound
                }
                print("discovering characteristics");
                return service.discoverAllCharacteristics();
        }
        
        discoveryFuture.onFailure
        {
            [weak peripheral] error in
            switch error
            {
            case PeripheralError.disconnected:
                print("Peripheral disconnected");
                peripheral?.reconnect()
            case AppError.serviceNotFound:
                print("No Services found");
                break
            default:
                print("Something else happended");
                break
            }
        }
        
        
        let subscriptionFuture = discoveryFuture.flatMap
        {
            [weak peripheral] () -> Future<Void> in
//            guard let peripheral = peripheral, let service = peripheral.services(withUUID: self.serviceUUID)?.first
            guard let peripheral = peripheral, let service = peripheral.services.first
                else
                {
                    throw AppError.serviceNotFound
                }
            guard let dataCharacteristic = service.characteristics.first
                else
                {
                    throw AppError.dataCharactertisticNotFound;
                }
            self.bikeDataCharacteristic = dataCharacteristic;
            print(service.name);
            print(service.uuid.uuidString)
            return dataCharacteristic.read(timeout: 10.0);
        }.flatMap
        {
            [weak bikeDataCharacteristic] () -> Future<Void> in
                guard let bikeDataCharacteristic = bikeDataCharacteristic
            else
            {
                throw AppError.dataCharactertisticNotFound
            }
            return bikeDataCharacteristic.startNotifying();
        }.flatMap
        {
            [weak bikeDataCharacteristic] () -> FutureStream<Data?> in
                guard let bikeDataCharacteristic = bikeDataCharacteristic
            else
            {
                throw AppError.dataCharactertisticNotFound
            }
            return bikeDataCharacteristic.receiveNotificationUpdates(capacity: 10);
        }
        
        
        subscriptionFuture.onFailure
        {
            [weak peripheral] error in
            
            switch error
            {
            case PeripheralError.disconnected:
                peripheral?.reconnect()
            case AppError.serviceNotFound:
                break;
            case AppError.dataCharactertisticNotFound:
                break;
            default:
                break;
            }
        }
    }


}

