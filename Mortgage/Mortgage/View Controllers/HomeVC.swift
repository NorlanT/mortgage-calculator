//
//  HomeVC.swift
//  Mortgage
//
//  Created by Norlan Tibanear on 6/16/20.
//  Copyright © 2020 Norlan Tibanear. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    // Outlets
    @IBOutlet var tableView: UITableView!
    
    
    // Variables
    var houseController = HouseController()
    var house: House?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        tableView.reloadData()
    }
    

} // END


extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return houseController.isFavoriteHouse.count
        } else {
            return houseController.unFavoriteHouse.count
        }
    } //
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            let view = UIView()
            view.backgroundColor = UIColor.orange
            
            let image = UIImageView(image: UIImage(named: "houseIconGray"))
            image.frame = CGRect(x: 15, y: 5, width: 30, height: 30)
            view.addSubview(image)
            
            let label = UILabel()
            label.text = "Favorites"
            label.frame = CGRect(x: 60, y: 5, width: 100, height: 35)
            label.font = UIFont(name: "Arial", size: 24)
            view.addSubview(label)
            
            return view
        }
        
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        
        let image = UIImageView(image: UIImage(named: "houseIconWhite"))
        image.frame = CGRect(x: 15, y: 5, width: 30, height: 30)
        view.addSubview(image)
        
        let label = UILabel()
        label.text = "Houses"
        label.frame = CGRect(x: 60, y: 5, width: 100, height: 35)
        label.font = UIFont(name: "Arial", size: 24)
        label.textColor = UIColor.white
        view.addSubview(label)
        
        return view
        
    } //
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    } //
    
    
    func houseFor(indexPath : IndexPath) -> House {
        if indexPath.section == 0 {
            return houseController.isFavoriteHouse[indexPath.row]
        } else {
            return houseController.unFavoriteHouse[indexPath.row]
        }
    } //
    
    
    func toggleIsFavorite(for cell: HomesTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        houseController.updateFavorite(for: houseFor(indexPath: indexPath))
        tableView.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomesCell", for: indexPath) as? HomesTableViewCell else { return UITableViewCell() }

        cell.delegate = self
        
        let house = houseFor(indexPath: indexPath)
        cell.house = house
        cell.backgroundColor = UIColor.lightGray
        
        return cell
    } //
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHomeDetailsVC" {
            guard let detsVC = segue.destination as? HomeDetailsVC,
                let indexPath = tableView.indexPathsForSelectedRows?.first else { return }
            detsVC.houseController = houseController
            detsVC.house = houseController.houses[indexPath.row]
        }
    }
    
} //


extension HomeVC: HomeDetailsVCDelegate {
    func configureView() {
    }
}

extension HomeVC: HomesTableViewCellDelegates {
    
}

extension HomeVC: HomesTableViewCellDelegate2 {
    func updateView() {
    }
}
