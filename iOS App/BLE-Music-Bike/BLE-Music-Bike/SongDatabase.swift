//
//  SongDatabase.swift
//  BLE-Music-Bike
//
//  Created by Tyrone on 4/9/17.
//  Copyright © 2017 Noah Peña. All rights reserved.
//

import Foundation


struct Song
{
    let URI : String
    let Name : String
    
    init(_ name: String, _ uri: String)
    {
        self.Name = name;
        self.URI = uri;
    }
}

struct Playlist
{
    let URI : String
    let Name : String
    var Songs : [Song]
    
    init(_ name: String, _ uri: String)
    {
        self.Name = name;
        self.URI = uri;
        self.Songs = [];
    }
    
    mutating func addSong(_ song : Song)
    {
        self.Songs.append(song);
    }
}


class SongDatabase
{
    
    var Playlists : [Playlist]
    
    init()
    {
        self.Playlists = [];
    }
    
    
    
    
}
