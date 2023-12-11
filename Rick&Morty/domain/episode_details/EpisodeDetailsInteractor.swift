//
//  EpisodeDetailsInteractor.swift
//  RickandMorty
//
//  Created by Alex Bîrlădeanu on 10.12.2023.
//

import Foundation
import UIKit

class EpisodeDetailsInteractor {
    
    private let getFeaturedCharactersUseCase: GetFeaturedCharactersUseCase
    private let downloadImageUseCase: DownloadImageUseCase
    
    init(getFeaturedCharactersUseCase: GetFeaturedCharactersUseCase, downloadImageUseCase: DownloadImageUseCase) {
        self.getFeaturedCharactersUseCase = getFeaturedCharactersUseCase
        self.downloadImageUseCase = downloadImageUseCase
    }
    
    func getFeaturedCharacters(urls: [String]) async -> [Character] {
        return await getFeaturedCharactersUseCase.execute(urls: urls)
    }
    
    func downloadImage(urlString: String) async throws -> UIImage {
        return try await downloadImageUseCase.execute(url: urlString)
    }
}
