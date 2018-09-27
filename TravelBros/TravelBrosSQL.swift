//
//  TravelBrosSQL.swift
//  TravelBros
//
//  Created by Edvard Hedlund on 2018-09-27.
//  Copyright © 2018 Edvard Hedlund. All rights reserved.
//

import UIKit

class RestaurantDataSQL {
    
    struct Entry {
        var id = ""
        var date = ""
        var imgUrl = ""
        var img:UIImage?
        var thumbUrl = ""
        var thumb:UIImage?
        var adress = ""
        var entry = ""
    }
    
    var entryArray:[Entry] = []
    var oneEntry = Entry()
    var dbPath = ""
    
    init() {
        let docPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        dbPath = docPath[0].appendingPathComponent("travelbrosDB.db").path
        
        if !FileManager.default.fileExists(atPath: dbPath) {
            if let bundlePath = Bundle.main.resourceURL?.appendingPathComponent("restaurantDB.db").path {
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
    
    func loadDB() {
        let database = FMDatabase(path: dbPath)
        if database.open() {
            do {
                let resSet = try database.executeQuery("SELECT * from restaurants", values: nil)
                while resSet.next() {
                    var newEntry = Entry()
                    newEntry.id = resSet.string(forColumn:"id") ?? ""
                    newEntry.date = resSet.string(forColumn:"date") ?? ""
                    if let imgData = resSet.data(forColumn:"thumb") {
                        newEntry.thumb = UIImage(data:imgData)
                    }
                    entryArray.append(newEntry)
                }
            }catch{
                print(error)
            }
            database.close()
            
        }
    }
    
    func loadOne(restId:String) {
        let database = FMDatabase(path: dbPath)
        if database.open() {
            do {
                let resSet = try database.executeQuery("SELECT * from entries WHERE id=?", values: [restId])
                while resSet.next() {
                    self.oneRestaurant.name = resSet.string(forColumn:"name") ?? ""
                    self.oneRestaurant.adress = resSet.string(forColumn:"address") ?? ""
                    self.oneRestaurant.url = resSet.string(forColumn:"url") ?? ""
                    self.oneRestaurant.tel = resSet.string(forColumn:"tel") ?? ""
                    self.oneRestaurant.about = resSet.string(forColumn:"about") ?? ""
                    
                    if let imgData = resSet.data(forColumn:"img") {
                        self.oneRestaurant.img = UIImage(data:imgData)
                    }
                }
            }catch{
                print(error)
            }
            database.close()
        }
    }
    
    func uploadData() {
        var imgJpeg:Data?
        var thumbJpeg:Data?
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
            
            UIGraphicsBeginImageContext(CGSize(width: 80, height: 80))
            ratio = Double(image.size.width/image.size.height)
            scaleWidth = ratio*80.0
            scaleHeight = 80.0
            offsetX = (scaleWidth-80)/2.0
            offsetY = 0.0
            image.draw(in: CGRect(x: -offsetX, y: -offsetY, width: scaleWidth, height: scaleHeight))
            if let largeImg = largeImg, let jpegData = largeImg.jpegData(compressionQuality: 0.7) {
                thumbJpeg = jpegData
            }
            UIGraphicsEndImageContext()
        }
        
        let database = FMDatabase(path: dbPath)
        if database.open() {
            do {
                if let imgJpeg = imgJpeg, let thumbJpeg = thumbJpeg {
                    try database.executeUpdate("INSERT INTO restaurants(name, address, tel, url, about, img, thumb) VALUES(?,?,?,?,?,?,?)", values: [oneEntry.name, oneEntry.adress, oneEntry.tel, oneEntry.url, oneEntry.about, imgJpeg, thumbJpeg])
                }
            }catch{
                print(error)
            }
            database.close()
        }
    }
    
}

