//
//  GetEpisodesUseCase.swift
//  RickandMorty
//
//  Created by Alex Bîrlădeanu on 10.12.2023.
//

import Foundation

struct GetEpisodesUseCase {
    
    let apiNeworkService: APINetworkService
    
    func execute(urlString: String) async throws -> EpisodeResponse {
        return try await apiNeworkService.getEpisodes(url: urlString)
    }
}
