//
//  HomeViewController.swift
//  Valorant
//
//  Created by Pinto Junior, William James on 29/06/22.
//

import UIKit

protocol HomeViewInterface: ViewInterface {
    var presenter: HomePresenterInterface? { get set }
    
    func updateWithAgent(_ agents: [AgentModel])
}

class HomeViewController: UIViewController, HomeViewInterface {
    // MARK: - Variables
    var presenter: HomePresenterInterface?
    fileprivate var agentsData: [AgentModel] = []
    
    // MARK: - Components
    fileprivate let stackBase: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
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
    
    fileprivate let collectionViewHome: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
    // MARK: - Setup
    fileprivate func setupVC() {
        view.backgroundColor = UIColor(named: "Backgroud")
        buildHierarchy()
        buildConstraints()
        setupCollection()
    }

    fileprivate func setupCollection() {
        collectionViewHome.dataSource = self
        collectionViewHome.delegate = self

        collectionViewHome.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.resuseIdentifier)
    }
    
    // MARK: - Methods
    func updateWithAgent(_ agents: [AgentModel]) {
        DispatchQueue.main.async {
            self.agentsData = agents
            self.collectionViewHome.reloadData()
        }
    }
    
    fileprivate func buildHierarchy() {
        view.addSubview(stackBase)
        stackBase.addArrangedSubview(viewHeader)
        viewHeader.addSubview(imageViewHeader)
        stackBase.addArrangedSubview(collectionViewHome)
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
        return self.agentsData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.resuseIdentifier, for: indexPath) as! HomeCollectionViewCell
        cell.settingCell(agent: self.agentsData[indexPath.row])
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
