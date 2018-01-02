//
//  DetailRideController.swift
//  WannaFind
//
//  Created by Luis Santiago  on 12/30/17.
//  Copyright © 2017 Luis Santiago . All rights reserved.
//

import UIKit

class DetailRideController: UIViewController {

    let menuView = UIView()
    let menuHeight = UIScreen.main.bounds.height / 4
    var isPresenting = false
    
    lazy var backgroundDropView : UIView = {
        let view = UIView(frame: self.view.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    
    let confirmButton : UIButton = {
        let button = UIButton(type : .system);
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.setTitle("Confirm", for: .normal)
        return button
    }()
    
    func generateImageIcon(image : UIImage) -> UIImageView{
        let image = UIImageView(image: image)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }
    
    func generateTextViews(rawText : String) -> UITextView {
        let text = UITextView();
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .left
        text.font = UIFont.boldSystemFont(ofSize: 18)
        text.font = UIFont.systemFont(ofSize: 18)
        text.text = rawText
        return text
    }
    
    
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
        view.backgroundColor = .clear
        view.addSubview(backgroundDropView)
        view.addSubview(menuView)
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
       
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DetailRideController.handleTap(_:)))
        backgroundDropView.addGestureRecognizer(tapGesture)
        setUpConfirmationTrip()
    }
    
    func setUpConfirmationTrip(){
        let firstImage = generateImageIcon(image: #imageLiteral(resourceName: "icons8-radar-100(1)"))
        let firstText = generateTextViews(rawText: "Forum coatzacoalcos")
        //Auto layout for the inner view for the textview and imageview
        let originLocationContainer = UIView()
        originLocationContainer.translatesAutoresizingMaskIntoConstraints = false

        menuView.addSubview(originLocationContainer)
        NSLayoutConstraint.activate([
            originLocationContainer.topAnchor.constraint(equalTo: menuView.topAnchor),
            originLocationContainer.heightAnchor.constraint(equalTo: menuView.heightAnchor),
            originLocationContainer.centerXAnchor.constraint(equalTo: menuView.centerXAnchor),
            ])
        originLocationContainer.addSubview(firstImage)
        firstImage.backgroundColor = .red;
        originLocationContainer.addSubview(firstText)
        firstText.backgroundColor = .blue;
        
        NSLayoutConstraint.activate([
            firstImage.topAnchor.constraint(equalTo: originLocationContainer.topAnchor , constant : 10),
            firstImage.widthAnchor.constraint(equalToConstant: 50),
            firstImage.heightAnchor.constraint(equalToConstant: 50),
            firstImage.leadingAnchor.constraint(equalTo: originLocationContainer.leadingAnchor , constant : 10),
            firstText.topAnchor.constraint(equalTo: originLocationContainer.topAnchor , constant : 10),
            firstText.leadingAnchor.constraint(equalTo: firstImage.trailingAnchor),
            firstText.trailingAnchor.constraint(equalTo: originLocationContainer.trailingAnchor),
            firstText.heightAnchor.constraint(equalTo: originLocationContainer.heightAnchor),
            firstText.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension DetailRideController: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
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
            backgroundDropView.alpha = 0
            
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                self.menuView.frame.origin.y -= self.menuHeight
                self.backgroundDropView.alpha = 1
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                self.menuView.frame.origin.y += self.menuHeight
                self.backgroundDropView.alpha = 0
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        }
    }
}
