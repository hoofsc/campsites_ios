//
//  AppContext.swift
//  Campsites
//
//  Created by DH on 11/18/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit

class AppContext: NSObject, DCIContext {

    private(set) var appEnvironment: AppEnvironment
    private(set) weak var appDelegate: UIApplicationDelegate?
    private(set) var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    private(set) var parentContext: DCIContext?
    private(set) var dependencies: Dependencies
    private(set) var isRoot: Bool = false
    private(set) var mainUIContext: MainMapContext?

    init(environment: AppEnvironment,
         appDelegate delegate: UIApplicationDelegate,
         launchOptions options: [UIApplication.LaunchOptionsKey: Any]?) {
            appEnvironment = environment
            appDelegate = delegate
            launchOptions = options ?? [:]
            dependencies = Dependencies(appContext: nil)
            super.init()
            dependencies.updateAppContext(appContext: self)
    }


    func setUpMainUI() {
        mainUIContext = MainMapContext(parent: self, dependencies: dependencies)
        _ = mainUIContext?.constructUI()
        if let mainUIVC = mainUIContext?.ui {
            appDelegate?.window??.replaceRootVC(with: mainUIVC, animated: false) { [weak self] in
                self?.appDelegate?.window??.backgroundColor = .white
            }
        }
    }
}

extension UIWindow {
    func replaceRootVC(with newVC: UIViewController,
                       animated: Bool,
                       duration: TimeInterval = 0.8,
                       completion: (() -> Void)?) {
        guard let oldRootVC = rootViewController else {
            rootViewController = newVC
            completion?()
            return
        }
        let dismissCompletion = { [weak self] in
            self?.rootViewController = newVC
            completion?()
        }
        if oldRootVC.presentedViewController != nil {
            oldRootVC.dismiss(animated: false, completion: nil)
        }
        dismissCompletion()
    }
}
