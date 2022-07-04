//
//  ViewAbilities.swift
//  Valorant
//
//  Created by Pinto Junior, William James on 01/07/22.
//

import UIKit

protocol ViewAbilitiesDelegate {
    func viewClicked(_ viewSelected: ViewAbilities)
}

class ViewAbilities: UIView {
    // MARK: - Variables
    var delegate: ViewAbilitiesDelegate?
    
    // MARK: - Components
    fileprivate let imageViewAbilities: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate let viewBackgroud: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Backgroud")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let buttonMain: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupVC()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setBorderRadius(self)
        setBorderRadius(viewBackgroud)
    }
    
    // MARK: - Setup
    fileprivate func setupVC() {
        self.backgroundColor = .white
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        
        buildHierarchy()
        buildConstraints()
    }
    
    // MARK: - Actions
    @IBAction func buttonTapped(sender: UIButton) {
        self.delegate?.viewClicked(self)
    }
    
    // MARK: - Methods
    func selectView() {
        self.backgroundColor = UIColor(named: "Primary")
        self.layer.borderColor = UIColor(named: "Primary")?.cgColor
        self.viewBackgroud.backgroundColor = UIColor(named: "Primary")
    }
    
    func deselectView() {
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.white.cgColor
        self.viewBackgroud.backgroundColor = UIColor(named: "Backgroud")
    }
    
    func setImage(_ imgUrl: String) {
        if let url = URL(string: imgUrl) {
            self.loadImage(url: url)
        }
    }
    
    fileprivate func setBorderRadius(_ view: UIView) {
        let radius: CGFloat = 4
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .bottomRight], cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
    }
    
    fileprivate func buildHierarchy() {
        self.addSubview(viewBackgroud)
        self.addSubview(imageViewAbilities)
        self.addSubview(buttonMain)
    }
    
    fileprivate func buildConstraints() {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 35),
            self.heightAnchor.constraint(equalToConstant: 35),
            
            viewBackgroud.topAnchor.constraint(equalTo: self.topAnchor, constant: 1),
            viewBackgroud.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 1),
            viewBackgroud.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -1),
            viewBackgroud.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1),
            
            imageViewAbilities.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            imageViewAbilities.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            imageViewAbilities.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            imageViewAbilities.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            
            buttonMain.topAnchor.constraint(equalTo: self.topAnchor),
            buttonMain.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            buttonMain.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            buttonMain.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
        ])
    }
    
    func loadImage(url: URL){
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageViewAbilities.image = image
                    }
                }
            }
        }
    }
}
