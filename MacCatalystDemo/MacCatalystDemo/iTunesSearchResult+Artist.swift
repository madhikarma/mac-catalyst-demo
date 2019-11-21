//
//  iTunesSearchResult+Artist.swift
//  MacCatalystDemo
//
//  Created by Beta on 19/11/2019.
//  Copyright © 2019 Beta. All rights reserved.
//

import Foundation
import iTunesAPI

extension iTunesSearchResult: Artist {
    var id: Int {
        return artistId
    }
    var name: String {
        return artistName
    }
    var artistImageURL: URL? {
        return self.artworkUrl100
    }
}
