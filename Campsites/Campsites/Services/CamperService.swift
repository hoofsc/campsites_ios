//
//  CamperService.swift
//  Campsites
//
//  Created by DH on 11/18/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

protocol CamperObserver: class {
    func didUpdate(camper aCamper: Camper)
}


var testCampers: [Camper] {
    let url = Bundle.main.url(forResource: "MockCampers", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    let decoder = JSONDecoder()
    return try! decoder.decode([Camper].self, from: data)
}


internal class CamperService: NSObject {

    var campers = [Camper]()
    var autoTimerUpdate: Timer?
    var autoTimerAdd: Timer?
    var observers = [CamperObserver]()

    var mapRegion: MKCoordinateRegion?


    deinit {
        observers.removeAll()
    }


    func addObserver(_ observer: CamperObserver) {
        observers.append(observer)
    }

    func removeObserver(_ observer: CamperObserver) {
        if let index = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: index)
        }
    }

    func getCampers(in mapRegion: MKCoordinateRegion, completion: (([Camper]) -> Void)) {
        self.mapRegion = mapRegion
//        campers = testCampers
        campers = randomCampers(count: 6)
        completion(campers)
    }

    func update(camper: Camper) {
        if let index = campers.firstIndex(of: camper) {
            var randSign = Float.random(in: 0.0 ..< 1.0)
            var randDegree = Double.random(in: 0.0001 ..< 0.001)
            var newCoord = camper.location.coordinate
            newCoord.latitude = (randSign > 0.5) ? camper.location.coordinate.latitude + randDegree :
                                                   camper.location.coordinate.latitude - randDegree
            randSign = Float.random(in: 0.0 ..< 1.0)
            randDegree = Double.random(in: 0.0001 ..< 0.001)
            newCoord.longitude = (randSign > 0.5) ? camper.location.coordinate.longitude + randDegree :
                                                    camper.location.coordinate.longitude - randDegree
            let newLocation = CLLocation(coordinate: newCoord,
                                         altitude: 0.0,
                                         horizontalAccuracy: 0.0,
                                         verticalAccuracy: 0.0,
                                         timestamp: Date())
            campers[index].location = newLocation
            for observer in observers {
                observer.didUpdate(camper: campers[index])
            }
        }
    }

    func beginAutoUpdates(updateInterval: TimeInterval,
                          maxCount: Int,
                          addInterval: TimeInterval?) {
        autoTimerUpdate?.invalidate()
        autoTimerUpdate = Timer.scheduledTimer(withTimeInterval: updateInterval,
                                               repeats: true,
                                               block: { [weak self] timer in
            self?.updateCampersLocation()
        })
        autoTimerAdd?.invalidate()
        if let addInterval = addInterval {
            autoTimerAdd = Timer.scheduledTimer(withTimeInterval: addInterval,
                                               repeats: true,
                                               block: { [weak self] timer in
                guard let self = self else { return }
                if self.campers.count < maxCount {
                     self.addCamper()
                } else {
                    timer.invalidate()
                }
            })
        }
    }


    private func updateCampersLocation() {
        for camper in campers {
            update(camper: camper)
        }
    }

    private func addCamper() {
        if let camper = pseudoRandomCamper() {
            campers.append(camper)
            update(camper: camper)
        }
    }

    private func randomCampers(count: Int) -> [Camper] {
        var rCampers = [Camper]()
        for _ in 0..<count {
            if let camper = pseudoRandomCamper(in: self.mapRegion) {
                rCampers.append(camper)
            }
        }
        return rCampers
    }

    private func pseudoRandomCamper(in mapRegion: MKCoordinateRegion? = nil) -> Camper? {
        if let firstName = Seed.firstNames.randomElement(),
           let lastName = Seed.lastNames.randomElement() {
                let id = Seed.generateId()
                let phone = Seed.generatePhone()
                var coord = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
                if let mapRegion = mapRegion {
                    let center = mapRegion.center

                    let deltaLat = mapRegion.span.latitudeDelta / 2
                    let minLat = center.latitude - deltaLat
                    let maxLat = center.latitude + deltaLat
                    let lat = Double.random(in: minLat..<maxLat)

                    let deltaLng = mapRegion.span.longitudeDelta / 2
                    let minLng = center.longitude - deltaLng
                    let maxLng = center.longitude + deltaLng
                    let lng = Double.random(in: minLng..<maxLng)

                    coord = CLLocationCoordinate2D(latitude: lat, longitude: lng)

                } else if campers.count > 1 {
                    let spawnIndexL = Int.random(in: 0 ..< campers.count)
                    var spawnIndexR = spawnIndexL
                    while spawnIndexL == spawnIndexR {
                        spawnIndexR = Int.random(in: 0 ..< campers.count)
                    }
                    let coord1 = campers[spawnIndexL].location.coordinate
                    let coord2 = campers[spawnIndexR].location.coordinate
                    let lat: Double = (coord1.latitude + coord2.latitude) / 2
                    let lng: Double = (coord1.longitude + coord2.longitude) / 2
                    coord = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                }
                let location = CLLocation(coordinate: coord,
                                          altitude: 0.0,
                                          horizontalAccuracy: 0.0,
                                          verticalAccuracy: 0.0,
                                          timestamp: Date())
                let camper = Camper(id: id, firstName: firstName, lastName: lastName, phone: phone, location: location)
                return camper
        }
        return nil
    }
 }
