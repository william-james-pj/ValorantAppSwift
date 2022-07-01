//
//  SeeAgentWireframe.swift
//  Valorant
//
//  Created by Pinto Junior, William James on 30/06/22.
//

import Foundation

protocol SeeAgentWireframeInterface: WireframeInterface {
    static func start(agent: AgentModel) -> SeeAgentWireframeInterface
}

class SeeAgentWireframe: SeeAgentWireframeInterface {
    // MARK: - Variables
    var entry: EntryPoint?
    
    // MARK: - Lifecycle
    static func start(agent: AgentModel) -> SeeAgentWireframeInterface {
        let router = SeeAgentWireframe()
        
        var view: SeeAgentViewInterface = SeeAgentViewController()
        var presenter: SeeAgentPresenterInterface = SeeAgentPresenter()
        
        view.presenter = presenter
        
        presenter.wireframe = router
        presenter.view = view
        presenter.setAgent(agent)
        
        router.entry = view as? EntryPoint
        
        return router
    }
}
