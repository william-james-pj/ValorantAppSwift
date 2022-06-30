//
//  WeaponModel.swift
//  Valorant
//
//  Created by Pinto Junior, William James on 30/06/22.
//

import Foundation

struct WeaponAPIResult: Codable {
    let data: [WeaponModel]
}

struct WeaponModel: Codable {
    let uuid: String
    let displayName: String
    let displayIcon: String
}
