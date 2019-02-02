//
//  String+Extension.swift
//  compareGifSearches
//
//  Created by Michael Bielodied on 2/2/19.
//  Copyright © 2019 Michael Bielodied. All rights reserved.
//

import Foundation

extension String {
    func isValidForQuery() -> Bool {
        
        if self.trimmingCharacters(in: [" "]).count < 2 {
            return false
        }
        
        let textRegex = "^[\\w ]*$"
        
        return NSPredicate(format: "SELF MATCHES %@", textRegex).evaluate(with: self)
        
    }
}
