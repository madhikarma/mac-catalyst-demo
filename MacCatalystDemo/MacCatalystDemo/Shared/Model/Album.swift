//
//  Album.swift
//  MacCatalystDemo
//
//  Created by Beta on 19/11/2019.
//  Copyright © 2019 Beta. All rights reserved.
//

import Foundation

protocol Album {
    var albumName: String? { get }
    var albumImageURL: URL? { get }
}
