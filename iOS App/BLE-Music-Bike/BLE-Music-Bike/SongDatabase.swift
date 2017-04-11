//  Write some awesome Swift code, or import libraries like "Foundation",
//  "Dispatch", or "Glibc"

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


    func addPlaylist(_ name: String, _ uri: String)
    {
        self.Playlists.append(Playlist(name, uri));
    }
    
    func addSongToPlaylist(_ songName: String, _ songURI: String, _ playlistURI: String)
    {
        var x = 0;
        
        for item in self.Playlists
        {
            if(item.URI == playlistURI)
            {
                self.Playlists[x].addSong(Song(songName, songURI));
                break;
            }
            
            x = x + 1;
        }
    }

    func getPlaylistByIndex(_ index: Int) -> Playlist
    {
        return self.Playlists[index];
    }
    
    func getSongFromPlaylistByIndex(_ playlistIndex: Int, _ songIndex: Int) -> Song
    {       
        return self.Playlists[playlistIndex].Songs[songIndex];
    }
    
    
}
//  Write some awesome Swift code, or import libraries like "Foundation",
//  "Dispatch", or "Glibc"

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


    func addPlaylist(_ name: String, _ uri: String)
    {
        self.Playlists.append(Playlist(name, uri));
    }
    
    func addSongToPlaylist(_ songName: String, _ songURI: String, _ playlistURI: String)
    {
        var x = 0;
        
        for item in self.Playlists
        {
            if(item.URI == playlistURI)
            {
                self.Playlists[x].addSong(Song(songName, songURI));
                break;
            }
            
            x = x + 1;
        }
    }

    func getPlaylistByIndex(_ index: Int) -> Playlist
    {
        return self.Playlists[index];
    }
    
    func getSongFromPlaylistByIndex(_ playlistIndex: Int, _ songIndex: Int) -> Song
    {       
        return self.Playlists[playlistIndex].Songs[songIndex];
    }
    
    
}
