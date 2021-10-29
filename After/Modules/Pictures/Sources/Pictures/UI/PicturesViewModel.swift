//
//  File.swift
//  
//
//  Created by Sam Rowley on 28/10/2021.
//

import Foundation
import Combine

public class PicturesViewModel {
    
    internal var cancellables = Set<AnyCancellable>()
    
    @Published var photos: [Photo] = []
    
    private let picturesRepository: PictureRepository
    
    private let photosSubject = PassthroughSubject<Void, Error>()
    
    init(picturesRepository: PictureRepository) {
        self.picturesRepository = picturesRepository
        photosSubject
            .flatMap(picturesRepository.getPhotos)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { photos in
                    self.photos = photos
                })
            .store(in: &cancellables)

    }
    
    func getPhotos() {
        photosSubject.send()
    }
    
}
