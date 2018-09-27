//
//  EntryList.swift
//  TravelBros
//
//  Created by Edvard Hedlund on 2018-09-27.
//  Copyright © 2018 Edvard Hedlund. All rights reserved.
//

//
//  ViewController.swift
//  RestaurangGuiden
//
//  Created by Sten R Kaiser on 2018-08-24.
//  Copyright © 2018 Kaiser&Kaiser. All rights reserved.
//

import UIKit

class EntryList: UIViewController, UITableViewDelegate, UITableViewDataSource, DataDelegate {
    
    
    //    func updateSearchResults(for searchController: UISearchController){
    //        if let searchController.searchBar.text {
    //            restData.searchArray = restData.restaurantArray.filter {$0.name == search}
    //
    //
    //        }
    //    }
    
    
    
    //    var restData = RestaurantDataFB()
    var restData = RestaurantDataSQL()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var restaurantTable: UITableView!
    @IBOutlet weak var loadActivity: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restData.loadDB()
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
        return restData.restaurantArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestCell", for: indexPath) as! RestaurantCell
        let row = indexPath.row
        let restCell = restData.restaurantArray[row]
        cell.restLabel.text = restCell.name
        cell.restImage.image = restCell.thumb
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        performSegue(withIdentifier: "showRestPage", sender: row)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestPage" {
            if let restPage = segue.destination as? RestaurantPage {
                if let indx = sender as? Int {
                    let newRest = restData.restaurantArray[indx]
                    restPage.restaurantID = newRest.id
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

