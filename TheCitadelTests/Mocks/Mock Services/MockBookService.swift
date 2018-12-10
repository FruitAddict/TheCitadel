//
//  MockBookService.swift
//  TheCitadelTests
//
//  Created by Mateusz Popiało on 09/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

@testable import TheCitadel

class MockBookService : FetchBooksService {
    
    var autoRSP : Bool = true
    
    var booksApiCall : FetchBooksServiceCompletion?
    var bookAPICall : (id: Int, completion: FetchBookServiceCompletion)?
    
    func fetchBooks(completion: @escaping FetchBooksServiceCompletion) {
        if autoRSP {
            completion(.success((0..<100).map{
                int in
                let book = Book()
                book.name = "No #\(int)"
                return book
            }))
        } else {
            booksApiCall = completion
        }
    }
    
    func fetchBook(with id: ResourceID, completion: @escaping FetchBookServiceCompletion) {
        if autoRSP {
            let book = Book()
            book.name = "No #\(id)"
            completion(.success(book))
        } else {
            bookAPICall = (id: id, completion: completion)
        }
    }

    func sendBookAPIRspOK() {
        let book = Book()
        book.name = "No #\(bookAPICall!.id)"
        bookAPICall!.completion(.success(book))
    }
    
    func sendBookAPIRspError() {
        bookAPICall!.completion(.error(TCError.invalidJSONData))
    }
    
    func sendBooksAPIRspOK() {
        booksApiCall?(.success((0..<12).map{
            int in
            let book = Book()
            book.name = "No #\(int)"
            return book
        }))
    }
    
    func sendBooksAPIRspError() {
        booksApiCall?(.error(TCError.invalidJSONData))
    }
    
}
