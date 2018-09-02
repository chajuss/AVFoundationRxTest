//
//  CameraManager.swift
//  AVFoundationRxTest
//
//  Created by Ori Chajuss on 20/08/2018.
//  Copyright © 2018 Ori Chajuss. All rights reserved.
//

import Foundation
import AVFoundation
import VideoToolbox
import RxSwift
import Result

enum AVSessionError: Error {
    case unknownError
    case addInputError
    case addOutputError
    case setPresetError
}

typealias AVSessionResult = Result<AVCaptureSession, AVSessionError>

protocol AudioVideoManagerType {
    func observeVideoSession() -> Observable<AVSessionResult>
    
    func observeIsRecording() -> Observable<Bool>
}

final class AudioVideoManager: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    static let shared = AudioVideoManager()
    
    private override init() {
        super.init()
    }
    
    let videoSession = AVCaptureSession()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    private var videoDeviceInput: AVCaptureDeviceInput!
    private var audioDeviceInput: AVCaptureDeviceInput!
    
    private var videoDataOutput: AVCaptureVideoDataOutput!
    private var audioDataOutput: AVCaptureAudioDataOutput!
    
    private var videoDevice: AVCaptureDevice!
    
    private let sessionQueue = DispatchQueue(label: "com.3_d_innotech.omnistream.sessionQueue", attributes: .concurrent)
    private let videoQueue = DispatchQueue(label: "com.3_d_innotech.omnistream.videoQueue", attributes: .concurrent)
    
    let isConfigured: Variable<Bool> = Variable<Bool>(false)
    let isRecording: Variable<Bool> = Variable<Bool>(false)

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Here you collect each frame and process it
        if isRecording.value {
            print("output")
        }
    }
}
    
extension AudioVideoManager: AudioVideoManagerType {
    
    func observeIsRecording() -> Observable<Bool> {
        let oldValue = isRecording.value
        isRecording.value = !oldValue
        return Observable.just(!oldValue)
    }
    
    func observeVideoSession() -> Observable<AVSessionResult> {
        var error: AVSessionError = .unknownError
        sessionQueue.sync {
            videoSession.beginConfiguration()
            do {
                if let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
                    videoDevice = dualCameraDevice
                } else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                    videoDevice = backCameraDevice
                }
                videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice!)
                guard videoSession.canAddInput(videoDeviceInput!) == true else {
                    videoSession.commitConfiguration()
                    error = .addInputError
                    return
                }
                videoSession.addInput(videoDeviceInput)
                videoDataOutput = AVCaptureVideoDataOutput()
                videoDataOutput.videoSettings = [((kCVPixelBufferPixelFormatTypeKey as NSString) as String): NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange as UInt32)]
                videoDataOutput.alwaysDiscardsLateVideoFrames = true
                guard videoSession.canSetSessionPreset(.hd1280x720) else {
                    videoSession.commitConfiguration()
                    error = .setPresetError
                    return
                }
                videoSession.sessionPreset = .hd1280x720
                guard videoSession.canAddOutput(videoDataOutput) == true else {
                    videoSession.commitConfiguration()
                    error = .addOutputError
                    return
                }
                videoDataOutput.setSampleBufferDelegate(self, queue: videoQueue)
                videoSession.addOutput(videoDataOutput)
                videoSession.commitConfiguration()
                isConfigured.value = true
            } catch {
                videoSession.commitConfiguration()
                isConfigured.value = false
            }
        }
        return isConfigured.asObservable()
            .map { value in
                if value {
                    return AVSessionResult.success(self.videoSession)
                }
                return AVSessionResult.failure(error)
        }
    }
}



