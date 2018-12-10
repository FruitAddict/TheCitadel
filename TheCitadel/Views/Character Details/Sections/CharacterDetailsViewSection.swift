//
//  CharacterDetailsViewSection.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 07/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

enum CharacterDetailsViewSectionItem {
    case basic(title: String, value: String)
    case anotherCharacter(Fetchable<Character>)
    case book(Fetchable<Book>)
}

enum CharacterDetailsViewSectionType {
    case about
    case aliases
    case titles
    case mother
    case father
    case spouse
    case books
    case povBooks
    case allegiances

    var descriptor : String {
        switch self {
        case .about:
            return "about".localized
            
        case .aliases:
            return "aliases".localized
            
        case .titles:
            return "titles".localized
            
        case .mother:
            return "mother".localized
            
        case .father:
            return "father".localized
            
        case .spouse:
            return "spouse".localized
            
        case .books:
            return "books".localized
            
        case .povBooks:
            return "povBooks".localized
            
        case .allegiances:
            return "allegiances".localized
            
        }
    }
}

class CharacterDetailsViewSection {
    
    var type : CharacterDetailsViewSectionType
    var sectionItems: [CharacterDetailsViewSectionItem]
    
    init(type: CharacterDetailsViewSectionType, sectionItems: [CharacterDetailsViewSectionItem] = []) {
        self.type = type
        self.sectionItems = sectionItems
    }
    
    private func appendBasicItemIfNotNil(title: String, value: String?) {
        if let val = value, !val.isEmpty {
            self.sectionItems.append(.basic(title: title, value: val))
        }
    }
    
    private func appendBasicItemIfNotNil(value: String?) {
        if let val = value, !val.isEmpty {
            self.sectionItems.append(.basic(title: "", value: val))
        }
    }
    
    static func createSections(from character: Character) -> [CharacterDetailsViewSection] {
        
        var items : [CharacterDetailsViewSection] = []
        
        let basicInfoSection = CharacterDetailsViewSection(type: .about)
        
        basicInfoSection.appendBasicItemIfNotNil(title: "name".localized, value: character.name)
        basicInfoSection.appendBasicItemIfNotNil(title: "gender".localized, value: character.gender)
        basicInfoSection.appendBasicItemIfNotNil(title: "culture".localized, value: character.culture)
        basicInfoSection.appendBasicItemIfNotNil(title: "born".localized, value: character.born)
        basicInfoSection.appendBasicItemIfNotNil(title: "died".localized, value: character.died)
        basicInfoSection.appendBasicItemIfNotNil(title: "actor".localized, value: character.playedBy?.joined(separator: ", "))
        basicInfoSection.appendBasicItemIfNotNil(title: "tvSeries".localized, value: character.tvSeries?.joined(separator: ", "))
        
        
        items.append(basicInfoSection)
        
        if let aliases = character.aliases, !aliases.isEmpty {
            let aliasesSection = CharacterDetailsViewSection(type: .aliases)
            
            aliases.forEach(aliasesSection.appendBasicItemIfNotNil)
            
            if !aliasesSection.sectionItems.isEmpty {
                items.append(aliasesSection)
            }
        }
        
        if let titles = character.titles, !titles.isEmpty {
            let titlesSection = CharacterDetailsViewSection(type: .titles)
            
            titles.forEach(titlesSection.appendBasicItemIfNotNil)
            
            if !titlesSection.sectionItems.isEmpty {
                items.append(titlesSection)
            }
        }
        
        if let spouse = character.spouse {
            let spouseSection = CharacterDetailsViewSection(type: .spouse)
            
            spouseSection.sectionItems.append(.anotherCharacter(spouse))
            
            items.append(spouseSection)
        }
        
        if let mother = character.mother {
            let motherSection = CharacterDetailsViewSection(type: .mother)
            
            motherSection.sectionItems.append(.anotherCharacter(mother))
            
            items.append(motherSection)
        }
        
        if let father = character.father {
            let fatherSection = CharacterDetailsViewSection(type: .father)
            
            fatherSection.sectionItems.append(.anotherCharacter(father))
            
            items.append(fatherSection)
        }
        
        if let books = character.books, !books.isEmpty {
            let booksSection = CharacterDetailsViewSection(type: .books)
            
            books.forEach {
                booksSection.sectionItems.append(.book($0))
            }
            
            if !booksSection.sectionItems.isEmpty {
                items.append(booksSection)
            }
        }
        
        if let povBooks = character.books, !povBooks.isEmpty {
            let povBooksSection = CharacterDetailsViewSection(type: .povBooks)
            
            povBooks.forEach {
                povBooksSection.sectionItems.append(.book($0))
            }
            
            if !povBooksSection.sectionItems.isEmpty {
                items.append(povBooksSection)
            }
        }
        
        return items
    }
}
