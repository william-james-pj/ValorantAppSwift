//
//  WireframeInterface.swift
//  Valorant
//
//  Created by Pinto Junior, William James on 29/06/22.
//

import UIKit

typealias EntryPoint = ViewInterface & UIViewController

protocol WireframeInterface {
    var entry: EntryPoint? { get }
}
