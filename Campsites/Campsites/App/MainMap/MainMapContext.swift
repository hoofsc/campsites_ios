//
//  MainMapContext.swift
//  Campsites
//
//  Created by DH on 11/9/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

internal class MainMapContext: DCIContext, ContextUI {

    typealias VC = UINavigationController


    let isRoot: Bool = true

    var parentContext: DCIContext?
    var dependencies: Dependencies
    var ui: VC? { return uiNVC }

    var campers: [Camper] {
        return camperService.campers
    }
    var campsites: [Campsite] {
        return campsiteService.campsites
    }
    var mapRegion: MKCoordinateRegion {
        return MKCoordinateRegion(center: mapCenter, span: mapSpan)
    }


    private(set) var uiNVC: UINavigationController?
    private(set) var mapVC: MapViewController?
    private(set) var mapCenter = CLLocationCoordinate2D(latitude: 48.7596, longitude: -113.837)

    private var camperService: CamperService {
        return dependencies.camperService
    }
    private var campsiteService: CampsiteService {
        return dependencies.campsiteService
    }
    private var mapSpan: MKCoordinateSpan {
        return MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)
    }


    init(parent: DCIContext, dependencies deps: Dependencies) {
        parentContext = parent
        dependencies = deps
    }

    deinit {
        camperService.removeObserver(self)
    }


    func constructUI() -> VC? {
        if let alreadyUI = ui {
            return alreadyUI
        }
        let vc = MapViewController(context: self)
        let navVC = UINavigationController(rootViewController: vc)
        uiNVC = navVC
        mapVC = vc
        return uiNVC
    }

    func destroyUI() {
        uiNVC = nil
        mapVC = nil
    }

    func beginLocationUpdates() {
        camperService.beginAutoUpdates(updateInterval: 5.0, maxCount: 100, addInterval: 30.0)
    }

    func subscribeToCamperLocationEvents(completion: (([Camper]) -> Void)) {
        camperService.getCampers(in: mapRegion) { [weak self] campers in
            guard let self = self else { return }
            self.camperService.addObserver(self)
            completion(campers)
        }
    }

    func fetchCampsiteLocations(completion: (([Campsite]) -> Void)) {
        campsiteService.getCampsites(completion: completion)
    }

    func presentCamperDetail(camper: Camper) {
        let camperDetailContext = CamperDetailContext(parent: self,
                                                      dependencies: dependencies,
                                                      camper: camper)
        if let vc = camperDetailContext.constructUI() {
            ui?.pushViewController(vc, animated: true)
        }
    }

    func presentCampsiteDetail(campsite: Campsite) {
        let campsiteDetailContext = CampsiteDetailContext(parent: self,
                                                          dependencies: dependencies,
                                                          campsite: campsite)
        if let vc = campsiteDetailContext.constructUI() {
            ui?.pushViewController(vc, animated: true)
        }
    }
}


// MARK: CamperObserver

extension MainMapContext: CamperObserver {
    func didUpdate(camper aCamper: Camper) {
        mapVC?.update(camper: aCamper)
    }
}


// MARK: CampsiteObserver

extension MainMapContext: CampsiteObserver {
    func didUpdate(campsite aCampsite: Campsite) {
        // currently not implemented
    }
}
