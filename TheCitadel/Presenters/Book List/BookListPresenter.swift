//
//  BookListPresenter.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 05/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

struct BookListViewConfig {
    var title : String
}

protocol BookListView : class {
    
    func configureView(using config: BookListViewConfig)
    
    func update(using books: [Book])
    
    func setCentralIndicatorVisibility(visible: Bool)

}

protocol BookListPresenter {
    
    var bookService : FetchBooksService { get }
    
    func attach(view: BookListView)
    
    func selectBook(book: Book)
    
    func fetchAllBooks()
    
}
