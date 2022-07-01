//
//  HomeWireframe.swift
//  Valorant
//
//  Created by Pinto Junior, William James on 29/06/22.
//

import Foundation

protocol HomeWireframeInterface: WireframeInterface {
    static func start() -> HomeWireframeInterface
    
    func navigateToSeeAgent(agent: AgentModel)
}

class HomeWireframe: HomeWireframeInterface {
    // MARK: - Variables
    var entry: EntryPoint?
    
    // MARK: - Lifecycle
    static func start() -> HomeWireframeInterface {
        let router = HomeWireframe()
        
        var view: HomeViewInterface = HomeViewController()
        var interactor: HomeInteractorInterface = HomeInteractor()
        var presenter: HomePresenterInterface = HomePresenter()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.wireframe = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entry = view as? EntryPoint
        
        return router
    }
    
    func navigateToSeeAgent(agent: AgentModel) {
        let seeAgent = SeeAgentWireframe.start(agent: agent)
        entry?.presentWireframe(seeAgent, animated: true, completion: nil)
    }
}
