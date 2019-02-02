//
//  Alert.swift
//  compareGifSearches
//
//  Created by Michael Bielodied on 1/30/19.
//  Copyright © 2019 Michael Bielodied. All rights reserved.
//

import Foundation
import UIKit

struct Alert {
    private static func showBasicAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
    
    static func showRequestError(on vc: UIViewController, errorMsg: String) {
        showBasicAlert(on: vc, with: "Request error", message: errorMsg)
    }
}
