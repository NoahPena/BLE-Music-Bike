//
//  ViewController.swift
//  BLE-Music-Bike
//
//  Created by Noah Peña on 4/5/17.
//  Copyright © 2017 Noah Peña. All rights reserved.
//

import UIKit



class ViewController: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate
{
    @IBOutlet weak var scanSwitch: UISwitch!
    @IBOutlet weak var receiveText: UILabel!


    @IBOutlet weak var loginSpotifyButton: UIButton!
    
    var playPause = false;
    
    let deviceName = "ESP-GATT-HELLO"
    
    
    var BLEManager : BLE!
    var musicPlayer : SpotifyPlayer!

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        BLEManager = BLE(deviceName);
        
        musicPlayer = SpotifyPlayer(loginSpotifyButton);
        
        
    }
    
    
    
    @IBAction func playButton(_ sender: UIButton)
    {
        
        if(playPause)
        {
            musicPlayer.pause();
        }
        else
        {
            musicPlayer.play();
        }
        
        playPause = !playPause;
    }

    @IBAction func previousButton(_ sender: UIButton)
    {
        musicPlayer.previousSong();
    }

    @IBAction func nextButton(_ sender: UIButton)
    {
        musicPlayer.nextSong();
    }
    
    @IBAction func nextPlaylistButton(_ sender: UIButton)
    {
        musicPlayer.nextPlaylist();
    }
    
    @IBAction func previousPlaylistButton(_ sender: UIButton)
    {
        musicPlayer.previousPlaylist();
    }
    
    @IBAction func shuffleSwitch(_ sender: UISwitch)
    {
        musicPlayer.setShuffle(sender.isOn);
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginToSpotify(_ sender: UIButton)
    {
        musicPlayer.loginToSpotify();
    }
    
    
    @IBAction func BLEEnableSwitch(_ sender: UISwitch)
    {
        if(scanSwitch.isOn)
        {
            print("Scanning");
            BLEManager.scanForPeripherals();
            //manager.scanForPeripherals(withServices: nil, options: nil);
        }
        else
        {
            print("Shutting Down");
            BLEManager.stopScanning();
            BLEManager.disconnectFromPeripheral();
            //manager.stopScan();
            //manager.cancelPeripheralConnection(connectedPeripheral);
        }
        
    }
    
    
    
}

