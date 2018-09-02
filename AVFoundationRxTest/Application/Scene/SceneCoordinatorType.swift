//
//  SceneCoordinatorType.swift
//  AVFoundationRxTest
//
//  Created by Ori Chajuss on 12/08/2018.
//  Copyright © 2018 Ori Chajuss. All rights reserved.
//

import UIKit
import RxSwift

protocol SceneCoordinatorType {
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitiontype) -> Completable
    
    @discardableResult
    func pop(animated: Bool) -> Completable
    
    @discardableResult
    func popToRoot(animated: Bool) -> Completable
    
    @discardableResult
    func popToVC(_ viewController: UIViewController, animated: Bool) -> Completable
}

extension SceneCoordinatorType {
    @discardableResult
    func pop() -> Completable {
        return pop(animated: true)
    }
}
