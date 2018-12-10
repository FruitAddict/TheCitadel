//
//  BookListPresenterImpl.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 08/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

final class BookListPresenterImpl : BookListPresenter {

    //MARK: - Dependencies
    struct Dependencies {
        var router: Router
        var bookService: FetchBooksService
    }
    
    //MARK: - BookListPresenter
    private weak var view : BookListView?
    
    private var books : [Book] = []

    var bookService: FetchBooksService
    
    var router: Router
    
    init(with dependencies: BookListPresenterImpl.Dependencies) {
        self.bookService = dependencies.bookService
        self.router = dependencies.router
    }
    
    func attach(view: BookListView) {
        self.view = view
        configureView()
    }
    
    //MARK: - Configuration
    private func configureView() {
        let config = BookListViewConfig(
            title: "books".localized
        )
        
        view?.configureView(using: config)
    }
}

//MARK: - Book fetching
extension BookListPresenterImpl {
    
    private func fetchBooks() {
        view?.setCentralIndicatorVisibility(visible: true)
        bookService.fetchBooks() {
            result in
            
            switch result {
            case .success(let books):
                self.books = books
                self.view?.update(using: books)
                self.view?.setCentralIndicatorVisibility(visible: false)
                
            case .error(let error):
                self.router.transition(to: Destinations.noConnection(customErrorString: error.localizedDescription, delegate: self))
                
            }
        }
    }
    
}

//MARK: - Events emitted from view
extension BookListPresenterImpl {
    
    func fetchAllBooks() {
        self.fetchBooks()
    }
    
    func selectBook(book: Book) {
        if book.characters.count > 0 {
            self.router.transition(to: Destinations.charactersForBook(book))
        }
    }
    
}

//MARK: - Error handling
extension BookListPresenterImpl: NoConnectionPresenterDelegate {
    
    func onRetryPressed() {
        self.fetchBooks()
    }
    
}
