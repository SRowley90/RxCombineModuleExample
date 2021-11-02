//
//  NetworkProvider.swift
//  RxCombineModule
//
//  Created by Sam Rowley on 27/10/2021.
//

import Foundation
import Combine
import Alamofire
import RxSwift
import Networking

struct NetworkProvider: NetworkProviding {
    let disposeBag = DisposeBag()
    
    func getResponse(from request: EndpointProtocol) -> AnyPublisher<(response: HTTPURLResponse, data: Data), Error> {
        return Deferred {
            Future { promise in
                Session.default.request(for: request, in: .debug, with: [:], and: [:])
                    .subscribe{ response in
                        promise(.success(response))
                    } onFailure: { error in
                        promise(.failure(error))
                    } .disposed(by: self.disposeBag)
            }
        }.eraseToAnyPublisher()
    }
}
