//
//  FetchBooksFromAPIService.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 07/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation
import Moya

final class FetchBooksFromAPIServiceImpl : FetchBooksService {
    
    private var lastCancellable : Cancellable?

    func fetchBooks(completion: @escaping FetchBooksServiceCompletion) {
        if let cancellable = lastCancellable,!cancellable.isCancelled {
            cancellable.cancel()
        }
        
        let provider = MoyaProvider<BooksAPI>(plugins: [MoyaCachePolicyPlugin()])
   
        lastCancellable = provider.request(.books) {
            [weak self] result in
            
            self?.lastCancellable = nil
            
            switch result {
            case .success(let result):
                let decoder = JSONDecoder()
                if let books = try? decoder.decode([Book].self, from: result.data) {
                    completion(.success(books))
                } else {
                    completion(.error(TCError.invalidJSONData))
                }
                
            case .failure(let error):
                completion(.error(error))
            }
        }
    }
    
    func fetchBook(with id: ResourceID, completion: @escaping FetchBookServiceCompletion) {
        let provider = MoyaProvider<BooksAPI>(plugins: [MoyaCachePolicyPlugin()])
        
        let request : BooksAPI = .book(id: id)
        
        provider.request(request) {
            result in
            
            switch result {
            case .success(let result):
                let decoder = JSONDecoder()
                if let book = try? decoder.decode(Book.self, from: result.data) {
                    completion(.success(book))
                } else {
                    completion(.error(TCError.invalidJSONData))
                }
                
            case .failure(let error):
                completion(.error(error))
            }
        }
    }
    
    
}
