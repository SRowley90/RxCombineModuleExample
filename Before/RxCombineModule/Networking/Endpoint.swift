//
//  Endpoint.swift
//  RxCombineModule
//
//  Created by Sam Rowley on 27/10/2021.
//

import Foundation
import Alamofire

enum Endpoint {
    case posts
    case comments(postId: Int)
    
    var headers: HTTPHeaders {
        return HTTPHeaders([:])
    }
    
    var method: HTTPMethod {
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
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var timeoutInterval: TimeInterval {
        return 10
    }
}
