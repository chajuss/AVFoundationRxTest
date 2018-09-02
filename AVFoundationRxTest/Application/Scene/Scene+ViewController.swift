//
//  Scene+ViewController.swift
//  AVFoundationRxTest
//
//  Created by Ori Chajuss on 12/08/2018.
//  Copyright © 2018 Ori Chajuss. All rights reserved.
//

import UIKit

extension Scene {
    func viewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        switch self {
        case .login(let viewModel):
            let nc = storyboard.instantiateViewController(withIdentifier: "Login") as! UINavigationController
            var vc = nc.viewControllers.first as! LoginViewController
            vc.bindViewModel(to: viewModel)
            return nc
        case .camera(let viewModel):
            let nc = storyboard.instantiateViewController(withIdentifier: "Camera") as! UINavigationController
            var vc = nc.viewControllers.first as! CameraViewController
            vc.bindViewModel(to: viewModel)
            return nc

        }
    }
}
