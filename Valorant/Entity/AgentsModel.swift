//
//  AgentsModel.swift
//  Valorant
//
//  Created by Pinto Junior, William James on 29/06/22.
//

import Foundation

struct AgentAPIResult: Codable {
    let data: [AgentModel]
}

struct AgentModel: Codable {
    let uuid: String
    let displayName: String
    let description: String
    let background: String?
    let backgroundGradientColors: [String]?
    let bustPortrait: String?
    let fullPortrait: String?
}
