//
//  DownloadImageUseCase.swift
//  RickandMorty
//
//  Created by Alex Bîrlădeanu on 09.12.2023.
//

import Foundation
import UIKit

struct DownloadImageUseCase {
    
    let apiNeworkService: APINetworkService
    
    func execute(url: String) async throws -> UIImage {
        return try await apiNeworkService.downloadImage(url: url)
    }
}
