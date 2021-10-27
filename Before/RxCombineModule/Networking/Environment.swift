//
//  Environment.swift
//  RxCombineModule
//
//  Created by Sam Rowley on 27/10/2021.
//

import Foundation

enum Error: Swift.Error {
    case unableToConstructURL(URL, String)
}

enum Environment {
    case debug
    
    private func baseURL(for endpoint: Endpoint) -> URL {
        return URL(string: "https://jsonplaceholder.typicode.com/")!
    }
    
    func url(for endpoint: Endpoint) throws -> URL {
        let baseURL = self.baseURL(for: endpoint)
        let path = endpoint.path
        guard let components = URLComponents(string: path),
            let url = components.url(relativeTo: baseURL) else {
                throw Error.unableToConstructURL(baseURL, path)
        }
        return url
    }
}
