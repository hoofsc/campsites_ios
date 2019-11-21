//
//  AppDelegate.swift
//  Campsites
//
//  Created by DH on 11/9/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appEnvironment: AppEnvironment {
        let appEnv: AppEnvironment
        appEnv = .local
        return appEnv
    }


    private(set) var appContext: AppContext?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        appContext = AppContext(environment: appEnvironment, appDelegate: self, launchOptions: launchOptions)
        appContext?.setUpMainUI()
        window?.makeKeyAndVisible()
        return true
    }
}

