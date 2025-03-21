//
//  Model.swift
//  assessment
//
//  Created by kpc02007-macb3 on 3/21/25.
//

import Foundation

struct CountriesModel: Codable {
    let name: Name
    let region: String
    
    struct Name: Codable {
        let common: String
    }
}
