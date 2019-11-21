//
//  CamperDetailContext.swift
//  Campsites
//
//  Created by DH on 11/19/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit
import MapKit

internal class CamperDetailContext: DCIContext, ContextUI {

    typealias VC = CamperDetailViewController

    let isRoot: Bool = false

    var camper: Camper
    var parentContext: DCIContext?
    var dependencies: Dependencies
    var mapRegion: MKCoordinateRegion {
        return MKCoordinateRegion(center: mapCenter, span: mapSpan)
    }
    var mapCenter: CLLocationCoordinate2D {
        return camper.location.coordinate
    }
    var camperService: CamperService {
        return dependencies.camperService
    }


    private(set) var ui: VC?
    private var mapSpan: MKCoordinateSpan {
        return MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
    }

    init(parent: DCIContext, dependencies deps: Dependencies, camper: Camper) {
        parentContext = parent
        dependencies = deps
        self.camper = camper
    }


    func constructUI() -> VC? {
        if let alreadyUI = ui {
            return alreadyUI
        }
        let vc = CamperDetailViewController(context: self)
        ui = vc
        ui?.update(camper: camper)
        return ui
    }

    func destroyUI() {
        ui = nil
        camperService.removeObserver(self)
    }

    func subscribeToCamperLocationEvents(completion: (([Camper]) -> Void)) {
        camperService.addObserver(self)
        completion(camperService.campers)
    }
}


// MARK: CamperObserver

extension CamperDetailContext: CamperObserver {
    func didUpdate(camper aCamper: Camper) {
        guard aCamper.id == camper.id else { return }
        ui?.update(camper: aCamper)
    }
}
