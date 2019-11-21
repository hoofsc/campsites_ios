//
//  Camper.swift
//  Campsites
//
//  Created by DH on 11/7/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import Foundation
import CoreLocation

struct Camper: Codable, Identifiable, Equatable {
    
    let id: String
    let firstName: String
    let lastName: String
    let phone: String
    var location: CLLocation
    

    public enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case phone
        case location
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        phone = try container.decode(String.self, forKey: .phone)
        
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

    init(id: String, firstName: String, lastName: String, phone: String, location: CLLocation) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.location = location
    }
}
