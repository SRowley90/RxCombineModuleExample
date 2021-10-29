//
//  File.swift
//  
//
//  Created by Sam Rowley on 28/10/2021.
//

import Foundation
import Networking
import Combine

enum PictureRepositoryError: Error {
    case invalidPin
}

struct PictureRepository {
    let apiProvider: PicturesAPIProviding
    let pictureService: PictureService

    public init(apiProvider: PicturesAPIProviding, pictureService: PictureService) {
        self.apiProvider = apiProvider
        self.pictureService = pictureService
    }
    
    func getPhotos() -> AnyPublisher<[Photo], Error> {
        self.apiProvider.isPinValid()
            .flatMap { valid -> AnyPublisher<[Photo], Error> in
                if valid {
                    return pictureService.getPictures()
                } else {
                    return Fail(error: PictureRepositoryError.invalidPin).eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
    
}
