//
//  HouseController.swift
//  Mortgage
//
//  Created by Norlan Tibanear on 6/16/20.
//  Copyright © 2020 Norlan Tibanear. All rights reserved.
//

import Foundation

class HouseController {
    
    var houses: [House] = {
        [
            House(cityName: "Fort Lauderdale", stateName: "Florida", priceName: 356489, bedName: 3, bathName: 2, garageName: 2, introName: "Desirable Coral Ridge Neighborhood in Bayview School District! Well-maintained Mid-Century Modern, multi-level home, designed by South Florida architect, Charles McKirahan, features 3BDRM, 2.5BA situated on a beautiful berm lot.", addressName: "2408 NE 26th Ter Fort Lauderdale, FL 33305", imageString: "houseOne"),
            House(cityName: "Fort Lauderdale", stateName: "Florida", priceName: 845359, bedName: 5, bathName: 3, garageName: 2, introName: "Beautiful waterfront vacant lot with direct views to the intracoastal. The lot has 100 feet of canal front with no fixed bridges making this perfect for the boat lovers. ", addressName: "2825 NE 27th St Fort Lauderdale, FL 33306", imageString: "houseTwo"),
            House(cityName: "Fort Lauderdale", stateName: "Florida", priceName: 647215, bedName: 4, bathName: 3, garageName: 2, introName: "A truly spectacular waterfront residence, tucked away in an upscale enclave! With Mediterranean elegance and luxury amenities, this architectural gem features the best in South Florida living.", addressName: "3031 NE 23rd Ct Fort Lauderdale, FL 33305", imageString: "houseThree"),
            House(cityName: "Fort Lauderdale", stateName: "Florida", priceName: 751238, bedName: 4, bathName: 3, garageName: 2, introName: "This large, modern and luxurious 4 bedroom 4.5 bathroom three-story townhome includes a very spacious rooftop terrace offering amazing ocean and waterway views.", addressName: "236 Shore Ct Lauderdale By The Sea, FL 33308", imageString: "houseFour"),
            House(cityName: "West Palm", stateName: "Florida", priceName: 598456, bedName: 4, bathName: 3, garageName: 2, introName: "Beautiful move in ready home in Bel Air’s beachside community…Spacious 3 bedroom 3 bath home was completely redone in 2018.", addressName: "1972 Coco Palm Pl Pompano Beach, FL 33062", imageString: "houseFive"),
            House(cityName: "West Palm", stateName: "Florida", priceName: 852794, bedName: 5, bathName: 4, garageName: 3, introName: "Welcome Home! Pool home is perfect for entertaining or a private and easygoing lifestyle. Updated flooring, bathroom, kitchen and led lighting throughout.", addressName: "6571 NE 21st Way Fort Lauderdale, FL 33308", imageString: "houseSix")
        ]
    }()
    
    init() {
        loadHouseFromPersistenceStore()
    }
    
    
    // Persistence
    var housePersistenceURL: URL? {
        let fm = FileManager.default
        guard let dir = fm.urls(for: .documentDirectory, in: .allDomainsMask).first else { return nil }
        return dir.appendingPathComponent("housePersistence.plist")
    } //
    
    // Save to Persistence Store
    func saveHouseToPersistenceStore() {
        guard let url = housePersistenceURL else { return }
 
        do {
            let houseData = PropertyListEncoder()
            let data = try houseData.encode(houses)
            try data.write(to: url)
        } catch {
            print("No data was save")
        }
    } //
    
    // Loading House from Persistence Store
    func loadHouseFromPersistenceStore() {
        let fm = FileManager.default
        guard let url = housePersistenceURL, fm.fileExists(atPath: url.path) else { return }
       
        do {
            let data = try Data(contentsOf: url)
            let decode = PropertyListDecoder()
            let decodeHouses = try decode.decode([House].self, from: data)
            houses = decodeHouses
        } catch {
            print("Data was not loaded")
        }
        
        
    } //
    
    
    
//    var currentCreditScore: Double = 0.0
//    var rate: Double = 0.0
//
//    func configureRate(amount: Int) -> Double {
//        if currentCreditScore < 900 && currentCreditScore > 850 {
//            self.rate = Double(1.9)
//        } else if currentCreditScore < 849 && currentCreditScore > 760 {
//            self.rate = Double(2.9)
//        } else if currentCreditScore < 759 && currentCreditScore > 700 {
//            self.rate = Double(3.1)
//        } else if currentCreditScore < 699 && currentCreditScore > 680 {
//            self.rate = Double(3.2)
//        } else if currentCreditScore < 679 && currentCreditScore > 640 {
//            self.rate = Double(3.5)
//        } else if currentCreditScore < 639 && currentCreditScore > 600 {
//            self.rate = Double(3.9)
//        } else if currentCreditScore < 599 && currentCreditScore > 560 {
//            self.rate = Double(4.2)
//        } else if currentCreditScore < 559 && currentCreditScore > 500 {
//            self.rate = Double(4.5)
//        } else if currentCreditScore < 499 && currentCreditScore > 440 {
//            self.rate = Double(5.8)
//        } else if currentCreditScore < 439 && currentCreditScore > 350 {
//            self.rate = Double(7.2)
//        }
//        return rate
//    } //
    
    
    
    func propertyTax(price: Double) -> Double {
        
        let taxValue = price * 1.08 / 100
        let propertyTax = taxValue / 12
        let totalTax = propertyTax.rounded()
        saveHouseToPersistenceStore()
        return totalTax
    }
    
    
    func calculatePrincipal(loanAmount: Double, downPayment: Double) -> Double {

        let basicPrincipal = loanAmount - downPayment
        let monthPayment = basicPrincipal / 360
        let paymentTotal = monthPayment.rounded()
        saveHouseToPersistenceStore()
        return paymentTotal
    }
    
    
    func calculateInterest(loanAmount: Double, rateAmount: Double) -> Double {
        
        let basicInterest = loanAmount * (rateAmount / 100.0)
        let monthInterest = basicInterest / 360
        let totalInterest = monthInterest.rounded()
        saveHouseToPersistenceStore()
        return totalInterest
    }
    
    
    func calculateTax(loanAmount: Double, propertyTax: Double) -> Double {
        
        let homeTax = loanAmount * (propertyTax / 100.0)
        let anualTax = homeTax / 12
        let tax = anualTax.rounded()
        saveHouseToPersistenceStore()
        return tax
    }
    
    func calculateMonthPayment(principal: Double, homeTax: Double, homeInsurance: Double) -> Double {
        
        let monthTotal = principal + homeTax + homeInsurance
        let total = monthTotal.rounded()
        saveHouseToPersistenceStore()
        return total
    }
    
    
    
} //
