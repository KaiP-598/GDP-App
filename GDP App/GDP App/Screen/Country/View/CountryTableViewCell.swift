//
//  CountryTableViewCell.swift
//  GDP App
//
//  Created by Kaipeng Wu on 27/10/19.
//  Copyright © 2019 Kaipeng Wu. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryIsoCodeLabel: UILabel!
    @IBOutlet weak var countryGDPLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCell(country: Country){
        countryNameLabel.text = country.countryCode?.value
        countryIsoCodeLabel.text = country.countryiso3code
        
        let GDPValue: String
        
        if let GDP = country.value {
            GDPValue = String(GDP)
        } else {
            GDPValue = "--"
        }
        
        countryGDPLabel.text = "USD: $" + GDPValue
    }
    
}
