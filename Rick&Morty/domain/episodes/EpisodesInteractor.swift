//
//  EpisodesInteractor.swift
//  RickandMorty
//
//  Created by Alex Bîrlădeanu on 10.12.2023.
//

import Foundation
import UIKit

class EpisodesInteractor {
    
    private let getEpisodesUseCase: GetEpisodesUseCase
    
    private let baseURL = "https://rickandmortyapi.com/api/episode"
    
    init(getEpisodesUseCase: GetEpisodesUseCase) {
        self.getEpisodesUseCase = getEpisodesUseCase
    }

    func getFirstEpisodes() async throws -> EpisodeResponse {
        return try await getEpisodesUseCase.execute(urlString: baseURL)
    }
    
    func getNextEpisodes(url: String) async throws -> EpisodeResponse {
        return try await getEpisodesUseCase.execute(urlString: url)
    }
}
