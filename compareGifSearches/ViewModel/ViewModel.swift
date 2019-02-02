//
//  ViewModel.swift
//  compareGifSearches
//
//  Created by Michael Bielodied on 1/31/19.
//  Copyright © 2019 Michael Bielodied. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ViewModel {
    
    // Output
    let compareResponse: Observable<Compare>
    
    init(leftQuery: Observable<String?>, rightQuery: Observable<String?>, didPressButton: Observable<Void>) {
        
        let apiClient = ApiClient()
        
        // 1
        let userInputs = Observable.combineLatest(leftQuery, rightQuery) {
            (leftQuery, rightQuery) -> (String, String) in
            return (leftQuery ?? "", rightQuery ?? "")// in case if we sure that backend will respond with error in case if query will be wrong OR empty
        }
        
        // 2
        compareResponse = didPressButton
        .withLatestFrom(userInputs)
            .flatMap { (inputs) -> Observable<Compare> in
                
                let sourceObservableLeft = apiClient.getGif(inputs.0)
                
                let sourceObservableRight = apiClient.getGif(inputs.1)
                
                let compareResults = Observable.combineLatest(sourceObservableLeft, sourceObservableRight) {
                    (leftResp, rightResp) -> Compare in
                    
                    let resp = CompareResponse(gifLeft: leftResp, gifRight: rightResp)
                    
                    let giftLeftURL = URL(string: resp.gifLeft?.images.fixed_width_small_still.url ?? "")
                    let giftRightURL = URL(string: resp.gifRight?.images.fixed_width_small_still.url ?? "")
                    
                    return Compare(gifLeftUrl: giftLeftURL, gifRightUrl: giftRightURL)
                }
                return compareResults
        }
     
    }
}
