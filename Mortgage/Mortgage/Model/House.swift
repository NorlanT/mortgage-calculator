//
//  House.swift
//  Mortgage
//
//  Created by Norlan Tibanear on 6/16/20.
//  Copyright © 2020 Norlan Tibanear. All rights reserved.
//

import UIKit

struct House: Codable, Equatable {
    var cityName: String
    var stateName: String
    var priceName: Double
    var bedName: Int
    var bathName: Int
    var garageName: Int
    var introName: String
    var addressName: String
    var favorite: Bool
    var imageString: String
    var image: UIImage {
    return UIImage(named: imageString)!
    }
    
    init(cityName: String, stateName: String, priceName: Double, bedName: Int, bathName: Int, garageName: Int, introName: String, addressName: String, favorite: Bool = false, imageString: String) {
        self.cityName = cityName
        self.stateName = stateName
        self.priceName = priceName
        self.bedName = bedName
        self.bathName = bathName
        self.garageName = garageName
        self.introName = introName
        self.addressName = addressName
        self.favorite = favorite
        self.imageString = imageString
    }
}
