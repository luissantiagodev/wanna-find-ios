//
//  UserViewModel.swift
//  WannaFind
//
//  Created by Luis Santiago  on 1/5/18.
//  Copyright © 2018 Luis Santiago . All rights reserved.
//

import Foundation
import CoreLocation

class UserViewModel {
    
    private var user : User
    
    init(_ user : User) {
        self.user = user
    }
    
    public var originUserLocation : CLLocationCoordinate2D {
        get{
          return user.originLocation
        }
        set(newLocation){
            user.originLocation = newLocation
        }
    }
    
    public var destinationLocation : CLLocationCoordinate2D {
        get{
            return user.destinationLocation
        }
        set(newLocation){
            user.destinationLocation = newLocation
        }
    }
    
    public var getCompleteInformation : User {
        return self.user
    }
}
