//
//  Address.swift
//  WannaFind
//
//  Created by Luis Santiago  on 1/3/18.
//  Copyright © 2018 Luis Santiago . All rights reserved.
//

import Foundation
import GooglePlaces
import GoogleMaps

private var key = "AIzaSyDzq3y5GT0isqTsLhgLG-0U34sWGidIFTk"

struct Address : Decodable {
    var formatted_address : String
}

struct Results : Decodable {
    var results : [Address]
}

public func requestAddress(location : CLLocationCoordinate2D) -> Void{
    let urlString = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(location.latitude),\(location.longitude)&key=\(key)"
    guard let url = URL(string: urlString) else {return}
    print(urlString)
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            print(error)
        }
        guard let data = data else { return }
        let result = try? JSONDecoder().decode(Results.self, from: data)
        if let finalResult = result  {
            print(finalResult.results[0].formatted_address)
        }else{
            print("Wrong decoding")
        }
    }.resume()
}
