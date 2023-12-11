//
//  DetailsInteractor.swift
//  RickandMorty
//
//  Created by Alex Bîrlădeanu on 10.12.2023.
//

import Foundation
import UIKit

class DetailsInteractor {
    
    private let downloadImageUseCase: DownloadImageUseCase
    
    init(downloadImageUseCase: DownloadImageUseCase) {
        self.downloadImageUseCase = downloadImageUseCase
    }
    
    func downloadImage(urlString: String) async throws -> UIImage {
        return try await downloadImageUseCase.execute(url: urlString)
    }
}
