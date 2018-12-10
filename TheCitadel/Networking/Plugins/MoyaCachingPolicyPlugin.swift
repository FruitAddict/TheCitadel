//
//  MoyaCachingPolicyPlugin.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 07/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
/// Adapted from: https://stackoverflow.com/questions/48516806/cache-handling-with-moya
//

import Foundation
import Moya

protocol SupportsCachePolicy where Self : TargetType {
    var cachePolicy: URLRequest.CachePolicy { get }
}

final class MoyaCachePolicyPlugin: PluginType {
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        if let cachePolicySupporting = target as? SupportsCachePolicy {
            var mutableRequest = request
            mutableRequest.cachePolicy = cachePolicySupporting.cachePolicy
            return mutableRequest
        }
        
        return request
    }
}
