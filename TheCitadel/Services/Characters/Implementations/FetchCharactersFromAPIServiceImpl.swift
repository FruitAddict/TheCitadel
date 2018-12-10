//
//  FetchCharactersFromAPIService.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 06/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation
import Moya

//MARK: - Implementation
final class FetchCharactersFromAPIServiceImpl : FetchCharactersService {
    
    private var lastCancellable : Cancellable?
    
    func fetchCharacters(using query: CharacterQuery, completion: @escaping FetchCharactersServiceCompletion) {
        
        if let cancellable = lastCancellable,!cancellable.isCancelled {
            cancellable.cancel()
        }
        
        let provider = MoyaProvider<CharactersAPI>(plugins: [MoyaCachePolicyPlugin()])
        
        let request : CharactersAPI = .characters(
            page: query.page,
            limit: query.pageLimit,
            filter: query.filter
        )
        
        lastCancellable = provider.request(request) {
            [weak self] result in
            
            self?.lastCancellable = nil
            
            switch result {
            case .success(let result):
                let decoder = JSONDecoder()
                if let characters = try? decoder.decode([Character].self, from: result.data) {
                    completion(.success(characters))
                } else {
                    completion(.error(TCError.invalidJSONData))
                }
                
            case .failure(let error):
                completion(.error(error))
            }
        }
    }
    
    func fetchCharacter(with id: Int, completion: @escaping FetchCharacterServiceCompletion) {
        
        let provider = MoyaProvider<CharactersAPI>(plugins: [MoyaCachePolicyPlugin()])

        let request : CharactersAPI = .character(id: id)
        
        provider.request(request) {
            result in
            
            switch result {
            case .success(let result):
                let decoder = JSONDecoder()
                if let character = try? decoder.decode(Character.self, from: result.data) {
                    completion(.success(character))
                } else {
                    completion(.error(TCError.invalidJSONData))
                }
                
            case .failure(let error):
                completion(.error(error))
            }
        }
    }

    
}
