//
//  HomeViewController.swift
//  Valorant
//
//  Created by Pinto Junior, William James on 29/06/22.
//

import UIKit
import Combine

enum CollectItemType {
    case agent
    case weapon
}

protocol HomeViewInterface: ViewInterface {
    var presenter: HomePresenterInterface? { get set }
    
    func updateWithAgent(_ agents: [AgentModel])
    func updateWithWeapon(_ weapons: [WeaponModel])
}

class HomeViewController: UIViewController, HomeViewInterface {
    // MARK: - Variables
    var presenter: HomePresenterInterface?
    fileprivate var agentsData: [AgentModel] = []
    fileprivate var weaponsData: [WeaponModel] = []
    fileprivate var menuSubscriber: AnyCancellable?
    fileprivate var collectionItemSelected: CollectItemType = .agent
    
    // MARK: - Components
    fileprivate let stackBase: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 32
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    fileprivate let viewHeader: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let imageViewHeader: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Valorant")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate let menuSegmentedControl: MenuSegmentedControl = {
        let segmentedControl = MenuSegmentedControl()
        segmentedControl.setButtonTitles(buttonTitles: ["Agents", "Weapons"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    fileprivate let viewMenuAux: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let stackMenu: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    fileprivate let collectionViewHome: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    fileprivate let stackContent: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
    // MARK: - Setup
    fileprivate func setupVC() {
        view.backgroundColor = UIColor(named: "Backgroud")
        
        menuSubscriber = self.menuSegmentedControl.$indexSelected.sink { indexSelected in
            if indexSelected == 0 {
                self.collectionItemSelected = .agent
            }
            else {
                self.collectionItemSelected = .weapon
            }
            self.collectionViewHome.reloadData()
        }
        
        buildHierarchy()
        buildConstraints()
        setupCollection()
    }

    fileprivate func setupCollection() {
        collectionViewHome.dataSource = self
        collectionViewHome.delegate = self

        collectionViewHome.register(AgentCollectionViewCell.self, forCellWithReuseIdentifier: AgentCollectionViewCell.resuseIdentifier)
        collectionViewHome.register(WeaponCollectionViewCell.self, forCellWithReuseIdentifier: WeaponCollectionViewCell.resuseIdentifier)
    }
    
    // MARK: - Methods
    func updateWithAgent(_ agents: [AgentModel]) {
        DispatchQueue.main.async {
            self.agentsData = agents
            self.collectionViewHome.reloadData()
        }
    }
    
    func updateWithWeapon(_ weapons: [WeaponModel]) {
        DispatchQueue.main.async {
            self.weaponsData = weapons
        }
    }
    
    fileprivate func buildHierarchy() {
        view.addSubview(stackBase)
        
        stackBase.addArrangedSubview(viewHeader)
            viewHeader.addSubview(imageViewHeader)
        
        stackBase.addArrangedSubview(stackContent)
        stackContent.addArrangedSubview(stackMenu)
            stackMenu.addArrangedSubview(menuSegmentedControl)
            stackMenu.addArrangedSubview(viewMenuAux)
        stackContent.addArrangedSubview(collectionViewHome)
    }
    
    fileprivate func buildConstraints() {
        NSLayoutConstraint.activate([
            stackBase.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackBase.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stackBase.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            stackBase.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            viewHeader.heightAnchor.constraint(equalToConstant: 50),
            
            imageViewHeader.widthAnchor.constraint(equalToConstant: 50),
            imageViewHeader.heightAnchor.constraint(equalToConstant: 50),
            imageViewHeader.centerXAnchor.constraint(equalTo: viewHeader.centerXAnchor),
            imageViewHeader.centerYAnchor.constraint(equalTo: viewHeader.centerYAnchor),
        ])
    }
}

// MARK: - extension UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
}

// MARK: - extension CollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.collectionItemSelected == .agent {
            return self.agentsData.count
        }
        return self.weaponsData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.collectionItemSelected == .agent {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AgentCollectionViewCell.resuseIdentifier, for: indexPath) as! AgentCollectionViewCell
            cell.settingCell(agent: self.agentsData[indexPath.row])
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeaponCollectionViewCell.resuseIdentifier, for: indexPath) as! WeaponCollectionViewCell
        cell.settingCell(weapon: self.weaponsData[indexPath.row])
        return cell
    }
}

// MARK: - extension CollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 2) - 10
        return CGSize(width: width, height: 150)
    }
}
