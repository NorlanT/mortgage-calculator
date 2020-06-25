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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.backgroundColor = UIColor.systemGray4
    }
    

} // END


extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houseController.houses.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomesCell", for: indexPath) as? HomesTableViewCell else { return UITableViewCell() }

        let house = houseController.houses[indexPath.row]
        cell.house = house
        
        cell.backgroundColor = UIColor.lightGray
        
        return cell
    }
    
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
