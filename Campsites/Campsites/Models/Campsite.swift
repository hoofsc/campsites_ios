//
//  Campsite.swift
//  Campsites
//
//  Created by DH on 11/7/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import Foundation
import CoreLocation

struct Campsite: Codable {
    
    let id: String
    let name: String
    let description: String
    let isClosed: Bool
    let location: CLLocation
    

    public enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case isClosed
        case location
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        isClosed = try container.decode(Bool.self, forKey: .isClosed)
        
        let locationContainer = try container.nestedContainer(keyedBy: CLLocation.CodingKeys.self, forKey: .location)
        let latitude = try locationContainer.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try locationContainer.decode(CLLocationDegrees.self, forKey: .longitude)
        let altitude = try locationContainer.decode(CLLocationDistance.self, forKey: .altitude)
        let horizontalAccuracy = try locationContainer.decode(CLLocationAccuracy.self, forKey: .horizontalAccuracy)
        let verticalAccuracy = try locationContainer.decode(CLLocationAccuracy.self, forKey: .verticalAccuracy)
        let speed = try locationContainer.decode(CLLocationSpeed.self, forKey: .speed)
        let course = try locationContainer.decode(CLLocationDirection.self, forKey: .course)
        let timestamp = try locationContainer.decode(Date.self, forKey: .timestamp)
        location = CLLocation(coordinate: CLLocationCoordinate2DMake(latitude, longitude),
                                  altitude: altitude,
                                  horizontalAccuracy: horizontalAccuracy,
                                  verticalAccuracy: verticalAccuracy,
                                  course: course,
                                  speed: speed,
                                  timestamp: timestamp)
    }
}

