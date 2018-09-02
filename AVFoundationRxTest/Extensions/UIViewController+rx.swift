//
//  UIViewController+rx.swift
//  AVFoundationRxTest
//
//  Created by Ori Chajuss on 13/08/2018.
//  Copyright © 2018 Ori Chajuss. All rights reserved.
//

import Foundation
import RxSwift

extension UIViewController {
    func alert(title: String, text: String?) -> Completable {
        return Completable.create { [weak self] completable in
            let alertVC = UIAlertController(title: title, message: text, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Close", style: .default, handler: {_ in
                completable(.completed)
            }))
            self?.present(alertVC, animated: true, completion: nil)
            return Disposables.create {
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
