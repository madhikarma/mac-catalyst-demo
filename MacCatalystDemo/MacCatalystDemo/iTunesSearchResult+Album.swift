//
//  iTunesSearchResult+Album.swift
//  MacCatalystDemo
//
//  Created by Beta on 21/11/2019.
//  Copyright © 2019 Beta. All rights reserved.
//

import Foundation
import iTunesAPI

extension iTunesSearchResult: Album {
    var albumName: String? {
        return self.collectionName
    }
    var albumImageURL: URL? {
        return self.artworkUrl100
    }
}
