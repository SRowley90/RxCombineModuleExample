//
//  File.swift
//  
//
//  Created by Sam Rowley on 27/10/2021.
//

import Foundation
import Combine
import Networking

class PictureService {
    let networkProvider: NetworkProviding

    init(networkProvider: NetworkProviding) {
        self.networkProvider = networkProvider
    }
    
    func getPictures() -> AnyPublisher<[Photo], Error> {
        let request = PicturesEndpoint.pictures
        return self.networkProvider.getResponse(from: request)
            .map(\.data)
            .decode(type: [Photo].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
