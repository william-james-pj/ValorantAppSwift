//
//  HomeInteractor.swift
//  Valorant
//
//  Created by Pinto Junior, William James on 29/06/22.
//

import Foundation

protocol HomeInteractorInterface: InteractorInterface {
    var presenter: HomePresenterInterface? { get set }
    
    func getAgents()
}

class HomeInteractor: HomeInteractorInterface {
    // MARK: - Variables
    var presenter: HomePresenterInterface?
    
    // MARK: - Methods
    func getAgents() {
        guard let url = URL(string: "https://valorant-api.com/v1/agents?isPlayableCharacter=true") else {
            return
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                self?.presenter?.interactorDidFetchAgents(with: .failure(FetchError.failed))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(AgentAPIResult.self, from: data)
                self?.presenter?.interactorDidFetchAgents(with: .success(response.data))
            }
            catch {
                self?.presenter?.interactorDidFetchAgents(with: .failure(error))
            }
        }
        
        task.resume()
    }
}
