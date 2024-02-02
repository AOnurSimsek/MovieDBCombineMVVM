//
//  SceneDelegate.swift
//  MovieDBCombineMVVM
//
//  Created by Abdullah Onur Şimşek on 1.02.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene)
        else { return }
        
        let vc = SplashViewBuilder().createSplashScreen()
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = vc
        window.backgroundColor = .red
        self.window = window
        
        setNavBar()
        
        window.makeKeyAndVisible()
    }
    
    private func setNavBar() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.text,
                                              NSAttributedString.Key.font: UIFont.custom(name: .LatoBold, size: 16)]
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
    }


    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }


}

