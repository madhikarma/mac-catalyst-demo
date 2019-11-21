//
//  Artist.swift
//  MacCatalystDemo
//
//  Created by Beta on 19/11/2019.
//  Copyright © 2019 Beta. All rights reserved.
//

import Foundation

protocol Artist {
    var id: Int { get }
    var name: String { get }
    var artistImageURL: URL? { get }
}
