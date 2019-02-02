//
//  ApiClient.swift
//  compareGifSearches
//
//  Created by Michael Bielodied on 1/30/19.
//  Copyright © 2019 Michael Bielodied. All rights reserved.
//

import Alamofire
import RxSwift

class ApiClient {
    
    // MARK: - GetGifs
    enum GetGifFailureReason: Int, Error {
        case unAuthorized = 401
        case notFound = 404
    }
    
    func getGif(_ q: String, limit: Int = 1) -> Observable<Gif?> {
        
        let url = String(format: Common.searchGif, q, Common.API_KEY, limit)
        
        return Observable.create({ observer -> Disposable in
            Alamofire.request(url)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            // if no error provided by alamofire return .notFound error instead.
                            // .notFound should never happen here?
                            observer.onError(response.error ?? GetGifFailureReason.notFound)
                            return
                        }
                        do {
                            let gifs = try JSONDecoder().decode(GifsData.self, from: data)
                            let gif = gifs.data.first
                            observer.onNext(gif)
                        } catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode,
                            let reason = GetGifFailureReason(rawValue: statusCode)
                        {
                            observer.onError(reason)
                        }
                        observer.onError(error)
                    }
            }
            
            return Disposables.create()
        })
    }
}
