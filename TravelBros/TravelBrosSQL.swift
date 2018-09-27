//
//  TravelBrosSQL.swift
//  TravelBros
//
//  Created by Edvard Hedlund on 2018-09-27.
//  Copyright © 2018 Edvard Hedlund. All rights reserved.
//

import UIKit

class TravelBrosSQL {
    
    struct Entry {
        var id = ""
        var date = ""
//        var imgUrl = ""
        var img:UIImage?
        var address = ""
        var entry = ""
    }
    
    var entryArray:[Entry] = []
    var oneEntry = Entry()
    var dbPath = ""
    
    init() {
        let docPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        dbPath = docPath[0].appendingPathComponent("travelbrosDB.db").path
        
        if !FileManager.default.fileExists(atPath: dbPath) {
            if let bundlePath = Bundle.main.resourceURL?.appendingPathComponent("travelbrosDB.db").path {
                do {
                    try FileManager.default.copyItem(atPath: bundlePath, toPath: dbPath)
                    print("Databas kopierad till : \(dbPath)")
                } catch {
                    print("Kan inte kopiera, Error:",error)
                }
            }
        } else {
            print("Databas finns: \(dbPath)")
        }
    }
    
    //laddar ner databasen
    func loadDB() {
        let database = FMDatabase(path: dbPath)
        if database.open() {
            do {
                let resSet = try database.executeQuery("SELECT * from entries", values: nil)
                while resSet.next() {
                    var newEntry = Entry()
                    newEntry.id = resSet.string(forColumn:"id") ?? ""
                    newEntry.date = resSet.string(forColumn:"date") ?? ""
//                    if let imgData = resSet.data(forColumn:"thumb") {
//                        newEntry.thumb = UIImage(data:imgData)
//                    }
                    entryArray.append(newEntry)
                }
            }catch{
                print(error)
            }
            database.close()
            
        }
    }
    
    //laddar upp ett inlägg för EntryPage
    func loadOne(entryId:String) {
        let database = FMDatabase(path: dbPath)
        if database.open() {
            do {
                let resSet = try database.executeQuery("SELECT * from entries WHERE id=?", values: [entryId])
                while resSet.next() {
                    self.oneEntry.date = resSet.string(forColumn:"date") ?? ""
                     self.oneEntry.entry = resSet.string(forColumn:"entry") ?? ""
                    self.oneEntry.address = resSet.string(forColumn:"address") ?? ""
                   
                    if let imgData = resSet.data(forColumn:"img") {
                        self.oneEntry.img = UIImage(data:imgData)
                    }
                }
            }catch{
                print(error)
            }
            database.close()
        }
    }
    
    
    //Laddar upp till data basen
    func uploadData() {
        var imgJpeg:Data?
        if let image = oneEntry.img {
            UIGraphicsBeginImageContext(CGSize(width: 800, height: 475))
            var ratio = Double(image.size.width/image.size.height)
            var scaleWidth = 800.0
            var scaleHeight = 800.0/ratio
            var offsetX = 0.0
            var offsetY = (scaleHeight-475)/2.0
            image.draw(in: CGRect(x: -offsetX, y: -offsetY, width: scaleWidth, height: scaleHeight))
            let largeImg = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let largeImg = largeImg, let jpegData = largeImg.jpegData(compressionQuality: 0.7) {
                imgJpeg = jpegData
            }
            UIGraphicsEndImageContext()
            
//            UIGraphicsBeginImageContext(CGSize(width: 80, height: 80))
//            ratio = Double(image.size.width/image.size.height)
//            scaleWidth = ratio*80.0
//            scaleHeight = 80.0
//            offsetX = (scaleWidth-80)/2.0
//            offsetY = 0.0
//            image.draw(in: CGRect(x: -offsetX, y: -offsetY, width: scaleWidth, height: scaleHeight))
//            if let largeImg = largeImg = largeImg.jpegData(compressionQuality: 0.7) {
////                thumbJpeg = jpegData
//            }
//            UIGraphicsEndImageContext()
        }
        
        let database = FMDatabase(path: dbPath)
        if database.open() {
            do {
                if let imgJpeg = imgJpeg {
                    try database.executeUpdate("INSERT INTO entries(date, entry, address, img) VALUES(?,?,?,?)", values: [oneEntry.date, oneEntry.entry, oneEntry.address, imgJpeg])
                }
            }catch{
                print(error)
            }
            database.close()
        }
    }
    
}

