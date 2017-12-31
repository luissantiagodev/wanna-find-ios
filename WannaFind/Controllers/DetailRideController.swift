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
        button.setTitle("Confirm", for: .normal);
        return button
    }()
    
    func generateImageIcon(image : UIImage) -> UIImageView{
        let image = UIImageView(image: image);
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }
    
    func generateTextViews(textRaw : String) -> UITextView {
        let text = UITextView();
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = textRaw
        return text
    }
    
    let mainStackView : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false;
        stack.distribution = .fillEqually
        stack.alignment = .fill;
        return stack
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
        view.backgroundColor = .clear
        view.addSubview(backgroundDropView)
        view.addSubview(menuView)
        setUpRootView()
    }
    
    
    func setUpRootView(){
        menuView.backgroundColor = .white
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.heightAnchor.constraint(equalToConstant: menuHeight).isActive = true
        menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        menuView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DetailRideController.handleTap(_:)))
        backgroundDropView.addGestureRecognizer(tapGesture);
        setUpConfirmationTrip()
    }
    
    func setUpConfirmationTrip(){
        menuView.addSubview(mainStackView);
        mainStackView.topAnchor.constraint(equalTo: menuView.topAnchor, constant: 10).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: menuView.leadingAnchor, constant: 10).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: menuView.trailingAnchor, constant: 10).isActive = true
        
        
        let firstImage = generateImageIcon(image: #imageLiteral(resourceName: "icons8-radar-100(1)"));
        let firtText = generateTextViews(textRaw: "Forum coatzacoalcos");
        
        let firstRowContainer = UIView()
        firstRowContainer.addSubview(firstImage)
        firstRowContainer.addSubview(firtText)
        
        
        
        
        let firstRow = UIStackView(arrangedSubviews: [firstImage,firtText]);
        firstRow.axis = .horizontal;
        firstRow.distribution = .fillEqually;
        firstRow.translatesAutoresizingMaskIntoConstraints = false;
        
         mainStackView.addArrangedSubview(firstRow);
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
