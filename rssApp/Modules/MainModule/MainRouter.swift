//
//  MainRouter.swift
//  rssApp
//
//  Created by Mikhail Danilov on 15.01.2021.
//

import UIKit

protocol MainRouterProtocol {
}

class MainRouter: MainRouterProtocol {
    
    weak var view: UIViewController?
    init(view: UIViewController) {
        self.view = view
    }
}
