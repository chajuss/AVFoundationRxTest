//
//  LoginProviderType.swift
//  AVFoundationRxTest
//
//  Created by Ori Chajuss on 12/08/2018.
//  Copyright © 2018 Ori Chajuss. All rights reserved.
//

import Foundation
import Result
import RxSwift

enum LoginError: Error {
    case unknownError
    case wrongID
    case wrongCredentials
    case serviceUnavailable
}

typealias LoginResult = Result<Bool, LoginError>

protocol LoginProviderType {
    
    @discardableResult
    func login() -> Observable<LoginResult>
    
}
