//
//  EntryPage.swift
//  TravelBros
//
//  Created by Edvard Hedlund on 2018-09-27.
//  Copyright © 2018 Edvard Hedlund. All rights reserved.
//

import UIKit

class EntryPage: UIViewController {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
   
    @IBOutlet weak var entryImage: UIImageView!
    @IBOutlet weak var entryText: UITextView!
    
    
    var entryID = ""
    
     let entryData = TravelBrosSQL()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entryData.loadOne(entryId: entryID)
        setEntryData()
    }
    
    //tar infon från entry data och databasen och lägger upp den i sidan
    func setEntryData(){
        dateLabel.text = entryData.oneEntry.date
        entryText.text = entryData.oneEntry.entry
        addressLabel.text = entryData.oneEntry.address
        
        entryImage.image = entryData.oneEntry.img
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
