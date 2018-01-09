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
    
    let menuHeight = UIScreen.main.bounds.height / 4 - 20
    
    let widthOfDevice = UIScreen.main.bounds.width
    
    var isPresenting = false
    
    var cancelDelegate : CancelDelegate?
    
    let cancelButton : UIButton = {
        let button = UIButton(type : .system);
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.setTitle("Cancelar", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleCancelTrip), for: .touchUpInside)
        return button
    }()
    
    let textIndication : UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .left
        text.text = "Tiempo aproximado"
        text.font = UIFont.systemFont(ofSize: 16)
        text.isEditable = false
        text.isSelectable = false
        return text
    }()
    
    let timeText : UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center
        text.text = "5 Minutos"
        text.font = UIFont.systemFont(ofSize: 16)
        text.isEditable = false
        text.isSelectable = false
        return text
    }()
    
    let containerInfo : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        setUpInformationTrip()
    }
    
    func setUpInformationTrip(){
        //MARK : TODO : show the time information
        menuView.addSubview(containerInfo)
        NSLayoutConstraint.activate([
            containerInfo.topAnchor.constraint(equalTo: menuView.topAnchor , constant : 15),
            containerInfo.heightAnchor.constraint(equalTo : menuView.heightAnchor),
            containerInfo.leadingAnchor.constraint(equalTo: menuView.leadingAnchor, constant: 10),
            containerInfo.trailingAnchor.constraint(equalTo: menuView.trailingAnchor, constant: 10),
        ])
        
        containerInfo.addSubview(cancelButton)
        containerInfo.addSubview(textIndication)
        containerInfo.addSubview(timeText)
        
        NSLayoutConstraint.activate([
            textIndication.topAnchor.constraint(equalTo: containerInfo.topAnchor, constant: 5),
            textIndication.leadingAnchor.constraint(equalTo: containerInfo.leadingAnchor, constant: 10),
            textIndication.heightAnchor.constraint(equalToConstant: 30),
            textIndication.widthAnchor.constraint(equalToConstant: widthOfDevice / 2),
            timeText.topAnchor.constraint(equalTo: textIndication.bottomAnchor , constant : -3),
            timeText.leadingAnchor.constraint(equalTo: containerInfo.leadingAnchor, constant: 10),
            timeText.heightAnchor.constraint(equalToConstant: 40),
            timeText.widthAnchor.constraint(equalToConstant: widthOfDevice / 2),
            cancelButton.topAnchor.constraint(equalTo: containerInfo.topAnchor , constant : 13),
            cancelButton.widthAnchor.constraint(equalToConstant: 100),
            cancelButton.leadingAnchor.constraint(equalTo: timeText.trailingAnchor, constant: 15),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func handleCancelTrip(){
        cancelDelegate?.onRideCancel()
        dismiss(animated: true, completion: nil)
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

