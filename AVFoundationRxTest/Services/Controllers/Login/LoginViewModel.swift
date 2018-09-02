//
//  LoginViewModel.swift
//  AVFoundationRxTest
//
//  Created by Ori Chajuss on 12/08/2018.
//  Copyright © 2018 Ori Chajuss. All rights reserved.
//

import Foundation
import RxSwift
import Action

struct LoginViewModel {
    
    let sceneCoordinator: SceneCoordinatorType
    let loginProvider: LoginProviderType
    
    init(loginProvider: LoginProvider, coordinator: SceneCoordinatorType) {
        self.loginProvider = loginProvider
        self.sceneCoordinator = coordinator
    }
    
    
    lazy var loginAction: Action<Void, LoginResult> = { (coordinator: SceneCoordinatorType, service: LoginProviderType) in
        return Action<Void, LoginResult>() { _ in
            return service.login()
                .debug("loginAction")
                .observeOn(MainScheduler.instance)
                .do(onNext: { result in
                    guard let loggedIn = result.value else { return }
                    let audioVideoProvider = AudioVideoProvider()
                    if loggedIn {
                        let cameraViewModel = CameraViewModel(coordinator: coordinator, serviceProvider: audioVideoProvider)
                        coordinator.transition(to: Scene.camera(cameraViewModel), type: .modal)
                    }
                })
        }
    }(self.sceneCoordinator, self.loginProvider)
}

