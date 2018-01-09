//
//  SplashScreen.swift
//  WannaFind
//
//  Created by Luis Santiago  on 1/7/18.
//  Copyright © 2018 Luis Santiago . All rights reserved.
//

import Foundation
import RevealingSplashView
import UIKit

extension MapController{
    func startSplashView(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let revealingSplashView = RevealingSplashView(iconImage: #imageLiteral(resourceName: "SplashIcon"),iconInitialSize: CGSize(width: 70, height: 70), backgroundColor: UIColor(red:0.11, green:0.56, blue:0.95, alpha:1.0))
        revealingSplashView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(revealingSplashView)
        revealingSplashView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true;
        revealingSplashView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true;
        revealingSplashView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true;
        revealingSplashView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true;
        revealingSplashView.useCustomIconColor = true
        revealingSplashView.iconColor = UIColor.red
        revealingSplashView.useCustomIconColor = false
        
        revealingSplashView.startAnimation(){
            print("Completed")
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}

