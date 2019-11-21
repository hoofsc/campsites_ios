//
//  CampsiteAnnotation.swift
//  Campsites
//
//  Created by DH on 11/7/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit
import MapKit

final class CampsiteAnnotation: MKPointAnnotation {
    let id: String

    var campsite: Campsite {
        didSet {
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self = self else { return }
                self.coordinate = self.campsite.location.coordinate
            }
        }
    }

    init(campsite: Campsite) {
        id = campsite.id
        self.campsite = campsite
        super.init()
        title = campsite.name
        coordinate = campsite.location.coordinate
    }
}
