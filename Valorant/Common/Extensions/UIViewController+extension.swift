//
//  UIViewController+extension.swift
//  Valorant
//
//  Created by Pinto Junior, William James on 29/06/22.
//

import UIKit

extension UIViewController {
    func presentWireframe(_ wireframe: WireframeInterface, animated: Bool = true, completion: (()->())? = nil) {
        guard let view = wireframe.entry else { return }
        present(view, animated: animated, completion: completion)
    }
}
