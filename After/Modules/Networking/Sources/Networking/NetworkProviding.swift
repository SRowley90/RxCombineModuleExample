//
//  NetworkProviding.swift
//  
//
//  Created by Sam Rowley on 27/10/2021.
//

import Foundation
import Combine

public protocol NetworkProviding {
    func getResponse(from request: EndpointProtocol) -> AnyPublisher<(response: HTTPURLResponse, data: Data), Error>
}
