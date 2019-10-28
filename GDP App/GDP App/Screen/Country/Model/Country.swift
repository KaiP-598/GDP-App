//
//  Country.swift
//  GDP App
//
//  Created by Kaipeng Wu on 27/10/19.
//  Copyright © 2019 Kaipeng Wu. All rights reserved.
//

import Foundation
import ObjectMapper

class Country: Mappable {
    var indicator: Indicator?
    var countryCode: CountryCode?
    var countryiso3code: String?
    var date: String?
    var value: Double?
    
    
    
    init (){
        
    }
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        indicator <- map["indicator"]
        countryCode <- map["country"]
        countryiso3code <- map["countryiso3code"]
        date <- map["date"]
        value <- map["value"]
    }
}

