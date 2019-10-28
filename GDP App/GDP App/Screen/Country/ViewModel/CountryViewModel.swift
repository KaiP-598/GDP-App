//
//  GDPListViewModel.swift
//  
//
//  Created by Kaipeng Wu on 27/10/19.
//

import Foundation
import RxSwift

enum SortType: Int{
    case byName = 0
    case byGDP = 1
}

protocol CountryViewModeling {
    
    var currentYearSelected: PublishSubject<String> {get}
    var countries: PublishSubject<[Country]> {get}
    var currentTabIndex: PublishSubject<SortType> {get}
    var currentSortType: SortType {get}
    
    func getCountries(date: String) -> Observable<[Country]>
    func sortCountriesByName(countries: [Country]) -> [Country]
    func sortCountriesByGDP(countries: [Country]) -> [Country]
    
}

class CountryViewModel: CountryViewModeling{
    
    var currentYearSelected: PublishSubject<String> = PublishSubject<String>()
    var countries: PublishSubject<[Country]> = PublishSubject<[Country]>()
    var currentTabIndex: PublishSubject<SortType> = PublishSubject<SortType>()
    var currentSortType: SortType = .byName
    var allCountries:[Country]?
    
    
    let networkService: NetworkServicing
    
    
    private let disposeBag = DisposeBag()
    
    init(networkService: NetworkServicing){
        self.networkService = networkService
        
        self.currentYearSelected
            .flatMapLatest { [weak self] (year) -> Observable<[Country]> in
                //get coutries data using the updated year
                return self?.getCountries(date: year) ?? Observable.just([Country]())
            }
            .subscribe(onNext: { [weak self] (countries) in
                self?.allCountries = countries
                //sort the countries data using the previous order
                //otherwise use the default one - Sort By Name
                self?.currentTabIndex.onNext(self?.currentSortType ?? SortType.byName)
            })
            .disposed(by: disposeBag)
        
        currentTabIndex
            .subscribe(onNext: { [weak self] (sortType) in
                self?.currentSortType = sortType
                if let allCountries = self?.allCountries{
                    switch sortType{
                    case .byName:
                        self?.countries.onNext(self?.sortCountriesByName(countries: allCountries) ?? [Country]())
                        break
                    case .byGDP:
                        self?.countries.onNext(self?.sortCountriesByGDP(countries: allCountries) ?? [Country]())
                        break
                    }
                    
                }
            })
            .disposed(by: disposeBag)
    }
    
    func getCountries(date: String) -> Observable<[Country]>{
        //Create an observable of country array here
        return Observable.create { [weak self] observer in
            self?.networkService.getCountriesWithGDP(date: date, completionHandler: { (countryArray, result) in
                switch result{
                case .failure:
                    debugPrint("There is an error when getting country data")
                    observer.onNext([Country]())
                case .success:
                    if let countries = countryArray {
                        observer.onNext(countries)
                    } else {
                        observer.onNext([Country]())
                    }
                }
            })
            
            return Disposables.create {
            }
        }
    }
    
    func sortCountriesByName(countries: [Country]) -> [Country]{
        let sortedCountries = countries.sorted { (firstCountry, secondCountry) -> Bool in
            if let firstName = firstCountry.countryCode?.value{
                if let secondName = secondCountry.countryCode?.value{
                    return firstName < secondName
                } else {
                    return false
                }
            } else {
                return false
            }
        }
        
        return sortedCountries
    }
    
    func sortCountriesByGDP(countries: [Country]) -> [Country]{
        let sortedCountries = countries.sorted { (firstCountry, secondCountry) -> Bool in
            if let firstCountryGDP = firstCountry.value{
                if let secondSecondGDP = secondCountry.value{
                    return firstCountryGDP > secondSecondGDP
                } else {
                    return false
                }
            } else {
                return false
            }
        }
        
        return sortedCountries
    }
    
}

