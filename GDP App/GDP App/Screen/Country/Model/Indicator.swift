//
//  Indicator.swift
//  GDP App
//
//  Created by Kaipeng Wu on 27/10/19.
//  Copyright © 2019 Kaipeng Wu. All rights reserved.
//

import Foundation
import ObjectMapper

class Indicator: Mappable {
    var id: String?
    var value: String?
    
    init (){
        
    }
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        value <- map["value"]
    }
}
