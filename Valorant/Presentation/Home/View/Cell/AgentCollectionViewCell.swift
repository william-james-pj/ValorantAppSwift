//
//  AgentCollectionViewCell.swift
//  Valorant
//
//  Created by Pinto Junior, William James on 29/06/22.
//

import UIKit

class AgentCollectionViewCell: UICollectionViewCell {
    // MARK: - Constants
    static let resuseIdentifier: String = "AgentCollectionViewCell"
    
    // MARK: - Variables
    
    // MARK: - Components
    fileprivate let stackBase: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    fileprivate let viewShadow: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let imageViewAgent: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate let labelName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
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
        
        buildHierarchy()
        buildConstraints()
    }
    
    // MARK: - Methods
    func settingCell(agent: AgentModel) {
        if let colors = agent.backgroundGradientColors {
            let arrayColor = colors.map() { hexStringToUIColor(hex: $0).cgColor }
            setGradientBackground(arrayColor)
        }
        else {
            self.backgroundColor = .brown
        }
        
        if let imgUrl = agent.bustPortrait, let url = URL(string: imgUrl) {
            self.loadImage(url: url)
        }
        
        self.labelName.text = agent.displayName
        
    }
    
    fileprivate func buildHierarchy() {
        self.addSubview(viewShadow)
        self.addSubview(imageViewAgent)
        self.addSubview(labelName)
    }
    
    fileprivate func buildConstraints() {
        NSLayoutConstraint.activate([
            viewShadow.topAnchor.constraint(equalTo: self.topAnchor),
            viewShadow.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            viewShadow.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            viewShadow.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            imageViewAgent.topAnchor.constraint(equalTo: self.topAnchor),
            imageViewAgent.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageViewAgent.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageViewAgent.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 6),
            
            labelName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            labelName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
        ])
    }
}

extension AgentCollectionViewCell {
    func hexStringToUIColor (hex:String) -> UIColor {
        let r, g, b, a: CGFloat
        
        let start = hex.index(hex.startIndex, offsetBy: 0)
        let hexColor = String(hex[start...])

        if hexColor.count == 8 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0

            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255

                return UIColor(red: r, green: g, blue: b, alpha: a)
            }
        }
        
        return .gray
    }
}

extension AgentCollectionViewCell {
    func setGradientBackground(_ colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colors[0], colors[3]]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds

        self.layer.insertSublayer(gradientLayer, at:0)
    }
}

extension AgentCollectionViewCell {
    fileprivate func loadImage(url: URL){
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageViewAgent.image = image
                    }
                }
            }
        }
    }
}
