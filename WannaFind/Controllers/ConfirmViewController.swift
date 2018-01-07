//
//  DetailRideController.swift
//  WannaFind
//
//  Created by Luis Santiago  on 12/30/17.
//  Copyright © 2017 Luis Santiago . All rights reserved.
//

import UIKit
import CoreLocation
import PromiseKit

class DetailRideController: UIViewController {

    let menuView = UIView()
    
    let menuHeight = UIScreen.main.bounds.height / 3 + 20
    
    var currentUser : User?

    var isPresenting = false
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var key = "AIzaSyDzq3y5GT0isqTsLhgLG-0U34sWGidIFTk"
    
    lazy var backgroundDropView : UIView = {
        let view = UIView(frame: self.view.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    
    let confirmButton : UIButton = {
        let button = UIButton(type : .system);
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.setTitle("Confirm", for: .normal)
        button.backgroundColor = UIColor(white: 0.96, alpha: 1)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()
    
    func generateImageIcon(image : UIImage) -> UIImageView{
        let image = UIImageView(image: image)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }
    
    func setUpIndicatorView(){
        menuView.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: menuView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: menuView.centerYAnchor).isActive = true
        originLocationContainer.isHidden = true
        destinationContainer.isHidden = true
        confirmButton.isHidden = true
        activityIndicator.startAnimating()
    }
    
    let originLocationText : UITextView = {
        let text = UITextView();
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .left
        text.font = UIFont.systemFont(ofSize: 16)
        text.isEditable = false
        text.isSelectable = false
        return text
    }()
    
    
    let destinationText : UITextView = {
        let text = UITextView();
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .left
        text.font = UIFont.systemFont(ofSize: 16)
        text.isEditable = false
        text.isSelectable = false
        return text
    }()
    
    let originLocationContainer : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let destinationContainer : UIView = {
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
        view.backgroundColor = .clear
        view.addSubview(backgroundDropView)
        view.addSubview(menuView)
        setUpRootView()
        setUpIndicatorView();
        firstly{
          self.requestAddress(location: (self.currentUser?.originLocation)!)
        }.then{(adrress) in
          self.originLocationText.text = self.makeShortAddress(address : adrress)
        }.then{
          self.requestAddress(location: (self.currentUser?.destinationLocation)!)
        }.then{(address) in
            self.destinationText.text = self.makeShortAddress(address : address)
        }.always {
            self.stopAnimating()
        }
    }
    
    func stopAnimating(){
        self.originLocationContainer.isHidden = false
        self.destinationContainer.isHidden = false
        self.confirmButton.isHidden = false
        self.activityIndicator.stopAnimating()
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
        //Auto layout for the inner view for the textview and imageview
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
        menuView.addSubview(destinationContainer)
        NSLayoutConstraint.activate([
            destinationContainer.topAnchor.constraint(equalTo: originLocationContainer.bottomAnchor , constant : -5),
            destinationContainer.heightAnchor.constraint(equalToConstant: menuHeight / 3),
            destinationContainer.centerXAnchor.constraint(equalTo: menuView.centerXAnchor),
            destinationContainer.leadingAnchor.constraint(equalTo: menuView.leadingAnchor, constant: 10)
            ])
        
        let destinationIcon = generateImageIcon(image: #imageLiteral(resourceName: "icons8-marker-100(1)"))
        
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
                confirmButton.topAnchor.constraint(equalTo: destinationContainer.bottomAnchor, constant: -5),
                confirmButton.heightAnchor.constraint(equalToConstant: 40),
                confirmButton.widthAnchor.constraint(equalToConstant: 100)
            ])
        
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    public func requestAddress(location : CLLocationCoordinate2D)-> Promise<String> {
        let urlString = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(location.latitude),\(location.longitude)&key=\(key)"
        let url = URL(string: urlString)
        return Promise<String> { address , error  in
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if let error = error {
                    print(error)
                }
                guard let data = data else { return }
                let result = try? JSONDecoder().decode(Results.self, from: data)
                if let finalResult = result  {
                    let direction = finalResult.results[0].formatted_address
                    return address(direction)
                }
            }
            task.resume()
        }
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

extension DetailRideController {
    func makeShortAddress(address: String)->String {
        let locations = address.components(separatedBy: ",")
        let finalAddress = "\(locations[0]),\(locations[1])"
        print(finalAddress)
        return finalAddress
    }
}

struct Address : Decodable {
    var formatted_address : String
}

struct Results : Decodable {
    var results : [Address]
}


