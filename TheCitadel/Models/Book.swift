//
//  Book.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 05/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

class Book : Decodable {
    
    var name : String?
    
    var isbn : String?
    
    var authors : [String]?
    
    var numberOfPages : Int?
    
    var publisher : String?
    
    var country : String?
    
    var mediaType : String?
    
    var released : String?
    
    var characters : [Fetchable<Character>] = []
    
    var povCharacters : [Fetchable<Character>]?
    
    enum CodingKeys: String, CodingKey {
        case name
        case isbn
        case authors
        case numberOfPages
        case publisher
        case country
        case mediaType
        case released
        case characters
        case povCharacters
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        isbn = try values.decode(String.self, forKey: .isbn)
        authors = try values.decode([String].self, forKey: .authors)
        numberOfPages = try values.decode(Int.self, forKey: .numberOfPages)
        publisher = try values.decode(String.self, forKey: .publisher)
        country = try values.decode(String.self, forKey: .country)
        mediaType = try values.decode(String.self, forKey: .mediaType)
        released = try values.decode(String.self, forKey: .released)
        
        if let charURLs = try? values.decode([String].self, forKey: .characters) {
            characters = charURLs.compactMap {
                url -> Fetchable<Character>? in
                return Fetchable<Character>(from: url)
            }
        }
        
        if let povCharsURLs = try? values.decode([String].self, forKey: .povCharacters) {
            povCharacters = povCharsURLs.compactMap {
                url -> Fetchable<Character>? in
                return Fetchable<Character>(from: url)
            }
        }
    }
    
    init () {}

}


//MARK: - Helper methods
extension Book {
    
    func getMainDescriptor() -> String {
        if let name = self.name {
            return name
        } else {
            return "Unknown name"
        }
    }
    
    func getMiscDescriptor() -> String {
        guard
            let releaseDate = self.released
        else {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy"
        
        if let date = dateFormatter.date(from: releaseDate) {
            return "Released in \(outputDateFormatter.string(from: date)), \(self.characters.count) characters"
        } else {
            return ""
        }
    }
    
    func getAuthors() -> String {
        if let authors = self.authors {
            return authors.joined(separator: ", ")
        } else {
            return ""
        }
    }
    
}
