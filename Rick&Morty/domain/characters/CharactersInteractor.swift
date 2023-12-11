//
//  CharactersInteractor.swift
//  RickandMorty
//
//  Created by Alex Bîrlădeanu on 09.12.2023.
//

import Foundation
import UIKit

class CharactersInteractor {
    
    private let getCharactersUseCase: GetCharactersUseCase
    private let downloadImageUseCase: DownloadImageUseCase
        
    private let baseURL = "https://rickandmortyapi.com/api/character"
    
    init(getCharactersUseCase: GetCharactersUseCase, downloadImageUseCase: DownloadImageUseCase) {
        self.getCharactersUseCase = getCharactersUseCase
        self.downloadImageUseCase = downloadImageUseCase
    }
    
    func getFirstCharacters() async throws -> CharacterResponse {
        return try await getCharactersUseCase.execute(urlString: baseURL)
    }
    
    func getNextCharacters(urlString: String) async throws -> CharacterResponse {
        return try await getCharactersUseCase.execute(urlString: urlString)
    }
    
    func downloadImage(urlString: String) async throws -> UIImage {
        return try await downloadImageUseCase.execute(url: urlString)
    }
}
