//
//  AbilitiesSegmentedControl.swift
//  Valorant
//
//  Created by Pinto Junior, William James on 01/07/22.
//

import UIKit
import Combine

class AbilitiesSegmentedControl: UIView {
    // MARK: - Variables
    @Published var indexSelected = 0
    
    fileprivate var views: [ViewAbilities] = []
    
    fileprivate var selectorTextColor = UIColor(named: "Primary")
    fileprivate var disableTextColor = UIColor(named: "Disabled")
    fileprivate var selectorViewColor = UIColor.clear
    fileprivate var disabeldViewColor = UIColor.clear
    
    // MARK: - Components
    fileprivate let viewStackAux: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: - Setup
    fileprivate func setupVC(_ abilities: [AbilitiesAgentModel]) {
        createButton(abilities)
        configStack()
    }
    
    // MARK: - Methods
    func setViesByAbilities(_ abilities: [AbilitiesAgentModel]) {
        self.setupVC(abilities)
    }
    
    fileprivate func createButton(_ abilities: [AbilitiesAgentModel]) {
        self.views = [ViewAbilities]()
        self.views.removeAll()
        self.subviews.forEach({$0.removeFromSuperview()})
        for abiliti in abilities {
            if let img = abiliti.displayIcon {
                let view = ViewAbilities()
                view.delegate = self
                view.setImage(img)
                self.views.append(view)
            }
        }
        self.views[0].selectView()
    }
    
    fileprivate func configStack() {
        let stackBase = UIStackView(arrangedSubviews: views)
        stackBase.axis = .horizontal
        stackBase.spacing = 16
        stackBase.distribution = .fill
        stackBase.translatesAutoresizingMaskIntoConstraints = false
        
        stackBase.addArrangedSubview(viewStackAux)
        
        self.addSubview(stackBase)
 
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 35),
            
            stackBase.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            stackBase.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackBase.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackBase.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}

extension AbilitiesSegmentedControl: ViewAbilitiesDelegate {
    func viewClicked(_ viewSelected: ViewAbilities) {
        for (indexView, view) in views.enumerated() {
            view.deselectView()
            
            if view == viewSelected {
                view.selectView()
                self.indexSelected = indexView
            }
        }
    }
}
