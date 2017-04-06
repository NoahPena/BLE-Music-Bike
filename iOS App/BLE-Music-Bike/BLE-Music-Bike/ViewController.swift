//
//  ViewController.swift
//  BLE-Music-Bike
//
//  Created by Noah Peña on 4/5/17.
//  Copyright © 2017 Noah Peña. All rights reserved.
//

import UIKit

import RxBluetoothKit
import RxSwift

import CoreBluetooth

class ViewController: UIViewController
{
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var sendText: UITextField!
    @IBOutlet weak var receiveText: UILabel!
    
    let manager = BluetoothManager(queue: .main);


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
//        manager.scanForPeripherals(withServices: [CBUUID.init(string: "000000ff-0000-1000-8000-00805f9b34fb")]).flatMap
//            {
//                scannedPeripheral in
//                    let advertisement = scannedPeripheral.advertisement
//        }
        
        
//        
//        manager.scanForPeripherals(withServices: [CBUUID.init(string: "000000ff-0000-1000-8000-00805f9b34fb")]).take(1)
        
        
        
        
        manager.scanForPeripherals(withServices: [CBUUID.init(string: "000000ff-0000-1000-8000-00805f9b34fb")]).take(1).flatMap
            {
                $0.peripheral.connect()
            }.subscribe(onNext:
                {
                    peripheral in
                        print("Connected to: \(peripheral)")
            })
    

        
    }
    
    


}

