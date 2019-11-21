//
//  Dependencies.swift
//  Campsites
//
//  Created by DH on 11/18/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import Foundation
import UIKit

internal class Dependencies: NSObject {

    var app: UIApplication { return UIApplication.shared }
    var appDelegate: AppDelegate {
        if let appDel = appContext?.appDelegate as? AppDelegate {
            return appDel
        } else {
            fatalError("AppDelegate is nil!")
        }
    }
    var camperService = CamperService()
    var campsiteService = CampsiteService()


    private(set) weak var appContext: AppContext?


    init(appContext: AppContext?) {
        self.appContext = appContext
    }


    func updateAppContext(appContext: AppContext?) {
        self.appContext = appContext
    }
}
