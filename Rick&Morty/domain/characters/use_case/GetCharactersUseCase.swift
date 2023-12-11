//
//  GetAllUseCase.swift
//  RickandMorty
//
//  Created by Alex Bîrlădeanu on 09.12.2023.
//

import Foundation

struct GetCharactersUseCase {
    
    let apiNeworkService: APINetworkService
    
    func execute(urlString: String) async throws -> CharacterResponse {
        return try await apiNeworkService.getCharacters(url: urlString)
    }
}
