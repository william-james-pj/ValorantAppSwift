//
//  WeaponCollectionViewCell.swift
//  Valorant
//
//  Created by Pinto Junior, William James on 30/06/22.
//

import UIKit

class WeaponCollectionViewCell: UICollectionViewCell {
    // MARK: - Constants
    static let resuseIdentifier: String = "WeaponCollectionViewCell"
    
    // MARK: - Components
    fileprivate let imageViewWeapon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate let viewShadow: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let labelName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupVC()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    fileprivate func setupVC() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 16
        self.backgroundColor = UIColor(red: 0.15, green: 0.43, blue: 0.55, alpha: 1.00)
        
        buildHierarchy()
        buildConstraints()
    }
    
    // MARK: - Methods
    func settingCell(weapon: WeaponModel) {
        
        if let url = URL(string: weapon.displayIcon) {
            loadImage(url: url)
        }
        
        self.labelName.text = weapon.displayName.uppercased()
    }
    
    fileprivate func buildHierarchy() {
        self.addSubview(viewShadow)
        self.addSubview(imageViewWeapon)
        self.addSubview(labelName)
    }
    
    fileprivate func buildConstraints() {
        NSLayoutConstraint.activate([
            viewShadow.topAnchor.constraint(equalTo: self.topAnchor),
            viewShadow.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            viewShadow.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            viewShadow.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            imageViewWeapon.topAnchor.constraint(equalTo: self.topAnchor),
            imageViewWeapon.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageViewWeapon.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageViewWeapon.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            labelName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            labelName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
        ])
    }
}

extension WeaponCollectionViewCell {
    fileprivate func loadImage(url: URL){
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageViewWeapon.image = image
                    }
                }
            }
        }
    }
}
