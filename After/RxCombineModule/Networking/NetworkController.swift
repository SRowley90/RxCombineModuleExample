//
//  NetworkController.swift
//  RxCombineModule
//
//  Created by Sam Rowley on 20/10/2021.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire
import Networking

protocol SessionManagerProtocol {
    var emptyBodyResponseCodes: Set<Int> { get }
    func request(for endpoint: EndpointProtocol, in environment: Environment, with parameters: [String: Any], and additionalHeaders: [String: String]) -> Single<(HTTPURLResponse, Data)>
}

extension Alamofire.Session: SessionManagerProtocol {
    
    var emptyBodyResponseCodes: Set<Int> { Set<Int>(arrayLiteral: 200, 201, 202).union(DataResponseSerializer.defaultEmptyResponseCodes) }
    
    func mergeHeaders(this additional: [String: String], to main: HTTPHeaders) -> HTTPHeaders {
        var stringDictionaryMainHeaders: [String: String] = [:]
        for singleHeader in main {
            stringDictionaryMainHeaders[singleHeader.name] = singleHeader.value
        }
        let totalHeaders = stringDictionaryMainHeaders.merging(additional) { $1 }
        return HTTPHeaders(totalHeaders)
    }
    
    func request(for endpoint: EndpointProtocol, in environment: Environment, with parameters: [String: Any], and additionalHeaders: [String: String]) -> Single<(HTTPURLResponse, Data)> {
        
        let dataResponseSerializer = DataResponseSerializer(emptyResponseCodes: emptyBodyResponseCodes)
        
        do {
            let request = try URLRequest(url: try environment.url(for: endpoint),
                                                 method: endpoint.alamofireMethod)

            let encodedURLRequest = try endpoint.alamofireEncoding.encode(request, with: parameters)
            return rx.request(urlRequest: encodedURLRequest)
                .responseData(dataResponseSerializer: dataResponseSerializer)
                .asSingle()

        } catch {
            return .error(error)
        }
    }
    
    private func getAlamofireEncodingFromEndpointMethod(_ encoding: AuthEncoding) -> ParameterEncoding {
        switch encoding {
            case .url:
                return URLEncoding.default
        }
    }
}

extension EndpointProtocol {
    var alamofireMethod: HTTPMethod {
        switch self.method {
        case .get:
            return HTTPMethod.get
        }
    }
    
    var alamofireEncoding: ParameterEncoding {
        switch self.parameterEncoding {
        case .url:
            return URLEncoding.default
        }
    }
}


public extension ObservableType where Element == DataRequest {
    func responseData(dataResponseSerializer: DataResponseSerializer = DataResponseSerializer()) -> Observable<(HTTPURLResponse, Data)> {
        return flatMap { $0.rx.responseData(dataResponseSerializer: dataResponseSerializer) }
    }
}

public extension Reactive where Base: DataRequest {
    func responseData(dataResponseSerializer: DataResponseSerializer = DataResponseSerializer()) -> Observable<(HTTPURLResponse, Data)> {
        return responseResult(responseSerializer: dataResponseSerializer)
    }
}
