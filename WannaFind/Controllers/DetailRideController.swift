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
    let menuHeight = UIScreen.main.bounds.height / 3 + 20

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
        text.font = UIFont.systemFont(ofSize: 16)
        text.text = rawText
        text.isEditable = false
        text.isSelectable = false
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
        let originLocationImage = generateImageIcon(image: #imageLiteral(resourceName: "icons8-radar-100(1)"))
        let originLocationText = generateTextViews(rawText: "Forum coatzacoalcos")
        //Auto layout for the inner view for the textview and imageview
        let originLocationContainer = UIView()
        originLocationContainer.translatesAutoresizingMaskIntoConstraints = false

        menuView.addSubview(originLocationContainer)
        NSLayoutConstraint.activate([
            originLocationContainer.topAnchor.constraint(equalTo: menuView.topAnchor , constant : 10),
            originLocationContainer.heightAnchor.constraint(equalToConstant: menuHeight / 3),
            originLocationContainer.centerXAnchor.constraint(equalTo: menuView.centerXAnchor),
            originLocationContainer.leadingAnchor.constraint(equalTo: menuView.leadingAnchor, constant: 10),
            ])
        originLocationContainer.addSubview(originLocationImage)
        originLocationContainer.addSubview(originLocationText)
        
        
        NSLayoutConstraint.activate([
            originLocationImage.topAnchor.constraint(equalTo: originLocationContainer.topAnchor , constant : 10),
            originLocationImage.widthAnchor.constraint(equalToConstant: 30),
            originLocationImage.heightAnchor.constraint(equalToConstant: 30),
            originLocationImage.leadingAnchor.constraint(equalTo: originLocationContainer.leadingAnchor , constant : 2),
            originLocationText.topAnchor.constraint(equalTo: originLocationContainer.topAnchor , constant : 5),
            originLocationText.leadingAnchor.constraint(equalTo: originLocationImage.trailingAnchor , constant : 5),
            originLocationText.trailingAnchor.constraint(equalTo: originLocationContainer.trailingAnchor),
            originLocationText.heightAnchor.constraint(equalToConstant : 50),
        ])
        
        //Second container for the destination
        let destinationContainer = UIView()
        destinationContainer.translatesAutoresizingMaskIntoConstraints = false
       
        menuView.addSubview(destinationContainer)
        NSLayoutConstraint.activate([
            destinationContainer.topAnchor.constraint(equalTo: originLocationContainer.bottomAnchor , constant : -5),
            destinationContainer.heightAnchor.constraint(equalToConstant: menuHeight / 3),
            destinationContainer.centerXAnchor.constraint(equalTo: menuView.centerXAnchor),
            destinationContainer.leadingAnchor.constraint(equalTo: menuView.leadingAnchor, constant: 10)
            ])
        
        let destinationIcon = generateImageIcon(image: #imageLiteral(resourceName: "icons8-marker-100(1)"))
        let destinationText = generateTextViews(rawText: "Teotihuacan 502, colonia teresa morales")
        
        destinationContainer.addSubview(destinationIcon)
        destinationContainer.addSubview(destinationText)
        NSLayoutConstraint.activate([
            destinationIcon.topAnchor.constraint(equalTo: destinationContainer.topAnchor , constant : 10),
            destinationIcon.widthAnchor.constraint(equalToConstant: 30),
            destinationIcon.heightAnchor.constraint(equalToConstant: 30),
            destinationIcon.leadingAnchor.constraint(equalTo: destinationContainer.leadingAnchor , constant : 2),
            destinationText.topAnchor.constraint(equalTo: destinationContainer.topAnchor , constant : 5),
            destinationText.leadingAnchor.constraint(equalTo: destinationIcon.trailingAnchor , constant : 5),
            destinationText.trailingAnchor.constraint(equalTo: destinationContainer.trailingAnchor),
            destinationText.heightAnchor.constraint(equalToConstant : 50),
            ])
        
        // Adding the confirm button
        menuView.addSubview(confirmButton)
        NSLayoutConstraint.activate([
                confirmButton.centerXAnchor.constraint(equalTo: menuView.centerXAnchor),
                confirmButton.topAnchor.constraint(equalTo: destinationContainer.bottomAnchor, constant: 10),
                confirmButton.heightAnchor.constraint(equalToConstant: 30)
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
