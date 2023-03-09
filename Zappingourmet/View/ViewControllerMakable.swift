//
//  ViewControllerMakable.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/03/09.
//

import UIKit

protocol ViewControllerMakable: UIViewController {

    associatedtype Params: Any

    var params: Params? { get set }

}

extension ViewControllerMakable {
    
    static var storyboardName: String {
        return Self.className
    }

    static func makeViewController(params: Params) -> Self {
        let viewController = UIStoryboard(name: Self.storyboardName, bundle: nil).instantiateInitialViewController()! as Self
        viewController.params = params

        return viewController
    }

}
