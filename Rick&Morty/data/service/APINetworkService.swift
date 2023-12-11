//
//  APINetworkService.swift
//  RickandMorty
//
//  Created by Alex Bîrlădeanu on 09.12.2023.
//

import Foundation
import UIKit

class APINetworkService: NetworkService {
    
    func getCharacters(url: String) async throws -> CharacterResponse {
        return try await getJsonObject(url: url)
    }
    
    func getEpisodes(url: String) async throws -> EpisodeResponse {
        return try await getJsonObject(url: url)
    }
    
    func getSingleCharacter(url: String) async throws -> Character {
        return try await getJsonObject(url: url)
    }
    
    func downloadImage(url: String) async throws -> UIImage {
        guard let url = URL(string: url) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw URLError(.badServerResponse)
        }
        return image
    }
    
    private func getJsonObject<T: Decodable>(url: String) async throws -> T{
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        let (data ,_) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(T.self, from: data)
        return response
    }
}
