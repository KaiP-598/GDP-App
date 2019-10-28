//
//  NetworkService.swift
//  GDP App
//
//  Created by Kaipeng Wu on 27/10/19.
//  Copyright © 2019 Kaipeng Wu. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import ObjectMapper

enum NetworkError: Error {
    case failure
    case success
}

protocol NetworkServicing {
    func getCountriesWithGDP(date: String, completionHandler: @escaping ([Country]?, NetworkError) -> ())
}

class NetworkService: NetworkServicing{
    
    let COUNTRY_GDP_END_POINT = "http://api.worldbank.org/v2/country/indicator/NY.GDP.MKTP.CD?format=json&per_page=500"
    
    /// Get all country GDP data from the endpoint
    ///
    /// - parameter completionHandler: handler containing Country array and network result.
    func getCountriesWithGDP(date: String, completionHandler: @escaping ([Country]?, NetworkError) -> ()) {
        let finalEnpoint = COUNTRY_GDP_END_POINT + "&date=" + date
        
        Alamofire.request(finalEnpoint).responseJSON { response in
            guard let data = response.data else {
                completionHandler(nil, .failure)
                return
            }
            
            let json = try? JSON(data: data)
  
            if let jsonArray = json?.array, jsonArray.count > 1 {
                //Map the returned JSON array to array of countries
                let countryArray = jsonArray[1]
                let countries = Mapper<Country>().mapArray(JSONObject: countryArray.arrayObject)
                completionHandler(countries, .success)
                return
            } else {
                completionHandler(nil, .failure)
                return
            }
            
        }
    }
    
}

