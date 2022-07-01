//
//  SeeAgentViewController.swift
//  Valorant
//
//  Created by Pinto Junior, William James on 30/06/22.
//

import UIKit
import Combine

protocol SeeAgentViewInterface: ViewInterface {
    var presenter: SeeAgentPresenterInterface? { get set }
    
    func updateWithAgent(_ agent: AgentModel)
}

class SeeAgentViewController: UIViewController, SeeAgentViewInterface {
    // MARK: - Variables
    var presenter: SeeAgentPresenterInterface?
    fileprivate var segmentedSubscriber: AnyCancellable?
    fileprivate var abilitiesData: [AbilitiesAgentModel]?
    
    // MARK: - Components
    fileprivate var scrollView: UIScrollView = {
      let scrollView = UIScrollView()
      scrollView.translatesAutoresizingMaskIntoConstraints = false
      return scrollView
    }()
    
    fileprivate var contentView: UIView = {
      let contentView = UIView()
      contentView.translatesAutoresizingMaskIntoConstraints = false
      return contentView
    }()
    
    fileprivate let viewGradient: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let stackBase: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    fileprivate let stackContent: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    fileprivate let viewHeader: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let viewShadowBackgroud: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let viewShadow: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let imageViewAgent: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate let labelNameBackgroud: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 100, weight: .bold)
        label.textColor = .white
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let labelName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let labelBio: UILabel = {
        let label = UILabel()
        label.text = "BIO"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let labelDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let stackBio: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    fileprivate let labelAbilities: UILabel = {
        let label = UILabel()
        label.text = "SPECIAL ABILITIES"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let abilitiesSegmentedControl: AbilitiesSegmentedControl = {
        let segmentedControl = AbilitiesSegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    fileprivate let labelAbilitiName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let labelAbilitiDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let stackAbiliti: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    fileprivate let stackAbilities: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    fileprivate var viewFooter: UIView = {
      let contentView = UIView()
      contentView.translatesAutoresizingMaskIntoConstraints = false
      return contentView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }

    // MARK: - Setup
    fileprivate func setupVC() {
        self.view.backgroundColor = UIColor(named: "Backgroud")
        
        self.segmentedSubscriber = self.abilitiesSegmentedControl.$indexSelected
            .sink { indexSelected in
                guard let abilitiesData = self.abilitiesData else {
                    return
                }

                let element = abilitiesData[indexSelected]
                self.labelAbilitiName.text = element.displayName
                self.labelAbilitiDescription.text = element.description
            }
        
        buildHierarchy()
        buildConstraints()
    }
    
    // MARK: - Methods
    func updateWithAgent(_ agent: AgentModel) {
        if let colors = agent.backgroundGradientColors {
            let arrayColor = colors.map() { hexStringToUIColor(hex: $0) }
            self.viewGradient.backgroundColor = arrayColor[0]
            let arrayColorOpacit = colors.map() { hexStringToUIColor(hex: $0, opacit: 0.6) }
            self.viewShadowBackgroud.backgroundColor = arrayColorOpacit[0]
        }
        
        if let imgUrl = agent.fullPortraitV2, let url = URL(string: imgUrl) {
            self.loadImage(url: url)
        }
        
        self.labelName.text = agent.displayName.uppercased()
        self.labelDescription.text = agent.description
        setLabelNameBackgroud(agent.displayName)
        
        self.abilitiesSegmentedControl.setViesByAbilities(agent.abilities)
        
        self.abilitiesData = agent.abilities
    }
    
    fileprivate func setLabelNameBackgroud(_ text: String) {
        if text.count <= 5 {
            self.labelNameBackgroud.text = text.uppercased()
            return
        }
        
        let textStart = text.prefix(4)
        let textEnd = text.suffix(text.count - 4)
        let textFull = textStart.uppercased() + " " + textEnd.uppercased()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.8
        paragraphStyle.alignment = .right
        let attrString = NSMutableAttributedString(string: textFull)
        attrString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))

        self.labelNameBackgroud.attributedText = attrString
    }
    
    fileprivate func buildHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(viewGradient)
        contentView.addSubview(labelNameBackgroud)
        contentView.addSubview(viewShadowBackgroud)
        contentView.addSubview(viewShadow)
        
        contentView.addSubview(stackBase)
        stackBase.addArrangedSubview(viewHeader)
            viewHeader.addSubview(imageViewAgent)
            viewHeader.addSubview(labelName)
        
        stackBase.addArrangedSubview(stackContent)
        stackContent.addArrangedSubview(stackBio)
        stackBio.addArrangedSubview(labelBio)
        stackBio.addArrangedSubview(labelDescription)
        
        stackContent.addArrangedSubview(stackAbilities)
        stackAbilities.addArrangedSubview(labelAbilities)
        stackAbilities.addArrangedSubview(abilitiesSegmentedControl)
        stackAbilities.addArrangedSubview(stackAbiliti)
        stackAbiliti.addArrangedSubview(labelAbilitiName)
        stackAbiliti.addArrangedSubview(labelAbilitiDescription)
        
        stackContent.addArrangedSubview(viewFooter)
    }
    
    fileprivate func buildConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            stackBase.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            stackBase.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackBase.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackBase.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            viewHeader.heightAnchor.constraint(equalToConstant: 300),
            
            viewGradient.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewGradient.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewGradient.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            viewGradient.bottomAnchor.constraint(equalTo: viewHeader.bottomAnchor),
            
            labelNameBackgroud.topAnchor.constraint(equalTo: viewHeader.topAnchor, constant: 8),
            labelNameBackgroud.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            labelNameBackgroud.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            viewShadowBackgroud.topAnchor.constraint(equalTo: viewGradient.topAnchor),
            viewShadowBackgroud.leadingAnchor.constraint(equalTo: viewGradient.leadingAnchor),
            viewShadowBackgroud.trailingAnchor.constraint(equalTo: viewGradient.trailingAnchor),
            viewShadowBackgroud.bottomAnchor.constraint(equalTo: viewGradient.bottomAnchor),
            
            viewShadow.topAnchor.constraint(equalTo: viewGradient.topAnchor),
            viewShadow.leadingAnchor.constraint(equalTo: viewGradient.leadingAnchor),
            viewShadow.trailingAnchor.constraint(equalTo: viewGradient.trailingAnchor),
            viewShadow.bottomAnchor.constraint(equalTo: viewGradient.bottomAnchor),
            
            imageViewAgent.topAnchor.constraint(equalTo: viewHeader.topAnchor),
            imageViewAgent.leadingAnchor.constraint(equalTo: viewHeader.leadingAnchor),
            imageViewAgent.trailingAnchor.constraint(equalTo: viewHeader.trailingAnchor),
            imageViewAgent.bottomAnchor.constraint(equalTo: viewHeader.bottomAnchor, constant: 6),
            
            labelName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelName.bottomAnchor.constraint(equalTo: viewHeader.bottomAnchor, constant: -32),
            
            viewFooter.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}

extension SeeAgentViewController {
    func hexStringToUIColor (hex:String, opacit: CGFloat? = nil) -> UIColor {
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
                
                if let opacit = opacit {
                    a = opacit
                }
                else {
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                }

                return UIColor(red: r, green: g, blue: b, alpha: a)
            }
        }
        
        return .gray
    }
}

extension SeeAgentViewController {
    func setGradientBackground(_ colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colors[0], colors[3]]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.viewGradient.bounds

        self.viewGradient.layer.insertSublayer(gradientLayer, at:0)
    }
}

extension SeeAgentViewController {
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
