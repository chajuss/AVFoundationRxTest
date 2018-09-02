//
//  ViewController.swift
//  AVFoundationRxTest
//
//  Created by Ori Chajuss on 12/08/2018.
//  Copyright © 2018 Ori Chajuss. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Result
import Action

class LoginViewController: UIViewController, BindableType {

    var viewModel: LoginViewModel!
    
    @IBOutlet weak var loginButton: UIButton!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bindViewModel() {
        let loginAction = viewModel.loginAction
        
        loginAction.elements
            .debug("Login view onLogin")
            .subscribe(onNext: { [weak self] result in
                var message = ""
                switch result {
                case  .failure(.unknownError):
                    message = "unknown error"
                case .failure(.wrongID):
                    message = "wrong phone ID"
                case .failure(.wrongCredentials):
                    message = "wrong credentials"
                case .failure(.serviceUnavailable):
                    message = "service unavailable"
                case let .success(loggedIn):
                    print("logged in = \(loggedIn)")
                    return
                }
                self?.errorMessage(message: message)
            }).disposed(by: disposeBag)

        
        
        loginButton.rx.tap
            .debug("Loggin button tap")
            .subscribe(onNext: { _ in
                loginAction.execute(Void())
            })
            .disposed(by: disposeBag)
        
    }
    
    private func errorMessage(message: String) {
        alert(title: "Login Failed",
              text: message)
            .subscribe({ _ in
            })
            .disposed(by: disposeBag)
    }
}




