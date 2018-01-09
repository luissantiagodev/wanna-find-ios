//
//  Protocols.swift
//  WannaFind
//
//  Created by Luis Santiago  on 1/8/18.
//  Copyright © 2018 Luis Santiago . All rights reserved.
//

import Foundation

protocol Delegate {
    func onRideAccepted()
}

protocol CancelDelegate {
    func onRideCancel()
}
