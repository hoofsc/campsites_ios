//
//  CamperAnnotation.swift
//  Campsites
//
//  Created by DH on 11/7/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit
import MapKit

final class CamperAnnotation: MKPointAnnotation {
    let id: String
    var camper: Camper {
        didSet {
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self = self else { return }
                self.coordinate = self.camper.location.coordinate
            }
        }
    }
    
    init(camper: Camper) {
        id = camper.id
        self.camper = camper
        super.init()
        title = "\(camper.firstName) \(camper.lastName)"
        coordinate = camper.location.coordinate
    }
}
