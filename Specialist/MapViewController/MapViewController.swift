//
//  MapViewController.swift
//  Specialist
//
//  Created by Paweł Szudrowicz on 12.06.2018.
//  Copyright © 2018 Paweł Szudrowicz. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import Firebase

class MapViewController: UIViewController {
    
    var locationManager = CLLocationManager()
    lazy var mapView: MKMapView = {
        let mv = MKMapView()
        mv.delegate = self
        return mv
    }()
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .other
        locationManager.distanceFilter = 3.0
        locationManager.requestWhenInUseAuthorization()
        
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAllOffers()
        self.view.addSubview(mapView)
        setupLocationManager()
        mapView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    var offers = [Post]()
    fileprivate func fetchAllOffers() {
        Database.database().reference().child("offers").observeSingleEvent(of: .value) { (snapshot) in
            guard let orderIdsDictionary = snapshot.value as? [String: Any] else { return }
            let myGroup = DispatchGroup()
            orderIdsDictionary.forEach({ (key, value) in
                myGroup.enter()
                guard let ordersDictionary = value as? [String: Any] else { return }
                Database.fetchUserWithUID(uid: key, completion: { (user) in
                    ordersDictionary.forEach({ (orderKey, orderValue) in
                        guard let orderData = orderValue as? [String: Any] else { return }
                        var offer = Post(user: user, dictionary: orderData)
                        offer.id = orderKey
                        self.offers.append(offer)
                    })
                    myGroup.leave()
                })
            })
            myGroup.notify(queue: .main) {
                
                for offer in self.offers {
                    let pointAnnotation = MKPointAnnotation()
                    pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: offer.latitude, longitude: offer.longitude)
                    pointAnnotation.title = offer.caption
                    self.mapView.addAnnotation(pointAnnotation)
                }
                
            }
            
        }
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("AuthorizationAlways")
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        let center = CLLocationCoordinate2D(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.06, longitudeDelta: 0.06))
        mapView.setRegion(region, animated: true)
        
        print("\(newLocation.coordinate.latitude) | \(newLocation.coordinate.longitude)")
        
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        
        if newLocation.speed < 0 {
            return
        }
        
        if newLocation.horizontalAccuracy < 20.0 {
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        var reuseIdentifier = "pinItem"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView!.canShowCallout = true
            annotationView!.isEnabled = true
            annotationView!.isUserInteractionEnabled = true
            //let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
            //label.text = "Time"
            
            //annotationView!.rightCalloutAccessoryView = label
            
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }

    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print("Did update user location")
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Select")
    }
}
