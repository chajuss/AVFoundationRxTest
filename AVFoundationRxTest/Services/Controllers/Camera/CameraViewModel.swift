//
//  CameraViewModel.swift
//  AVFoundationRxTest
//
//  Created by Ori Chajuss on 12/08/2018.
//  Copyright © 2018 Ori Chajuss. All rights reserved.
//

import Foundation
import RxSwift
import Action
import AVFoundation

protocol CameraViewModelInputsType {
    var isRecordingTap: PublishSubject<Bool> { get }
    
}

protocol CameraViewModelOutputsType {
    var videoSessionObservable: Observable<AVCaptureSession?> { get }
    var appPermissionsObservable: Observable<Bool> { get }
//    var isRecordingStatus: Observable<Bool> { get }
}

protocol CameraViewModelActionsType {
    var logoutAction: CocoaAction { get }
}

protocol CameraViewModelType: class {
    var inputs: CameraViewModelInputsType { get }
    var outputs: CameraViewModelOutputsType { get }
    var actions: CameraViewModelActionsType { get }
}

final class CameraViewModel: CameraViewModelType {
    
    var inputs: CameraViewModelInputsType { return self }
    var outputs: CameraViewModelOutputsType { return self }
    var actions: CameraViewModelActionsType { return self }
    
    // Setup
    private let sceneCoordinator: SceneCoordinatorType
    private let audioVideoProvider: AudioVideoProviderType
    private let disposeBag: DisposeBag
    
    // Inputs
    var isRecordingTap: PublishSubject<Bool>
    
    // Outputs
    var videoSessionObservable: Observable<AVCaptureSession?>
    var appPermissionsObservable: Observable<Bool>
//    var isRecordingStatus: Observable<Bool>
    
    // ViewModel Life Cycle
    private let isVideoConfigured: Variable<Bool>
    private let isRecording: Variable<Bool>
    private let isVideoAutherized: Variable<Bool>
    private let videoSession: Variable<AVCaptureSession?>
    
    init(coordinator: SceneCoordinatorType, serviceProvider: AudioVideoProviderType) {
        self.sceneCoordinator = coordinator
        self.audioVideoProvider = serviceProvider
        self.disposeBag = DisposeBag()
        self.isVideoAutherized = Variable(false)
        self.isRecording = Variable(false)
        self.isVideoConfigured = Variable(false)
        self.videoSession = Variable(nil)
        
        // Inputs
        isRecordingTap = PublishSubject()
        
        // Outputs
        videoSessionObservable = videoSession.asObservable()
        appPermissionsObservable = audioVideoProvider.observeAppPermissions()
        
        // ViewModel Life Cycle
        audioVideoProvider.observeAVSession()
            .debug("CameraViewModel GetSession")
            .bind(to: videoSession)
            .disposed(by: disposeBag)
        
        isRecordingTap.bind(to: isRecording).disposed(by: disposeBag)
        
        
        }
    
     // Actions
    lazy var logoutAction = CocoaAction {
        return self.sceneCoordinator.pop().asObservable().map { _ in
            return
        }
    }
    
    lazy var recordAction = Action<Void, Bool> {
        return self.audioVideoProvider.observeIsRecording()
        
    }
        
}

extension CameraViewModel: CameraViewModelInputsType, CameraViewModelOutputsType, CameraViewModelActionsType { }
