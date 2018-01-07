//
//  User.swift
//  WannaFind
//
//  Created by Luis Santiago  on 1/5/18.
//  Copyright © 2018 Luis Santiago . All rights reserved.
//

import Foundation
import CoreLocation

struct User {
    
     var originLocation : CLLocationCoordinate2D
     var destinationLocation : CLLocationCoordinate2D
    
    init(origin : CLLocationCoordinate2D , destination : CLLocationCoordinate2D) {
        self.originLocation = origin
        self.destinationLocation = destination
    }
}
