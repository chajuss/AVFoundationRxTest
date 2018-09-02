//
//  CameraViewController.swift
//  AVFoundationRxTest
//
//  Created by Ori Chajuss on 12/08/2018.
//  Copyright © 2018 Ori Chajuss. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa

final class CameraViewController: UIViewController, BindableType {
    
    // UI Elements
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    
    // AVFoundation
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    private var videoSession: AVCaptureSession!
    
    // Data binding
    var viewModel: CameraViewModel!
    private let disposeBag = DisposeBag()
    
    func bindViewModel() {
        viewModel.outputs.appPermissionsObservable
            .debug("Camera view Auth")
            .distinctUntilChanged()
            .takeLast(1)
            .filter { $0 == false }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let errorMessage = self?.errorMessage else { return }
                errorMessage("Lacking Permissions", "You can grant access from device's Settings")
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.videoSessionObservable
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                guard let strongSelf = self else { return }
                guard let strongValue = value else { return }
                strongSelf.videoSession = strongValue
                strongSelf.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: strongSelf.videoSession)
                strongSelf.videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                strongSelf.videoPreviewLayer.frame = strongSelf.previewView.bounds
                //                    strongSelf.videoPreviewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
                strongSelf.previewView.layer.addSublayer(strongSelf.videoPreviewLayer)
                strongSelf.videoSession!.startRunning()
        }).disposed(by: disposeBag)
        
        recordButton.rx.tap
            .debug("Record button tap")
            .subscribe({ [unowned self] _ in
                self.viewModel.recordAction.execute(Void())
            }).disposed(by: disposeBag)
        
    }

    // Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        if (self.isMovingFromParentViewController) {
//            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    // MARK: - Helper functions
    private func errorMessage(title: String, text: String) {
        alert(title: title,
              text: text)
            .subscribe({  [weak self] _ in
                self?.viewModel.actions.logoutAction.execute(Void())
            })
            .disposed(by: disposeBag)
    }
    
    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return UIInterfaceOrientationMask.allButUpsideDown
//    }
//
//    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
//        return UIInterfaceOrientation.landscapeRight
//    }
//
    override var prefersStatusBarHidden: Bool {
        return true
    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//extension CameraViewController {
//
//    fileprivate func setupViews() {
//
//    }
//
//    class func _recordButton() -> UIButton {
//        let button
//    }
//}
