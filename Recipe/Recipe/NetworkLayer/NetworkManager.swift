//
//  NetworkManager.swift
//  Recipe
//
//  Created by Mohamed on 3/11/20.
//  Copyright © 2020 iti-training. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager{
    static var networkObserverDelegate: NetworkObserver?
    
    static func connectGetToUrl(link: URL,networkObserver:NetworkObserver){
        networkObserverDelegate = networkObserver

        Alamofire.request(link, method: .get, parameters: Parameters(), encoding: URLEncoding.queryString, headers: nil).responseJSON { response in
            if(response.response?.statusCode == 200){
                if let json = response.result.value as AnyObject? {
                    networkObserverDelegate?.recipesFetchsuccess(data: json)
                }
            }else {
                print(response.error!.localizedDescription)
                networkObserverDelegate?.recipesFetchfailed(message: response.error!.localizedDescription)
            }
        }
    }
    
}
