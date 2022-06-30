//
//  MenuSegmentedControl.swift
//  Valorant
//
//  Created by Pinto Junior, William James on 30/06/22.
//

import UIKit
import Combine

class MenuSegmentedControl: UIView {
    // MARK: - Constants

    // MARK: - Variables
    @Published var indexSelected = 0
    
    fileprivate var buttonTitles: [String] = []
    fileprivate var buttons: [ButtomCustom] = []
    
    fileprivate var selectorTextColor = UIColor(named: "Primary")
    fileprivate var disableTextColor = UIColor(named: "Disabled")
    fileprivate var selectorViewColor = UIColor.clear
    fileprivate var disabeldViewColor = UIColor.clear
    
    // MARK: - Actions
    @IBAction func buttonTapped(sender: UIButton) {
        for (indexBtn, btn) in buttons.enumerated() {
            btn.setTitleColor(disableTextColor, for: .normal)
            
            if btn == sender {
                btn.setTitleColor(selectorTextColor, for: .normal)
                indexSelected = indexBtn
            }
        }
    }
    
    // MARK: - Setup
    fileprivate func setupVC() {
        createButton()
        configStack()
    }
    
    // MARK: - Methods
    func setButtonTitles(buttonTitles: [String]) {
        self.buttonTitles = buttonTitles
        self.setupVC()
    }
    
    fileprivate func createButton() {
        self.buttons = [ButtomCustom]()
        self.buttons.removeAll()
        self.subviews.forEach({$0.removeFromSuperview()})
        for buttonTitle in buttonTitles {
            let button = ButtomCustom()
            button.setTitle(buttonTitle.uppercased(), for: .normal)
            button.setTitleColor(disableTextColor, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
            button.layer.cornerRadius = 15
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            buttons.append(button)
        }
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
    }
    
    fileprivate func configStack() {
        let stackBase = UIStackView(arrangedSubviews: buttons)
        stackBase.axis = .horizontal
        stackBase.spacing = 8
        stackBase.distribution = .fill
        stackBase.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stackBase)
        
        NSLayoutConstraint.activate([
            stackBase.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            stackBase.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackBase.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackBase.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}

class ButtomCustom: UIButton {
    override var intrinsicContentSize: CGSize {
       get {
           let baseSize = super.intrinsicContentSize
           return CGSize(width: baseSize.width + 20,
                         height: baseSize.height)
           }
    }
}
