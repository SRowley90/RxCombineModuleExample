//
//  Endpoint.swift
//  RxCombineModule
//
//  Created by Sam Rowley on 27/10/2021.
//

import Foundation
import Alamofire
import Auth

enum Endpoint: EndpointProtocol {
    case posts
    case comments(postId: Int)
    
    var method: URLMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .comments(let postId):
            return "/comments?postId=\(postId)"
        case .posts:
            return "posts"
        }
    }
    
    var parameterEncoding: AuthEncoding {
        return .url
    }
    
    var timeoutInterval: TimeInterval {
        return 10
    }
}
