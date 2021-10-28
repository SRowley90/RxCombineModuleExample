//
//  PicturesAPIProvider.swift
//  RxCombineModule
//
//  Created by Sam Rowley on 28/10/2021.
//

import Foundation
import Networking
import Pictures
import RxSwift
import Combine

struct PicturesAPIProvider: PicturesAPIProviding {
    
    var authController: AuthController
    let disposeBag = DisposeBag()
    
    init(authController: AuthController) {
        self.authController = authController
    }
    
    func isPinValid() -> AnyPublisher<Bool, Error> {
        return Deferred {
            Future { promise in
                self.authController.isValidPIN
                    .subscribe{ valid in
                        promise(.success(valid))
                    }
                    .disposed(by: self.disposeBag)
            }
        }.eraseToAnyPublisher()
    }
}
