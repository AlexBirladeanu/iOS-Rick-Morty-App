//
//  GetFeaturedCharactersUseCase.swift
//  RickandMorty
//
//  Created by Alex Bîrlădeanu on 10.12.2023.
//

import Foundation
import UIKit

struct GetFeaturedCharactersUseCase {
    
    private let apiNetworkService: APINetworkService
    
    init(apiNetworkService: APINetworkService) {
        self.apiNetworkService = apiNetworkService
    }
    
    func execute(urls: [String]) async -> [Character] {
        var list = [Character]()
        for i in 0...urls.count - 1 {
            do {
                let character = try await apiNetworkService.getSingleCharacter(url: urls[i])
                list.append(character)
            } catch {
                print(error)
            }
        }
        return list
    }
}
