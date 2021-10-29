//
//  File.swift
//  
//
//  Created by Sam Rowley on 28/10/2021.
//

import Foundation
import Combine

public protocol PicturesAPIProviding {
    func isPinValid() -> AnyPublisher<Bool, Error>
}
