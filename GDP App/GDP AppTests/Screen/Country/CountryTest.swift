//
//  CountryTest.swift
//  GDP AppTests
//
//  Created by Kaipeng Wu on 28/10/19.
//  Copyright © 2019 Kaipeng Wu. All rights reserved.
//

import XCTest
import RxSwift
@testable import GDP_App

class CountryTest: XCTestCase {
    
    var viewModel: CountryViewModeling?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }
    
    func testSuccessfulGetCountries(){
        let disposeBag = DisposeBag()
        let networkService = MockNetworkService()
        let mockCountryArray = [Country(),Country()]
        let result: ([Country]?, NetworkError) = (mockCountryArray, NetworkError.success)
        networkService.getCountriesWithGDPResult = result
        viewModel = CountryViewModel.init(networkService: networkService)
        
        let expectCountriesFetched = expectation(description:"Fetched result contains countries data")
        viewModel?.getCountries(date: "2018")
            .subscribe(onNext: { (countries) in
                let countryDataFetched: Bool
                if countries.isEmpty{
                    countryDataFetched = false
                } else {
                    countryDataFetched = true
                }
                
                XCTAssertTrue(countryDataFetched)
                expectCountriesFetched.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectCountriesFetched], timeout:0.1)
    }
    
    func testFailToGetCountries(){
        let disposeBag = DisposeBag()
        let networkService = MockNetworkService()
        let mockCountryArray = [Country]()
        let result: ([Country]?, NetworkError) = (mockCountryArray, NetworkError.failure)
        networkService.getCountriesWithGDPResult = result
        viewModel = CountryViewModel.init(networkService: networkService)
        
        let expectCountriesFailToFetch = expectation(description:"Fetched result does not contains countries data")
        viewModel?.getCountries(date: "2018")
            .subscribe(onNext: { (countries) in
                let countryDataFailedToFetch: Bool
                if countries.isEmpty{
                    countryDataFailedToFetch = true
                } else {
                    countryDataFailedToFetch = false
                }
                
                XCTAssertTrue(countryDataFailedToFetch)
                expectCountriesFailToFetch.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectCountriesFailToFetch], timeout:0.1)
    }
    
    func testSuccessfulSortCountriesByName(){
        let networkService = MockNetworkService()
        viewModel = CountryViewModel.init(networkService: networkService)
        
        let mockCountryOne = Country()
        let mockCountryCodeOne = CountryCode()
        mockCountryCodeOne.value = "b"
        mockCountryOne.countryCode = mockCountryCodeOne
        
        let mockCountryTwo = Country()
        let mockCountryCodeTwo = CountryCode()
        mockCountryCodeTwo.value = "c"
        mockCountryTwo.countryCode = mockCountryCodeTwo
        
        let mockCountryThree = Country()
        let mockCountryCodeThree = CountryCode()
        mockCountryCodeThree.value = "a"
        mockCountryThree.countryCode = mockCountryCodeThree
        
        let unsortedCountryArray = [mockCountryOne, mockCountryTwo, mockCountryThree]
        let expectedSortedArray = [mockCountryThree, mockCountryOne, mockCountryTwo]

        let sortedArray = viewModel?.sortCountriesByName(countries: unsortedCountryArray)
        
        if let sortedCountryArray = sortedArray{
            XCTAssertEqual(sortedCountryArray.count, unsortedCountryArray.count, "Sorted and unsorted array should have the same number of elements")
            
            XCTAssertEqual(sortedCountryArray[0].countryCode?.value, expectedSortedArray[0].countryCode?.value, "Sorted and expected sorted array should have the same element order")
            
            XCTAssertEqual(sortedCountryArray[1].countryCode?.value, expectedSortedArray[1].countryCode?.value, "Sorted and expected sorted array should have the same element order")
            
            XCTAssertEqual(sortedCountryArray[2].countryCode?.value, expectedSortedArray[2].countryCode?.value, "Sorted and expected sorted array should have the same element order")
        }
    }
    
    func testSuccessfulSortCountriesByGDP(){
        let networkService = MockNetworkService()
        viewModel = CountryViewModel.init(networkService: networkService)
        
        let mockCountryOne = Country()
        mockCountryOne.value = 20000
        
        let mockCountryTwo = Country()
        mockCountryTwo.value = 30000
        
        let mockCountryThree = Country()
        mockCountryThree.value = 500
        
        let unsortedCountryArray = [mockCountryOne, mockCountryTwo, mockCountryThree]
        let expectedSortedArray = [mockCountryTwo, mockCountryOne, mockCountryThree]
        
        let sortedArray = viewModel?.sortCountriesByGDP(countries: unsortedCountryArray)
        
        if let sortedCountryArray = sortedArray{
            XCTAssertEqual(sortedCountryArray.count, unsortedCountryArray.count, "Sorted and unsorted array should have the same number of elements")
            
            XCTAssertEqual(sortedCountryArray[0].value, expectedSortedArray[0].value, "Sorted and expected sorted array should have the same element order")
            
            XCTAssertEqual(sortedCountryArray[1].value, expectedSortedArray[1].value, "Sorted and expected sorted array should have the same element order")
            
            XCTAssertEqual(sortedCountryArray[2].value, expectedSortedArray[2].value, "Sorted and expected sorted array should have the same element order")
        }
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

