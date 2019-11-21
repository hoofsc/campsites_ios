//
//  Seed.swift
//  Campsites
//
//  Created by DH on 11/20/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import Foundation

struct Seed {
    static let firstNames: [String] = [
        "Ned",
        "Robert",
        "Jaime",
        "Catelyn",
        "Cersei",
        "Dany",
        "Jorah",
        "Jon",
        "Sansa",
        "Arya",
        "Robb",
        "Theon",
        "Bran",
        "Joffrey",
        "Sandor",
        "Tyrion",
        "Petyr",
        "Davos",
        "Bronn",
        "Margaery",
        "Tywin",
        "Joe",
        "Rose",
        "Charles",
        "Kristopher",
        "Iwan",
        "Hannah",
        "Michael",
        "Jacob",
        "Indira",
        "Michiel",
        "Tom",
        "Nathalie"
    ]

    static let lastNames: [String] = [
        "Stark",
        "Baratheon",
        "Lannister",
        "Targaryen",
        "Mormont",
        "Snow",
        "Clegane",
        "Drogo",
        "Tyrell",
        "Maegyr",
        "Giantsbane",
        "Greyjoy",
        "Sand",
        "Bolton",
        "Naharis",
        "Slynt",
        "Cassel",
        "Payne",
        "Selmy",
        "Aemon",
        "Luwin",
        "Arryn",
        "Mordane",
        "Greenhands",
        "Hollard",
        "Reed",
        "Frey",
        "Tarly",
        "Karstark"
    ]

    static let areaCodes: [String] = [
        "209", "213", "279", "310", "323", "408", "415", "424", "442", "510", "530", "559", "562", "619",
        "626", "628", "650", "657", "661", "669", "707", "714", "747", "760", "805", "818", "820", "831",
        "858", "909", "916", "925", "949", "951"
    ]

    static let digits: [String] = [
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
    ]


    static func generateId() -> String {
        return UUID().uuidString
    }

    static func generatePhone() -> String {
        func generatePrefix() -> String {
            return "\(Int.random(in: 201 ..< 999))"
        }
        func generateSuffix() -> String {
            return "\(Int.random(in: 1111 ..< 9999))"
        }
        if let areaCode = Seed.areaCodes.randomElement() {
            return areaCode + "-" + generatePrefix() + "-" + generateSuffix()
        }
        return "800-555-1212"
    }
}
