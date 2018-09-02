//
//  LoginProvider.swift
//  AVFoundationRxTest
//
//  Created by Ori Chajuss on 12/08/2018.
//  Copyright © 2018 Ori Chajuss. All rights reserved.
//

import Foundation
import RxSwift

struct LoginProvider: LoginProviderType {
    
    @discardableResult
    func login() -> Observable<LoginResult> {
        return Observable.just(LoginResult.success(true))
    }
}
