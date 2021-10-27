//
//  AuthController.swift
//  RxCombineModule
//
//  Created by Sam Rowley on 27/10/2021.
//

import Foundation
import RxSwift
import RxRelay

class AuthController {
    
    let isValidPIN = BehaviorRelay<Bool>(value: false)
    
    func togglePinValid() {
        isValidPIN.accept(!isValidPIN.value)
    }
}
