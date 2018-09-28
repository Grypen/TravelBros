//
//  EntryNew.swift
//  TravelBros
//
//  Created by Peter on 27.09.2018.
//  Copyright © 2018 Edvard Hedlund. All rights reserved.
//

import UIKit

class EntryNew: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
   @IBOutlet weak var textDatePick: UITextField!
    @IBOutlet weak var textAddress: UITextField!

    @IBOutlet weak var entryEntry: UITextField!

    @IBOutlet weak var entryImage: UIImageView!
    
    let entryData = TravelBrosSQL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func saveData(){
        entryData.oneEntry.date = textDatePick.text ?? ""
        entryData.oneEntry.address = textAddress.text ?? ""
        entryData.oneEntry.entry = entryEntry.text ?? ""

        if entryImage.image != nil{
            entryData.oneEntry.img = entryImage.image
        }
    
        entryData.uploadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        entryImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
    //öppnar gallery
    @IBAction func nyBild(_ sender: UIButton){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if sender.tag == 1 {imagePicker.sourceType = .camera}
        else if sender.tag == 2{imagePicker.sourceType = .photoLibrary}
        self.present(imagePicker, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
