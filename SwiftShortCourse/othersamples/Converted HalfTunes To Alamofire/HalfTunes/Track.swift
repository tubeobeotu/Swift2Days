//
//  Track.swift
//  HalfTunes
//
//  Created by Ken Toh on 13/7/15.
//  Copyright (c) 2015 Ken Toh. All rights reserved.
//

class Track {
    var name: String?
    var artist: String?
    var previewUrl: String?
    var imageUrl : String?
    
    init(songInformation : JSON) {
        self.name = songInformation["trackName"].string
        self.artist = songInformation["artistName"].string
        self.previewUrl = songInformation["previewUrl"].string
        self.imageUrl = songInformation["artworkUrl100"].string
    }
}