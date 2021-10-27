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

protocol SessionManagerProtocol {
    var emptyBodyResponseCodes: Set<Int> { get }
    func request(for endpoint: Endpoint, in environment: Environment, with parameters: [String: Any], and additionalHeaders: [String: String]) -> Single<(HTTPURLResponse, Data)>
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
    
    func request(for endpoint: Endpoint, in environment: Environment, with parameters: [String: Any], and additionalHeaders: [String: String]) -> Single<(HTTPURLResponse, Data)> {
        
        let dataResponseSerializer = DataResponseSerializer(emptyResponseCodes: emptyBodyResponseCodes)
        
        do {
            let allHeaders = mergeHeaders(this: additionalHeaders, to: endpoint.headers)

            var originalRequest = try URLRequest(url: try environment.url(for: endpoint),
                                                 method: endpoint.method,
                                                 headers: allHeaders)
            originalRequest.timeoutInterval = endpoint.timeoutInterval

            let encodedURLRequest = try endpoint.parameterEncoding.encode(originalRequest, with: parameters)
            return rx.request(urlRequest: encodedURLRequest)
                .responseData(dataResponseSerializer: dataResponseSerializer)
                .asSingle()

        } catch {
            return .error(error)
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
