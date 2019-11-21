//
//  DCIContext.swift
//  Campsites
//
//  Created by DH on 11/18/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import Foundation

internal protocol DCIContext: AnyObject {
    var parentContext: DCIContext? { get }
    var dependencies: Dependencies { get }
    var isRoot: Bool { get }
}

internal protocol ContextUI {
    associatedtype VC


    var ui: VC? { get }


    func constructUI() -> VC?
    func destroyUI()
}
