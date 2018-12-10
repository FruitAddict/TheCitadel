//
//  CharactersAPI.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 06/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation
import Moya

enum CharactersAPI {
    case characters(page: Int, limit: Int, filter: CharacterFilter)
    case character(id: ResourceID)
}

extension CharactersAPI : TargetType, SupportsCachePolicy {
    
    var cachePolicy : URLRequest.CachePolicy {
        //for testing return .reloadIgnoringLocalAndRemoteCacheData
        return .useProtocolCachePolicy
    }
    
    var baseURL: URL {
        return URL(string: Constants.API.baseAddress)!
    }
    
    var path: String {
        switch self {
            
        case .characters(_):
            return "/characters"
            
        case .character(let id):
            return "/characters/\(id)"

        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .characters(let page, let limit, let filter):
            
            var parameters : [String : Any] = ["page" : page, "pageSize" : limit]
            switch filter {
            case .alive:
                parameters["isAlive"] = "true"
                
            case .dead:
                parameters["isAlive"] = "false"
                
            case .all:
                ()
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            
        case .character(_):
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
