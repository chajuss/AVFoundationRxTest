//
//  CameraProviderType.swift
//  AVFoundationRxTest
//
//  Created by Ori Chajuss on 12/08/2018.
//  Copyright © 2018 Ori Chajuss. All rights reserved.
//

import Foundation
import AVFoundation
import RxSwift
import Result

protocol AudioVideoProviderType {
    func observeAVSession() -> Observable<AVCaptureSession?>
    
    func observeIsRecording() -> Observable<Bool>
    
    func observeAppPermissions() -> Observable<Bool>
}

struct AudioVideoProvider: AudioVideoProviderType {
    
    private let audioVideoService = AudioVideoManager.shared
    
    init() {
        
    }
    
    func observeAppPermissions() -> Observable<Bool> {
        return Observable.combineLatest(AVCaptureDevice.isVideoAutherized, AVCaptureDevice.isAudioAutherized) {
            return $0 && $1
        }
    }
    
    func observeIsRecording() -> Observable<Bool> {
        return audioVideoService.observeIsRecording()
    }
    
    func observeAVSession() -> Observable<AVCaptureSession?> {
        return audioVideoService.observeVideoSession()
            .map { result in
                switch result {
                case .success(let session):
                    return session
                case .failure:
                    return nil
                }
        }
    }
}
