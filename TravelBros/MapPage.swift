//
//  MapPage.swift
//  TravelBros
//
//  Created by Edvard Hedlund on 2018-09-27.
//  Copyright © 2018 Edvard Hedlund. All rights reserved.
//

import UIKit
import MapKit

class MapPage: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var address = ""
    var entryDate = ""
    
    @IBOutlet weak var entryMapView: MKMapView!
    
    var myLocation = CLLocation(latitude: 59.3474678, longitude: 18.1109555)
    var entryLocation = CLLocation(latitude: 90, longitude: 0)
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var distance = 200.0
        
        CLGeocoder().geocodeAddressString(address, completionHandler: {(placemarks, error) in
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                if let entryLocation = placemark.location {
                    
                    distance = 2*self.myLocation.distance(from: entryLocation)
                    
                    let region = MKCoordinateRegion.init(center: entryLocation.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
                    self.entryMapView.setRegion(region, animated: false)
                    
                    
                }
            }
            
            
            
            
            
        })
        
        
    }
    
    
}
