//
//  BooksAPI.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 06/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation
import Moya


enum BooksAPI {
    case books
    case book(id: ResourceID)
}

extension BooksAPI : TargetType, SupportsCachePolicy {
    
    var cachePolicy : URLRequest.CachePolicy {
        return .useProtocolCachePolicy
    }
    
    var baseURL: URL {
        return URL(string: Constants.API.baseAddress)!
    }
    
    var path: String {
        switch self {
        case .books:
            return "/books"
            
        case .book(let id):
             return "/books/\(id)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .books:
            let parameters : [String : Any] = ["page" : 1, "pageSize" : 20]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            
        case .book(_):
            return .requestPlain
            
        }
    }

    var sampleData: Data {
        return Data()
    }
    
    var headers: [String : String]? {
        return nil
    }
}
