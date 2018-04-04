//
//  API.swift
//  IndeemoTest
//
//  Created by Evghenii Todorov on 4/4/18.
//  Copyright © 2018 Todorov Evghenii. All rights reserved.
//

import Foundation
import Alamofire

class API {
    func fetchFeed(success: @escaping ([[String: Any]]?) -> (), failure: @escaping (Error)->()) {
        
        Alamofire.request("https://jsonplaceholder.typicode.com/posts").responseJSON { response in
            
            switch response.result {
            case .success(let value):
                success(value as? [[String: Any]])
            case .failure(let error):
                failure(error)
            }
            
        }

    }
}
