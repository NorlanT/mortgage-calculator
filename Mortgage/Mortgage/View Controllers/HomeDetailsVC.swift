//
//  HomeDetailsVC.swift
//  Mortgage
//
//  Created by Norlan Tibanear on 6/24/20.
//  Copyright © 2020 Norlan Tibanear. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol HomeDetailsVCDelegate {
    func configureView()
}


class HomeDetailsVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // Outlets
    @IBOutlet var photoViewBackground: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var housePriceLabe: UILabel!
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var bedNameLabel: UILabel!
    @IBOutlet var bathNameLabel: UILabel!
    @IBOutlet var garageNameLabel: UILabel!
    @IBOutlet var introNameLabel: UITextView!
    
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var calculateButton: UIButton!
    
    @IBOutlet var mapView: MKMapView!
    
    
    // Variables
    var houseController = HouseController()
    var house: House?
    
    var delegate: HomeDetailsVCDelegate?
    
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
        
        
        favoriteButton.layer.cornerRadius = 8
        favoriteButton.clipsToBounds = true

        configureView()
  
        
    }
    

    
    
    
    func configureView() {
        guard let house = house else { return }
        
        housePriceLabe.text = convertNumbertoCurrency(amount: house.priceName)
        cityNameLabel.text = house.cityName
        bedNameLabel.text = String(house.bedName)
        bathNameLabel.text = String(house.bathName)
        garageNameLabel.text = String(house.garageName)
        introNameLabel.text = house.introName
        
        imageView.image = house.image
        
        
    }
    
    // Converting the number into currency
    func convertNumbertoCurrency(amount: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailsVC" {
            guard let detsVC = segue.destination as? DetailsVC else { return }
            detsVC.houseController = houseController
            detsVC.house = house
            detsVC.delegate = self
        }
    }
    
    
    @IBAction func gpsButton(_ sender: UIButton) {
        
        guard let house = house else { return }
        
        let addressL = house.addressName
        print("New Address \(addressL)")
        
        self.reverseGeocode(address: addressL, completion: { (placemark) in
            
            let destinationPlacemark = MKPlacemark(coordinate: (placemark.location?.coordinate)!)
            
            let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
            
            MKMapItem.openMaps(with: [destinationMapItem], launchOptions: nil)
        })
        
    }
    

    
    private func reverseGeocode(address: String, completion: @escaping(CLPlacemark) -> ()) {
        
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let placemarks = placemarks,
                let placemark = placemarks.first else {
                    return
            }
            
            completion(placemark)
        }
    }
    
    // Coordinates
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008))
        
        mapView.setRegion(region, animated: true)
    }
    
    
 

} // END

extension HomeDetailsVC: DetailsVCDelegate {
    func updateView() {
    }
}
