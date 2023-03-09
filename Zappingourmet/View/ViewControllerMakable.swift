//
//  ViewControllerMakable.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/03/09.
//

import UIKit

protocol ViewControllerMakable: UIViewController {

    associatedtype Params: Any

    static var storyboardName: String { get }

    var params: Params? { get set }

}

extension ViewControllerMakable {

    static func makeViewController(params: Params) -> Self {
        let viewController = UIStoryboard(name: Self.storyboardName, bundle: nil).instantiateInitialViewController()! as Self
        viewController.params = params

        return viewController
    }

}
