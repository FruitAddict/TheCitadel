//
//  Character.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 05/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

class Character : Decodable {
    
    var name : String?
    
    var url : String?
    
    var gender : String?
    
    var culture : String?
    
    var born : String?
    
    var titles : [String]?
    
    var aliases : [String]?
    
    var allegiances : [String]?
    
    var books : [Fetchable<Book>]?
    
    var povBooks : [Fetchable<Book>]?
    
    var tvSeries : [String]?
    
    var playedBy : [String]?
    
    var died : String?
    
    var father : Fetchable<Character>?
    
    var mother : Fetchable<Character>?
    
    var spouse : Fetchable<Character>?
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
        case gender
        case culture
        case born
        case titles
        case aliases
        case allegiances
        case books
        case povBooks
        case tvSeries
        case playedBy
        case died
        case father
        case mother
        case spouse
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        url = try values.decode(String.self, forKey: .url)
        gender = try values.decode(String.self, forKey: .gender)
        culture = try values.decode(String.self, forKey: .culture)
        born = try values.decode(String.self, forKey: .born)
        titles = try values.decode([String].self, forKey: .titles)
        aliases = try values.decode([String].self, forKey: .aliases)
        allegiances = try values.decode([String].self, forKey: .allegiances)
        
        if let bookURLs = try? values.decode([String].self, forKey: .books) {
            books = bookURLs.compactMap {
                url -> Fetchable<Book>? in
                return Fetchable<Book>(from: url)
            }
        }
        
        if let povBookURLs = try? values.decode([String].self, forKey: .povBooks) {
            povBooks = povBookURLs.compactMap {
                url -> Fetchable<Book>? in
                return Fetchable<Book>(from: url)
            }
        }
        
        tvSeries = try values.decode([String].self, forKey: .tvSeries)
        playedBy = try values.decode([String].self, forKey: .playedBy)
        died = try values.decode(String.self, forKey: .died)
        
        if let spouseURL = try? values.decode(String.self, forKey: .spouse) {
            spouse = Fetchable<Character>(from: spouseURL)
        }
        
        if let motherURL = try? values.decode(String.self, forKey: .mother) {
            mother = Fetchable<Character>(from: motherURL)
        }
        
        if let fatherURL = try? values.decode(String.self, forKey: .father) {
            father = Fetchable<Character>(from: fatherURL)
        }
    }
    
    init() {}
}


//MARK: - Helper methods
extension Character {
    
    func checkIfMatches(_ searchTerm: String) -> Bool {
        let lowerCasedTerm = searchTerm.lowercased()
        return getMainDescriptor().lowercased().contains(lowerCasedTerm) || getMiscDescriptor().lowercased().contains(lowerCasedTerm)
    }
    
    func checkIfMatches(_ filter: CharacterFilter) -> Bool {
        switch filter {
        case .all:
            return true
            
        case .alive:
            return died.orEmpty.isEmpty
            
        case .dead:
            return !died.orEmpty.isEmpty

        }
    }
    
    func getMainDescriptor() -> String {
        if let name = name, !name.isEmpty {
            return name
        } else if let aliasesUnwrp = aliases, !aliasesUnwrp.isEmpty, aliasesUnwrp.count == 1 {
            return aliasesUnwrp[0]
        } else {
            let uknownString = "unknown".localized
            return "\(uknownString) \(gender.orEmpty)"
        }
    }
    
    func getMiscDescriptor() -> String {
        
        let nameExists = !name.orEmpty.isEmpty
        
        if let aliasesUnwrp = aliases, !aliasesUnwrp.isEmpty, (aliasesUnwrp.count > 1 || nameExists) {
            let joinedAliases = aliasesUnwrp.joined(separator: ", ")
            return joinedAliases
        } else if let titlesUnwrp = titles, !titlesUnwrp.isEmpty {
            let joinedTitles = titlesUnwrp.joined(separator: ", ")
            return joinedTitles
        } else {
            return ""
        }
    }
}
