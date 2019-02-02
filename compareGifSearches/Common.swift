//
//  Common.swift
//  compareGifSearches
//
//  Created by Michael Bielodied on 1/30/19.
//  Copyright © 2019 Michael Bielodied. All rights reserved.
//

import Foundation

class Common {
    
    struct Global{
        static let API_URL = "http://api.giphy.com/v1/gifs"
        static let SEARCH_URL = "/search?q=%@&api_key=%@&limit=%d"
    }
    
    static var searchGif: String {
        return Common.Global.API_URL + Common.Global.SEARCH_URL
    }
    
    static let API_KEY = "PoNC5dobNIGEIRjb8YokI9ELWKZt19VW"
}
