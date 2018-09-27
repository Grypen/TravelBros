//
//  EntryNew.swift
//  TravelBros
//
//  Created by Peter on 27.09.2018.
//  Copyright © 2018 Edvard Hedlund. All rights reserved.
//

import UIKit

class NewEntry: UITableViewController{
    
    @IBOutlet weak var datePick: UITextField!
    
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(NewEntry.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewEntry.viewTapped(gestureRecognizer:)))
        
        datePick.inputView = datePicker
    }
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        datePick.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
}
