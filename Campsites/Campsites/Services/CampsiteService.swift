//
//  CampsiteService.swift
//  Campsites
//
//  Created by DH on 11/18/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit

protocol CampsiteObserver: class {
    func didUpdate(campsite aCampsite: Campsite)
}


var testCampsites: [Campsite] {
    let url = Bundle.main.url(forResource: "MockCampsites", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    let decoder = JSONDecoder()
    return try! decoder.decode([Campsite].self, from: data)
}


internal class CampsiteService: NSObject {

    var campsites = [Campsite]()
    var observers = [CampsiteObserver]()

    deinit {
        observers.removeAll()
    }


    func addObserver(_ observer: CampsiteObserver) {
        observers.append(observer)
    }

    func removeObserver(_ observer: CampsiteObserver) {
        if let index = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: index)
        }
    }

    func getCampsites(completion: (([Campsite]) -> Void)) {
        campsites = testCampsites
        completion(campsites)
    }
}
