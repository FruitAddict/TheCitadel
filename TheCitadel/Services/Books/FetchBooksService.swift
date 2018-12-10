//
//  FetchBooksService.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 07/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

typealias FetchBooksServiceCompletion = (Result<[Book]>) -> Void

typealias FetchBookServiceCompletion = (Result<Book>) -> Void

protocol FetchBooksService {
    
    func fetchBooks(completion: @escaping FetchBooksServiceCompletion)
    
    func fetchBook(with id: ResourceID, completion: @escaping FetchBookServiceCompletion)
    
}
