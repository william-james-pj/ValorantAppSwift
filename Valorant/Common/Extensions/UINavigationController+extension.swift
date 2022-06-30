//
//  UINavigationController+extension.swift
//  Valorant
//
//  Created by Pinto Junior, William James on 29/06/22.
//

import UIKit

extension UINavigationController {
    func pushWireframe(_ wireframe: WireframeInterface, animated: Bool = true) {
        guard let view = wireframe.entry else { return }
        self.pushViewController(view, animated: animated)
    }
    
    func setRootWireframe(_ wireframe: WireframeInterface, animated: Bool = true) {
        guard let view = wireframe.entry else { return }
        self.setViewControllers([view], animated: animated)
    }
}
