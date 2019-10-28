//
//  MockNetworkService.swift
//  GDP AppTests
//
//  Created by Kaipeng Wu on 28/10/19.
//  Copyright © 2019 Kaipeng Wu. All rights reserved.
//

import XCTest
@testable import GDP_App

class MockNetworkService: NetworkServicing{
    
    var getCountriesWithGDPResult: ([Country]?, NetworkError)?
    
    func getCountriesWithGDP(date: String, completionHandler: @escaping ([Country]?, NetworkError) -> ()) {
        
        guard let result = getCountriesWithGDPResult else {
            completionHandler(nil, .failure)
            return
        }
        
        completionHandler(result.0, result.1)
    }
    
    
}
