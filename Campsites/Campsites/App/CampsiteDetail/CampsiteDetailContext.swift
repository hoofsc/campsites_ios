//
//  CampsiteDetailContext.swift
//  Campsites
//
//  Created by DH on 11/19/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit
import MapKit

internal class CampsiteDetailContext: DCIContext, ContextUI {

    typealias VC = CampsiteDetailViewController

    let isRoot: Bool = false

    var campsite: Campsite
    var parentContext: DCIContext?
    var dependencies: Dependencies
    var mapRegion: MKCoordinateRegion {
        return MKCoordinateRegion(center: mapCenter, span: mapSpan)
    }
    var mapCenter: CLLocationCoordinate2D {
        return campsite.location.coordinate
    }
    var campsiteService: CampsiteService {
        return dependencies.campsiteService
    }


    private(set) var ui: VC?
    private var mapSpan: MKCoordinateSpan {
        return MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    }

    init(parent: DCIContext, dependencies deps: Dependencies, campsite: Campsite) {
        parentContext = parent
        dependencies = deps
        self.campsite = campsite
    }


    func constructUI() -> VC? {
        if let alreadyUI = ui {
            return alreadyUI
        }
        let vc = CampsiteDetailViewController(context: self)
        ui = vc
        ui?.update(campsite: campsite)
        return ui
    }

    func destroyUI() {
        ui = nil
        campsiteService.removeObserver(self)
    }

    func subscribeToCampsiteLocationEvents(completion: (([Campsite]) -> Void)) {
        campsiteService.addObserver(self)
        completion(campsiteService.campsites)
    }
}


// MARK: CampsiteObserver

extension CampsiteDetailContext: CampsiteObserver {
    func didUpdate(campsite aCampsite: Campsite) {
        guard aCampsite.id == campsite.id else { return }
        ui?.update(campsite: aCampsite)
    }
}

