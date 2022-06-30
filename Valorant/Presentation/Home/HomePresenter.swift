//
//  HomePresenter.swift
//  Valorant
//
//  Created by Pinto Junior, William James on 29/06/22.
//

import Foundation

enum FetchError: Error {
    case failed
}

protocol HomePresenterInterface: PresenterInterface {
    var wireframe: HomeWireframeInterface? { get set }
    var interactor: HomeInteractorInterface? { get set }
    var view: HomeViewInterface? { get set }
    
    func interactorDidFetchAgents(with result: Result<[AgentModel], Error>)
}

class HomePresenter: HomePresenterInterface {
    // MARK: - Variables
    var wireframe: HomeWireframeInterface?
    var interactor: HomeInteractorInterface? {
        didSet {
            interactor?.getAgents()
        }
    }
    var view: HomeViewInterface?
    
    // MARK: - Methods
    func interactorDidFetchAgents(with result: Result<[AgentModel], Error>) {
        switch result {
        case .success(let dataContainer):
            self.view?.updateWithAgent(dataContainer)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
