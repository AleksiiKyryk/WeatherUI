//
//  Location.swift
//  Weather UI
//
//  Created by Aleksii Kyryk on 15/08/2021.
//

import Foundation

struct Location: Identifiable{
    let id = UUID()
    let imageName: String
    let city: String
    let country: String
}

struct MyLocations{
    static let mylocations = [
        Location(imageName: "NL", city: "Enschede", country: "The Kingdom of the Netherlands"),
        Location(imageName: "CY", city: "Nicosia", country: "Cyprus"),
        Location(imageName: "UA", city: "Kyiv", country: "Ukraine"),
        Location(imageName: "AU", city: "Vienna", country: "Austria"),
        Location(imageName: "NL", city: "Rotterdam", country: "The Kingdom of the Netherlands"),
        Location(imageName: "SWI", city: "Geneve", country: "Switzerland")
    ]
}
