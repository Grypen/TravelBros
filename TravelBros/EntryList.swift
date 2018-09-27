//
//  EntryList.swift
//  TravelBros
//
//  Created by Edvard Hedlund on 2018-09-27.
//  Copyright © 2018 Edvard Hedlund. All rights reserved.
//

import UIKit

class EntryList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var entryData = RestaurantDataSQL()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var restaurantTable: UITableView!
    @IBOutlet weak var loadActivity: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entryData.loadDB()
        loadActivity.isHidden = true
        //        restData.dataDel = self  // Firebase
        
        //        searchController.searchResultsUpdater = self
        //        searchController.searchBar.placeholder = "Sök namn"
        //        searchController.searchBar.sizeToFit()
        //        searchController.dimsBackgroundDuringPresentation = false
        //        restaurantTable.tableHeaderView = searchController.searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        restData.restaurantArray.removeAll()
        //        restData.loadDB()
        //        restaurantTable.reloadData()
    }
    
    func laddaTabell() {
        restaurantTable.reloadData()
        loadActivity.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryData.entryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath) as! RestaurantCell
        let row = indexPath.row
        let entryCell = entryData.entryArray[row]
        cell.restLabel.text = entryCell.name
        cell.restImage.image = entryCell.thumb
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        performSegue(withIdentifier: "showRestPage", sender: row)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestPage" {
            if let entryPage = segue.destination as? RestaurantPage {
                if let indx = sender as? Int {
                    let newEntry = entryData.entryArray[indx]
                    entryPage.restaurantID = newEntry.id
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
