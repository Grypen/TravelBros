//
//  MapPage.swift
//  TravelBros
//
//  Created by Edvard Hedlund on 2018-09-27.
//  Copyright © 2018 Edvard Hedlund. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

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
                if let entryMapLocation = placemark.location {
                    
                    distance = 2*self.myLocation.distance(from: entryMapLocation)
                    
                    let region = MKCoordinateRegion.init(center: entryMapLocation.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
                    self.entryMapView.setRegion(region, animated: false)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = entryMapLocation.coordinate
                    let distString = String(format: "%.1f", distance/1000)
                    annotation.title = "\(self.entryDate)\n\(distString) km"
                self.entryMapView.addAnnotation(annotation)
                    
                    self.entryLocation = entryMapLocation
                    
                   self.findMyLocation()
                }
            }
            
            
            
            
            
        })
        
        
    }
    
    func drawDirection() {
        let startPlacemark = MKPlacemark(coordinate: myLocation.coordinate, addressDictionary: nil)
        let endPlacemark = MKPlacemark(coordinate: entryLocation.coordinate, addressDictionary: nil)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: startPlacemark)
        directionRequest.destination = MKMapItem(placemark: endPlacemark)
        
//        switch routeBtn.selectedSegmentIndex {
//        case 1:
//            directionRequest.transportType = MKDirectionsTransportType.walking
//        default:
//            directionRequest.transportType = MKDirectionsTransportType.automobile
//        }
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (routeResponse, routeError) in
            if let routeResponse = routeResponse  {
                self.entryMapView.removeOverlays(self.entryMapView.overlays)
                let route = routeResponse.routes[0]
                self.entryMapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 3.0
        renderer.strokeColor = UIColor.purple
        renderer.alpha = 0.5
        return renderer
    }
    
    func findMyLocation() {
        print("hello location")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations[0]
        print(newLocation)
        let distance = myLocation.distance(from: newLocation)
        if distance > 10 {
            myLocation = newLocation
            drawDirection()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
