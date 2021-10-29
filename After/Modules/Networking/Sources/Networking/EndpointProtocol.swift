//
//  File.swift
//  
//
//  Created by Sam Rowley on 27/10/2021.
//

import Foundation

public enum URLMethod {
    case get
}

public enum AuthEncoding {
    case url
}

public protocol EndpointProtocol {
    var method: URLMethod { get }
    var path: String { get }
    var parameterEncoding: AuthEncoding { get }
}
