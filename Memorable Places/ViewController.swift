//
//  ViewController.swift
//  Memorable Places
//
//  Created by Yu Andrew - andryu on 1/1/15.
//  Copyright (c) 2015 Andrew Yu. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    var manager = CLLocationManager()
    var activePlace: [String:String]?
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func findMePressed(sender: AnyObject) {
        manager.startUpdatingLocation()
    }
    
    @IBAction func pressedLongOnMap(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Began {
            let touchPoint = sender.locationInView(mapView)
            let coordinate = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> () in
                if error != nil {
                    println("\(error)")
                } else {
                    let placemark = placemarks?[0] as CLPlacemark?
                    let placeName = self.getPlacemarkName(coordinate, placemark: placemark)
                    self.addAnnatation(location, withName: placeName)
                    places.append(["name": placeName, "latitude": "\(coordinate.latitude)", "longtitude": "\(coordinate.longitude)"])
                    userDefaults.setObject(places, forKey: "places")
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        if let place = activePlace {
            let location = CLLocation(latitude: (place["latitude"]! as NSString).doubleValue, longitude: (place["longtitude"]! as NSString).doubleValue)
            setMapViewToRegionWithLocation(location)
            addAnnatation(location, withName: place["name"]!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations[0] as CLLocation
        setMapViewToRegionWithLocation(location)
        manager.stopUpdatingLocation()
    }

    func setMapViewToRegionWithLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.01, 0.01)
        var coordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        var region = MKCoordinateRegionMake(coordinate2D, span)
        mapView.setRegion(region, animated: true)
    }
    
    func addAnnatation(location: CLLocation, withName name: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = name
        mapView.addAnnotation(annotation)
    }
    
    func getPlacemarkName(coordinate: CLLocationCoordinate2D, placemark: CLPlacemark!) -> String {
        var placeName: String
        if placemark != nil {
            if let thoroughfare = placemark.thoroughfare {
                if let subThoroughfare = placemark.subThoroughfare{
                    placeName = subThoroughfare + " " + thoroughfare + ", " + placemark.locality + ", " + placemark.administrativeArea
                } else {
                    placeName = thoroughfare + ", " + placemark.locality + ", " + placemark.administrativeArea
                }
            } else {
                placeName = placemark.locality + ", " + placemark.administrativeArea
            }
        } else {
            placeName = "\(coordinate.latitude), \(coordinate.longitude)"
        }
        return placeName
    }
    
    
}

