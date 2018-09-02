//
//  AVCaptureDevice+rx.swift
//  AVFoundationRxTest
//
//  Created by Ori Chajuss on 12/08/2018.
//  Copyright © 2018 Ori Chajuss. All rights reserved.
//

import Foundation
import AVFoundation
import RxSwift

extension AVCaptureDevice {
    static var isVideoAutherized: Observable<Bool> {
        return Observable.create { observer in
            DispatchQueue.main.async {
                if authorizationStatus(for: .video) == .authorized {
                    observer.onNext(true)
                    observer.onCompleted()
                } else {
                    observer.onNext(false)
                    requestAccess(for: .video) { newStatus in
                        observer.onNext(newStatus)
                        observer.onCompleted()
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    static var isAudioAutherized: Observable<Bool> {
        return Observable.create { observer in
            DispatchQueue.main.async {
                if authorizationStatus(for: .audio) == .authorized {
                    observer.onNext(true)
                    observer.onCompleted()
                } else {
                    observer.onNext(false)
                    requestAccess(for: .audio) { newStatus in
                        observer.onNext(newStatus)
                        observer.onCompleted()
                    }
                }
            }
            return Disposables.create()
        }
    }
}

