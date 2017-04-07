//
//  ViewController.swift
//  BLE-Music-Bike
//
//  Created by Noah Peña on 4/5/17.
//  Copyright © 2017 Noah Peña. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreMotion
import BlueCapKit


class ViewController: UIViewController
{
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var sendText: UITextField!
    @IBOutlet weak var receiveText: UILabel!


    //UUID: "000000ff-0000-1000-8000-00805f9b34fb"
    
    let manager = CentralManager(options: [CBCentralManagerOptionRestoreIdentifierKey : "us.gnos.BlueCap.central-manager-documentation" as NSString])
    
    
    
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
    

        
    }
    
    


}

