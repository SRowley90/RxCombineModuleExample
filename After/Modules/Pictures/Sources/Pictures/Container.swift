//
//  File.swift
//  
//
//  Created by Sam Rowley on 27/10/2021.
//

import Foundation
import UIKit
import Networking

public struct Container {
    
    private var networkProvider: NetworkProviding
    private var apiProvider: PicturesAPIProviding
    private var picturesRepository: PictureRepository

    public init(networkProvider: NetworkProviding, apiProvider: PicturesAPIProviding) {
        self.networkProvider = networkProvider
        self.apiProvider = apiProvider
        self.picturesRepository = PictureRepository(apiProvider: apiProvider, pictureService: PictureService(networkProvider: networkProvider))
    }
    
    public func makePhotosViewController() -> PictureViewController {
        let viewModel = makePhotosViewModel()
        return  PictureViewController(networkProvider: networkProvider, apiProvider: apiProvider, viewModel: viewModel)
    }

    private func makePhotosViewModel() -> PicturesViewModel {
        return PicturesViewModel(picturesRepository: picturesRepository)
    }
}
