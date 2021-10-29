//
//  File.swift
//  
//
//  Created by Sam Rowley on 27/10/2021.
//

import Foundation
import Networking

enum PicturesEndpoint: EndpointProtocol {

    case pictures
    
    var method: URLMethod {
        return .get
    }
    
    var path: String {
        return "photos"
    }
    
    var parameterEncoding: AuthEncoding {
        return .url
    }
}
