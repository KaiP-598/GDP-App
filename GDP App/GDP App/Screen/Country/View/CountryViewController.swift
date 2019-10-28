//
//  ViewController.swift
//  GDP App
//
//  Created by Kaipeng Wu on 27/10/19.
//  Copyright © 2019 Kaipeng Wu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CountryViewController: UIViewController {
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var yearSlider: UISlider!
    @IBOutlet weak var segmentedControlContainerView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    
    var viewModel: CountryViewModeling?
    let buttonBar = UIView()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupSegmentedControl()
        setupBinding()
    }
    
    func setupView(){
        super.title = "Country List"
        
        tableView.register(UINib(nibName: "CountryTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CountryTableViewCell")
        
        tableView.delegate = self
        
    }
    
    //Setup the view for Segmented Control
    func setupSegmentedControl(){
        segmentedControl.backgroundColor = .clear
        segmentedControl.tintColor = .clear
        
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "DINCondensed-Bold", size: 18) as Any,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ], for: .normal)
        
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "DINCondensed-Bold", size: 18) as Any,
            NSAttributedString.Key.foregroundColor: UIColor.darkGray
            ], for: .selected)
        
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = UIColor.darkGray
        segmentedControlContainerView.addSubview(buttonBar)
        buttonBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
        buttonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
        buttonBar.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor).isActive = true
        buttonBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
    }
    
    func setupBinding(){
        viewModel = CountryViewModel.init(networkService: NetworkService())
        
        //Bind country array observable to tableview
        viewModel?.countries.asObservable().bind(to: tableView.rx.items(cellIdentifier: "CountryTableViewCell", cellType: CountryTableViewCell.self)) { row, country, cell in
            cell.configureCell(country: country)
            }.disposed(by: disposeBag)
        
        //Set the initial default year to 2018
        updateDataByYear(year: 2018)

    }
    
    func updateDataByYear(year: Int){
        yearLabel.text = "Year: " + String(year)
        viewModel?.currentYearSelected.onNext(String(year))
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.3) {
            self.buttonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
        }
        
        let index = sender.selectedSegmentIndex
        viewModel?.currentTabIndex.onNext(SortType(rawValue: index) ?? SortType.byName)
    }
    
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        updateDataByYear(year: Int(sender.value))
    }
    

}

extension CountryViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

