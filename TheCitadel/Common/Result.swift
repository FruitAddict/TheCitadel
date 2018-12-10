//
//  Result.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 05/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error)
}
