//
//  Gif.swift
//  compareGifSearches
//
//  Created by Michael Bielodied on 1/30/19.
//  Copyright © 2019 Michael Bielodied. All rights reserved.
//

import Foundation

struct GifsData: Decodable {
    let data: [Gif]
}

struct Gif: Decodable {
    let id: String
    let slug: String
    let url: String
    let bitly_url: String
    let username: String
    let images: Image
}
