//
//  BaseViewController.swift
//  MovieDBMVP
//
//  Created by Abdullah Onur Şimşek on 22.01.2024.
//

import UIKit

class BaseViewController: UIViewController {
    private var isShown: Bool = false
    private lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0,
                                                         width: 40, height: 40))
        view.style = UIActivityIndicatorView.Style.large
        view.color = .tmdbLightGreen
        view.center = CGPoint(x: UIScreen.main.bounds.width / 2,
                              y: UIScreen.main.bounds.height / 2)
        view.layer.zPosition = 10
        return view
    }()
    
    override func loadView() {
        super.loadView()
        setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarBackBarButtonItem(image: .arrowLeft)
    }
    
    func showProgressHUD() {
        if !isShown {
            isShown = true
            view.addSubview(indicator)
            view.bringSubviewToFront(indicator)
            indicator.startAnimating()
        }
        
    }

    func hideProgressHUD() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.indicator.stopAnimating()
            self.indicator.removeFromSuperview()
            self.isShown = false
        }
        
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
