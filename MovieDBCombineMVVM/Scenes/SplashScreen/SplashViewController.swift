//
//  SplashViewController.swift
//  MovieDBMVP
//
//  Created by Abdullah Onur Şimşek on 20.01.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    private lazy var logoImageView: UIImageView = {
        let view: UIImageView = .init(image: .clapperIcon.withTintColor(.tmdbDarkBlue))
         view.contentMode = .scaleAspectFit
         view.alpha = 0
        return view
    }()
    
    override func loadView() {
        super.loadView()
        setUI()
        setLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateLogo()
    }
    
    private func setUI() {
        self.view.backgroundColor = .tmdbLightGreen
    }
    
    private func setLayout() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(logoImageView)
        logoImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
        logoImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    private func animateLogo() {
        UIView.animate(withDuration: 1.5,
                       delay: 0.1,
                       options: .curveEaseIn) {
            self.logoImageView.alpha = 1
        } completion: { _ in
            let vc = HomeViewBuilder().createHomeScreen()
            self.setRootVC(newRoot: vc)
        }
        
    }
    
    func setRootVC(newRoot viewController: UIViewController) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let delegate = windowScene?.delegate as? SceneDelegate
        let window = delegate?.window
        
        guard let keyWindow = window
        else { return }
        
        UIView.transition(with: keyWindow,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            UIApplication.shared.windows.first?.rootViewController = viewController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            UIView.setAnimationsEnabled(oldState)
        })
        
    }

    
}
