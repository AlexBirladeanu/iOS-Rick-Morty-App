//
//  DIContainer.swift
//  RickandMorty
//
//  Created by Alex Bîrlădeanu on 09.12.2023.
//

import Foundation

class DIContainer {
    
    static let shared = DIContainer()
    
    private init() {}
    
    private lazy var apiNetworkService = APINetworkService()
    
    private lazy var getCharactersUseCase = GetCharactersUseCase(apiNeworkService: apiNetworkService)
    private lazy var downloadImageUseCase = DownloadImageUseCase(apiNeworkService: apiNetworkService)
    private lazy var getEpisodesUseCase = GetEpisodesUseCase(apiNeworkService: apiNetworkService)
    private lazy var getFeaturedCharactersUseCase = GetFeaturedCharactersUseCase(apiNetworkService: apiNetworkService)
    
    lazy var charactersInteractor = CharactersInteractor(getCharactersUseCase: getCharactersUseCase, downloadImageUseCase: downloadImageUseCase)
    lazy var detailsInteractor = DetailsInteractor(downloadImageUseCase: downloadImageUseCase)
    lazy var episodesInteractor = EpisodesInteractor(getEpisodesUseCase: getEpisodesUseCase)
    lazy var episodeDetailsInteractor = EpisodeDetailsInteractor(getFeaturedCharactersUseCase: getFeaturedCharactersUseCase, downloadImageUseCase: downloadImageUseCase)
}
