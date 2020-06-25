//
//  DetailsVC.swift
//  Mortgage
//
//  Created by Norlan Tibanear on 6/16/20.
//  Copyright © 2020 Norlan Tibanear. All rights reserved.
//

import UIKit
import Charts
import MessageUI

protocol DetailsVCDelegate {
    func updateView()
}


class DetailsVC: UIViewController {
    
    
    
    // Outlets
    @IBOutlet var graphBGView: UIView!
    @IBOutlet var sliderBGView: UIView!
    @IBOutlet var principalBGView: UIView!
    @IBOutlet var propertyBGView: UIView!
    @IBOutlet var insuranceBGView: UIView!
    @IBOutlet var mortgageBGView: UIView!
    
    
    @IBOutlet var housePriceLabel: UILabel!
    @IBOutlet var creditScoreLabel: UILabel!
    @IBOutlet var downPaymentLabel: UILabel!
    
    @IBOutlet var creditScoreSlider: UISlider!
    @IBOutlet var downPaymentSlider: UISlider!
    
    @IBOutlet var principalInterestLabel: UILabel!
    @IBOutlet var propertyTaxLabel: UILabel!
    @IBOutlet var homeInsuranceLabel: UILabel!
    @IBOutlet var mortgageInsuranceLabel: UILabel!
    
    @IBOutlet var pieChart: PieChartView!
    
    
    // Variables
    var delegate: DetailsVCDelegate?
    
    var houseController = HouseController()
    
    var house: House?
    
    var currentCreditScore: Int = 0
    var currentDownPayment: Int = 0
    
    let currentPrice = 0.0
    
    var rate: Double = 0.0
    
    var houseInsurance: Double = 0.0
    
//    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupSlider()
        updateView()
        saveUserDefaults()
        
        
        
    } // ViewDidLoad
    
    
    func updateView() {
        creditScoreLabel.text = String(currentCreditScore)
        downPaymentLabel.text = convertNumbertoCurrency(amount: Double(currentDownPayment))
    }
    
    func saveUserDefaults() {
        if let downPaymentSavings = UserDefaults.standard.value(forKey: "downPaymentSet") {
            downPaymentSlider.value = downPaymentSavings as! Float
            downPaymentSliderBtn(downPaymentSlider)
        }
        
        if let creditScoreSavings = UserDefaults.standard.value(forKey: "creditScoreSet") {
            creditScoreSlider.value = creditScoreSavings as! Float
            creditScoreSliderBtn(creditScoreSlider)
        }
    }
    
    
    func configureRate() -> Double {
        if currentCreditScore < 900 && currentCreditScore > 850 {
            rate = Double(1.9)
        } else if currentCreditScore < 849 && currentCreditScore > 760 {
            rate = Double(2.9)
        } else if currentCreditScore < 759 && currentCreditScore > 700 {
            rate = Double(3.1)
        } else if currentCreditScore < 699 && currentCreditScore > 680 {
            rate = Double(3.2)
        } else if currentCreditScore < 679 && currentCreditScore > 640 {
            rate = Double(3.5)
        } else if currentCreditScore < 639 && currentCreditScore > 600 {
            rate = Double(3.9)
        } else if currentCreditScore < 599 && currentCreditScore > 560 {
            rate = Double(4.2)
        } else if currentCreditScore < 559 && currentCreditScore > 500 {
            rate = Double(4.5)
        } else if currentCreditScore < 499 && currentCreditScore > 440 {
            rate = Double(5.8)
        } else if currentCreditScore < 439 && currentCreditScore > 350 {
            rate = Double(7.2)
        }
        print(rate)
        return rate
    } //
    
    
    // Insurance Value base on house cost
    func homeInsurance() -> Double {
        guard let houseValue = house?.priceName else { return 00.00 }
        
        if houseValue <= 200000.00 {
            houseInsurance = 45.00
        } else if houseValue >= 200001.00 && houseValue <= 400000.00 {
            houseInsurance = 90.00
        } else if houseValue >= 400001.00 && houseValue <= 600000.00 {
            houseInsurance = 132.00
        } else if houseValue >= 600001.00 && houseValue <= 800000.00 {
            houseInsurance = 175.00
        } else if houseValue >= 800001.00 && houseValue <= 1000000.00 {
            houseInsurance = 215.00
        }
        return houseInsurance
    } //
    
    
    @IBAction func creditScoreSliderBtn(_ slider: UISlider) {
        let roundedValue = slider.value.rounded()
        currentCreditScore = Int(roundedValue)
        
        UserDefaults.standard.set(slider.value, forKey: "creditScoreSet")
        
        updateView()
    }
    
    @IBAction func downPaymentSliderBtn(_ slider: UISlider) {
        let roundedDownValue = slider.value.rounded()
        currentDownPayment = Int(roundedDownValue)
        
        UserDefaults.standard.set(slider.value, forKey: "downPaymentSet")
        
        updateView()
    }
    
    
    @IBAction func calculateBtn(_ sender: UIButton) {
        guard let house = house else { return }

        if currentCreditScore == 0 {
            let title = "Incomplete Form"
            let message = "Please enter your Credit Score to calculate"
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
        } else {
            
            let homeTax = 1.08
            let currentRate = configureRate()
            let currentLoan = (house.priceName)
            let currentDown = Double(currentDownPayment)
            
            let basicTotal = houseController.calculatePrincipal(loanAmount: currentLoan, downPayment: currentDown)
            print("El nuevo Basic Total \(basicTotal)")
            let interestRate = houseController.calculateInterest(loanAmount: currentLoan, rateAmount: currentRate)
            
            let principalValue = Double(basicTotal) + Double(interestRate)
            principalInterestLabel.text = convertNumbertoCurrency(amount: principalValue)
            
            mortgageInsuranceLabel.text = String(rate)
            
            let houseTaxValue = houseController.calculateTax(loanAmount: currentLoan, propertyTax: homeTax)
            propertyTaxLabel.text = convertNumbertoCurrency(amount: houseTaxValue)
            
            let homeIns = homeInsurance()
            homeInsuranceLabel.text = convertNumbertoCurrency(amount: homeIns)
            
            let monthTotal = houseController.calculateMonthPayment(principal: principalValue, homeTax: houseTaxValue, homeInsurance: homeIns)
            housePriceLabel.text = convertNumbertoCurrency(amount: monthTotal)

            
            setupChart(principalTotal: principalValue, houseTax: houseTaxValue, homeIns: homeIns, interestRate: interestRate)

        }
    } //
    
    
    // Setup Charts
    func setupChart(principalTotal: Double, houseTax: Double, homeIns: Double, interestRate: Double) {
        pieChart.drawHoleEnabled = true
        pieChart.drawEntryLabelsEnabled = false
        
        var entries: [PieChartDataEntry] = Array()
        entries.append(PieChartDataEntry(value: principalTotal, label: "Principal & Interest"))
        entries.append(PieChartDataEntry(value: houseTax, label: "Tax"))
        entries.append(PieChartDataEntry(value: homeIns, label: "Insurance"))
        entries.append(PieChartDataEntry(value: interestRate, label: "Rate"))
        
        let dataSet = PieChartDataSet(entries: entries)
        
        let c1 = UIColor.systemGreen
        let c2 = UIColor.systemPink
        let c3 = UIColor.systemYellow
        let c4 = UIColor.systemTeal
        
        dataSet.colors = [c1, c2, c3, c4]
        dataSet.drawValuesEnabled = false
        
        pieChart.data = PieChartData(dataSet: dataSet)
        
    } //
    
    
    // Converting the number into currency
    func convertNumbertoCurrency(amount: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        return numberFormatter.string(from: NSNumber(value: amount))!
    } //
    
    
    @IBAction func makeAppointmentBtn(_ sender: UIButton) {
        
        let emailL = "ntibanear@gmail.com"
        
        guard MFMailComposeViewController.canSendMail() else {
            // Alert
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients([emailL])
        composer.setSubject("I'm interested in one of your houses")
        composer.setMessageBody("I would like to make an appointment. \nI'm interested in the house from \(house?.cityName ?? "") with a value of \(house?.priceName ?? 0)", isHTML: false)
        
        present(composer, animated: true)

    } //
    
    
    func setupSlider() {
        let thumImageNormal = UIImage(named: "SliderThumb-Normal")
        creditScoreSlider.setThumbImage(thumImageNormal, for: .normal)
        
        let thumbImageHighlighted = UIImage(named: "SliderThumb-Highlighted")
        creditScoreSlider.setThumbImage(thumbImageHighlighted, for: .highlighted)
        
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        
        let trackLeftImage = UIImage(named: "SliderTrackLeft")
        let trackLeftResizeble = trackLeftImage?.resizableImage(withCapInsets: insets)
        creditScoreSlider.setMinimumTrackImage(trackLeftResizeble, for: .normal)
        
        let trackRightImage = UIImage(named: "SliderTrackRight")
        let trackRightResizeble = trackRightImage?.resizableImage(withCapInsets: insets)
        creditScoreSlider.setMaximumTrackImage(trackRightResizeble, for: .normal)
        
        let thumImageDown = UIImage(named: "SliderThumb-Normal")
        downPaymentSlider.setThumbImage(thumImageDown, for: .normal)
        
        let thumbImageHighlightedDown = UIImage(named: "SliderThumb-Highlighted")
        downPaymentSlider.setThumbImage(thumbImageHighlightedDown, for: .highlighted)
        
        let insetsDown = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        
        let trackLeftImageDown = UIImage(named: "SliderTrackLeft")
        let trackLeftResizebleDown = trackLeftImageDown?.resizableImage(withCapInsets: insetsDown)
        downPaymentSlider.setMinimumTrackImage(trackLeftResizebleDown, for: .normal)
        
        let trackRightImageDown = UIImage(named: "SliderTrackRight")
        let trackRightResizebleDown = trackRightImageDown?.resizableImage(withCapInsets: insetsDown)
        downPaymentSlider.setMaximumTrackImage(trackRightResizebleDown, for: .normal)
    } //
    
    

} // END

extension DetailsVC: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            controller.dismiss(animated: true)
            return
        }
        
        switch result {
        case .cancelled:
            print("Cancelled")
        case .failed:
            print("Failed to send")
        case .saved:
            print("Saved")
        case .sent:
            print("Email Sent")
        default:
            print("Nothing")
        }
        controller.dismiss(animated: true)
    }
    
} //
