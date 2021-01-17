//
//  AppDelegate.swift
//  rssApp
//
//  Created by Mikhail Danilov on 15.01.2021.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let window = appDelegate.window  {
            
            let rssService = RssService()
            let viewController =  MainViewController()
            let router = MainRouter(view: viewController)
            let presenter = MainPresenter(view: viewController, router: router, rssService: rssService)
            viewController.setup(presenter: presenter)
    
            let navigationController = UINavigationController(rootViewController: viewController)
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
        return true
    }
}
