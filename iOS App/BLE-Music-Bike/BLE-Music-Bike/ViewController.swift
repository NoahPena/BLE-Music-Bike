//
//  ViewController.swift
//  BLE-Music-Bike
//
//  Created by Noah Peña on 4/5/17.
//  Copyright © 2017 Noah Peña. All rights reserved.
//

import UIKit
import CoreBluetooth
import Alamofire


struct SpotifyDuple
{
    let URI : String
    let Name : String
    
    init(_ name: String, _ uri: String)
    {
        self.Name = name;
        self.URI = uri;
    }
}


class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate
{
    @IBOutlet weak var scanSwitch: UISwitch!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var sendText: UITextField!
    @IBOutlet weak var receiveText: UILabel!

    @IBOutlet weak var loginSpotifyButton: UIButton!

    var manager : CBCentralManager!
    var connectedPeripheral : CBPeripheral!
    var bikeCharacterstic : CBCharacteristic?
    
    let deviceName = "ESP-GATT-HELLO"
    
    var auth = SPTAuth.defaultInstance()!
    var session : SPTSession!
    
    var player : SPTAudioStreamingController?
    var loginUrl: URL?
    
    var authToken : String!
    var userName : String!
    
    var songs : [SpotifyDuple] = []
    var playlists : [SpotifyDuple] = []

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setup();
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSuccessfull"), object: nil)

        
        manager = CBCentralManager(delegate: self, queue: DispatchQueue.main);
        
        
    }
    


    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginToSpotify(_ sender: UIButton)
    {
        if UIApplication.shared.openURL(loginUrl!)
        {
            if auth.canHandle(auth.redirectURL)
            {
                
            }
        }
    }
    
    
    @IBAction func BLEEnableSwitch(_ sender: UISwitch)
    {
        if(scanSwitch.isOn)
        {
            print("Scanning");
            manager.scanForPeripherals(withServices: nil, options: nil);
        }
        else
        {
            print("Shutting Down");
            manager.stopScan();
            manager.cancelPeripheralConnection(connectedPeripheral);
        }
        
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
        
        if (peripheral.name == "ESP_GATTS_DEMO")
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
            
                self.bikeCharacterstic = characteristic
                
                peripheral.readValue(for: characteristic)
            
            
        }
        
    }
    
    //MARK:- characteristic change
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?)
    {

        print(String(data: characteristic.value!, encoding: String.Encoding.utf8) as String!);
        
        receiveText.text = String(data: characteristic.value!, encoding: String.Encoding.utf8) as String!;
        
    }
    
    
    
    //MARK:- disconnect
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        central.scanForPeripherals(withServices: nil, options: nil)
    }
    

    
    //MARK:- send switch value to peripheral
    func sendSwitchValue(value: UInt8)
    {
        
        let data = Data(bytes: [value])
        
        guard let ledChar = bikeCharacterstic else {
            return
        }
        
        
        connectedPeripheral.writeValue(data, for: ledChar, type: .withResponse)
        
    }
    
    //Spotify Crap 
    
    func setup()
    {
        SPTAuth.defaultInstance().clientID = "68f07eca3ba04a368e92b3c360e19d28"
        SPTAuth.defaultInstance().redirectURL = URL(string: "BLEBikeApp://")
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        loginUrl = SPTAuth.defaultInstance().spotifyWebAuthenticationURL()
    }
    
    func updateAfterFirstLogin ()
    {
        loginSpotifyButton.isHidden = true;
        let userDefaults = UserDefaults.standard
        
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject?
        {
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            self.userName = self.session.canonicalUsername
            print(self.session.canonicalUsername);
            initializePlayer(authSession: session)
        }
    }
    
    func initializePlayer(authSession:SPTSession)
    {
        if self.player == nil
        {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self
            self.player!.delegate = self
            try! player!.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
            self.authToken = authSession.accessToken;
        }
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!)
    {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("logged in")
    
        let playListRequest = try! SPTPlaylistList.createRequestForGettingPlaylists(forUser: userName, withAccessToken: authToken)
        
        Alamofire.request(playListRequest).response
        {
            response in

            let list = try! SPTPlaylistList(from: response.data, with: response.response)
            
            for playList in list.items
            {
                if let playlist = playList as? SPTPartialPlaylist
                {
                    print(playlist.name)
                    print(playlist.uri)
                    
//                    self.playlists.append(SpotifyDuple(playlist.name, playlist.uri));
                    
                    let stringFromUrl = playlist.uri.absoluteString
                    let uri = URL(string: stringFromUrl)
                    
                    SPTPlaylistSnapshot.playlist(withURI: uri, accessToken: self.authToken!)
                    {
                        (error, snap) in
                        
                            if let s = snap as? SPTPlaylistSnapshot
                            {
                                print(s.name)
                                
                                for track in s.firstTrackPage.items
                                {
                                    if let thisTrack = track as? SPTPlaylistTrack
                                    {
                                        print(thisTrack.name)
            
                                    }
                                }
                            }
                    }
                }
            }
        }
        
//        self.player?.playSpotifyURI("spotify:track:58s6EuEYJdlb0kO7awm3Vp", startingWith: 0, startingWithPosition: 0, callback:
//            { (error) in
//            if (error != nil)
//            {
//                print("playing!")
//            }
//        })
    }

}

