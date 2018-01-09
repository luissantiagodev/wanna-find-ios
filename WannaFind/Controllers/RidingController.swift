//
//  RidingController.swift
//  WannaFind
//
//  Created by Luis Santiago  on 1/8/18.
//  Copyright © 2018 Luis Santiago . All rights reserved.
//

import UIKit

class RidingController: UIViewController {
    
    let menuView = UIView()
    
    let menuHeight = UIScreen.main.bounds.height / 4
    
    var isPresenting = false
    
    let cancelButton : UIButton = {
        let button = UIButton(type : .system);
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.setTitle("Cancell", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(menuView)
        view.backgroundColor = .clear
        setUpRootView()
    }
    
    func setUpRootView(){
        menuView.backgroundColor = .white
        menuView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuView.heightAnchor.constraint(equalToConstant: menuHeight),
            menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
    }
}


extension RidingController: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        guard let toVC = toViewController else { return }
        isPresenting = !isPresenting
        if isPresenting == true {
            containerView.addSubview(toVC.view)
            menuView.frame.origin.y += menuHeight
            
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                self.menuView.frame.origin.y -= self.menuHeight

            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                self.menuView.frame.origin.y += self.menuHeight
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        }
    }
}

