//
//  NetworkService.swift
//  RickandMorty
//
//  Created by Alex Bîrlădeanu on 09.12.2023.
//

import Foundation
import UIKit

protocol NetworkService {
    
    func getCharacters(url: String) async throws -> CharacterResponse
    
    func getEpisodes(url: String) async throws -> EpisodeResponse
        
    func getSingleCharacter(url: String) async throws -> Character
    
    func downloadImage(url: String) async throws -> UIImage
}
