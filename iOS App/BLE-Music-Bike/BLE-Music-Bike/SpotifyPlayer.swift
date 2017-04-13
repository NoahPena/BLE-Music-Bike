//
//  SpotifyPlayer.swift
//  BLE-Music-Bike
//
//  Created by Tyrone on 4/12/17.
//  Copyright © 2017 Noah Peña. All rights reserved.
//

import Foundation
import Alamofire
import AVFoundation

class SpotifyPlayer : NSObject, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate
{
    
    var auth = SPTAuth.defaultInstance()!
    var session : SPTSession!
    
    var player : SPTAudioStreamingController?
    var loginURL : URL?
    
    var authToken : String!
    var userName : String!
    
    var database : SongDatabase!
    
    var loginSpotifyButton : UIButton!
    
    var currentPlaylistIndex : Int!
    var currentSongIndex : Int!
    
    var firstTime = true;
    
    
    init(_ loginButton : UIButton)
    {
        super.init();
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSuccessfull"), object: nil);
        
        self.loginSpotifyButton = loginButton;
        
        SPTAuth.defaultInstance().clientID = "68f07eca3ba04a368e92b3c360e19d28"
        SPTAuth.defaultInstance().redirectURL = URL(string: "BLEBikeApp://")
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        loginURL = SPTAuth.defaultInstance().spotifyWebAuthenticationURL()
        
        database = SongDatabase();
    }
    
    func loginToSpotify()
    {
        if UIApplication.shared.openURL(loginURL!)
        {
            if auth.canHandle(auth.redirectURL)
            {
                
            }
        }
    }
    
    func play()
    {
        if(firstTime)
        {
            self.player?.playSpotifyURI(self.database.getPlaylistByIndex(self.currentPlaylistIndex).URI, startingWith: 0, startingWithPosition: 0, callback:
                {
                    (error) in
                    if(error != nil)
                    {
                        print("playing");
                    }
            })
        }
        
        firstTime = false;
        
        self.player?.setIsPlaying(true, callback:
        {
            (error) in
            if(error != nil)
            {
                print("resuming");
            }
        })
    }
    
    func pause()
    {
        self.player?.setIsPlaying(false, callback:
        {
            (error) in
            if(error != nil)
            {
                print("pause");
            }
        
        })
    }
    
    func nextSong()
    {
        self.player?.skipNext(
        {
                (error) in
                if(error != nil)
                {
                    print("skip next");
                }
        })
    }
    
    func previousSong()
    {
        self.player?.skipPrevious(
        {
                (error) in
                if(error != nil)
                {
                    print("skip previous");
                }
        })
    }
    
    func nextPlaylist()
    {
        if(self.currentPlaylistIndex + 1 == self.database.getAmountOfPlaylists())
        {
            self.currentPlaylistIndex = 0;
        }
        else
        {
            self.currentPlaylistIndex = self.currentPlaylistIndex + 1;
        }
        
        self.player?.playSpotifyURI(self.database.getPlaylistByIndex(self.currentPlaylistIndex).URI, startingWith: 0, startingWithPosition: 0, callback:
            {
                (error) in
                if(error != nil)
                {
                    print("playing");
                }
        })
    }
    
    func previousPlaylist()
    {
        if(self.currentPlaylistIndex == 0)
        {
            self.currentPlaylistIndex = self.database.getAmountOfPlaylists() - 1;
        }
        else
        {
            self.currentPlaylistIndex = self.currentPlaylistIndex - 1;
        }
        
        self.player?.playSpotifyURI(self.database.getPlaylistByIndex(self.currentPlaylistIndex).URI, startingWith: 0, startingWithPosition: 0, callback:
            {
                (error) in
                if(error != nil)
                {
                    print("playing");
                }
        })
    }
    
    func setShuffle(_ shuffle: Bool)
    {
        self.player?.setShuffle(shuffle, callback:
        {
            (error) in
            if(error != nil)
            {
                print("shuffle changed");
            }
        })

    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePlaybackStatus isPlaying: Bool) {
        if isPlaying {
            self.activateAudioSession()
        } else {
            self.deactivateAudioSession()
        }
    }
    
    // MARK: Activate audio session
    
    func activateAudioSession()
    {
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    // MARK: Deactivate audio session
    
    func deactivateAudioSession() {
        try? AVAudioSession.sharedInstance().setActive(false)
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
                        self.database.addPlaylist(playlist.name, playlist.uri.absoluteString);
                        
                        print(playlist.name)
                        print(playlist.uri)
                        
                        
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
                                        
                                        self.database.addSongToPlaylist(thisTrack.name, thisTrack.uri.absoluteString, playlist.uri.absoluteString);
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            
            self.currentPlaylistIndex = Int(arc4random_uniform(UInt32(self.database.getAmountOfPlaylists())) + 1);
            self.currentSongIndex = Int(arc4random_uniform(UInt32(self.database.getAmountOfSongsInPlaylist(self.currentPlaylistIndex))) + 1);

        }
    }

}
