//
//  EntryList.swift
//  TravelBros
//
//  Created by Edvard Hedlund on 2018-09-27.
//  Copyright © 2018 Edvard Hedlund. All rights reserved.
//

import UIKit

class EntryList: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchControllerDelegate {
    
    
    
    
    var entryData = TravelBrosSQL()
    
    let searchController = UISearchController(searchResultsController: nil)

    
    @IBOutlet weak var entriesTable: UITableView!
    @IBOutlet weak var loadActivity: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entryData.loadDB()
      loadActivity.isHidden = true
        //        restData.dataDel = self  // Firebase
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Sök namn"
        searchController.searchBar.sizeToFit()
        searchController.dimsBackgroundDuringPresentation = false
        entriesTable.tableHeaderView = searchController.searchBar
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        restData.restaurantArray.removeAll()
        //        restData.loadDB()
                entriesTable.reloadData()
    }
    
    func laddaTabell() {
        entriesTable.reloadData()
        loadActivity.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return entryData.searchArray.count
        } else {
            return entryData.entryArray.count
        }
//        return entryData.entryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryID", for: indexPath) as! EntryCell
        let row = indexPath.row
        var entryCell = entryData.entryArray[row]
        if searchController.isActive {
            entryCell = entryData.searchArray[row]
        }
        cell.entryLabel.text = entryCell.date
//        print(entryData.entryArray[row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        performSegue(withIdentifier: "TravelBroItemShowDetails", sender: row)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let search = searchController.searchBar.text {
            entryData.searchArray = entryData.entryArray.filter {$0.date == search }
            entriesTable.reloadData()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TravelBroItemShowDetails" {
            if let entryPage = segue.destination as? EntryPage {
                if let indx = sender as? Int {
                    var newEntry = entryData.entryArray[indx]
                    if searchController.isActive {
                        newEntry = entryData.searchArray[indx]
                    }
                    entryPage.entryID = newEntry.id
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

