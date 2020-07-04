//
//  HomesTableViewCell.swift
//  Mortgage
//
//  Created by Norlan Tibanear on 6/16/20.
//  Copyright © 2020 Norlan Tibanear. All rights reserved.
//

import UIKit

protocol HomesTableViewCellDelegate2 {
    func updateView()
}

class HomesTableViewCell: UITableViewCell {
    
    // Outlets
    @IBOutlet var backgroundPhoto: UIView!
    @IBOutlet var photoView: UIImageView!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var stateLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!

    @IBOutlet var favoriteButton: UIButton!
    
    var delegate: HomesTableViewCellDelegates?
    
    var houseController = HouseController()
    
    var house: House? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        guard let house = house else { return }
        
        cityLabel.text = house.cityName
        stateLabel.text = house.stateName
        priceLabel.text = convertNumbertoCurrency(amount: house.priceName)
        photoView.image = house.image
        
        if house.favorite == true {
            favoriteButton.setBackgroundImage(UIImage(named: "starColor"), for: .normal)
        } else {
            favoriteButton.setBackgroundImage(UIImage(named: "starGrey"), for: .normal)
        }
    }
    
    
    @IBAction func favoriteBtn(_ sender: UIButton) {
        delegate?.toggleIsFavorite(for: self)
    }
    
    
    
    
    // Converting the number into currency
    func convertNumbertoCurrency(amount: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundPhoto.layer.cornerRadius = 8
        backgroundPhoto.clipsToBounds = true
        
        photoView.layer.cornerRadius = 8
        photoView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

} // END
