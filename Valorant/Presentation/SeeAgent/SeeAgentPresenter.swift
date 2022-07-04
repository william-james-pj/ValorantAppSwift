//
//  SeeAgentPresenter.swift
//  Valorant
//
//  Created by Pinto Junior, William James on 30/06/22.
//

import Foundation

protocol SeeAgentPresenterInterface: PresenterInterface {
    var wireframe: SeeAgentWireframeInterface? { get set }
    var view: SeeAgentViewInterface? { get set }
    
    func setAgent(_ agent: AgentModel)
}

class SeeAgentPresenter: SeeAgentPresenterInterface {
    // MARK: - Variables
    var wireframe: SeeAgentWireframeInterface?
    var view: SeeAgentViewInterface?
    
    // MARK: - Methods
    func setAgent(_ agent: AgentModel) {
        self.view?.updateWithAgent(agent)
    }
}
