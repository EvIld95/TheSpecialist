//
//  AddOrderController.swift
//  Specialist
//

import Foundation

import UIKit
import Firebase
import CoreLocation

class AddOrderController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var currentUserLocation : CLLocation?
    
    let createOrderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .specialistBlue
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(handleCreate), for: .touchUpInside)
        return button
    }()
    
    let placeholderLabel = UILabel()
    
    lazy var textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.layer.cornerRadius = 5.0
        tv.layer.borderColor = UIColor(white: 0, alpha: 0.05).cgColor
        tv.layer.borderWidth = 2.0
        
        tv.delegate = self
        
        placeholderLabel.text = "Enter some text..."
        placeholderLabel.font = UIFont.systemFont(ofSize: (tv.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        tv.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (tv.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !tv.text.isEmpty
        
        return tv
    }()
    
    let captionTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Caption"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        
        //tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let categoryText: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Categories"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        return tf
    }()
    

    @objc func handleCreate() {
        guard let caption = captionTextField.text, caption.count > 0 else { return }
        guard let category = categoryText.text, category.count > 0 else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let location = self.currentUserLocation else { return }
        createOrderButton.isEnabled = false
        
        let userPostRef = Database.database().reference().child("orders").child(uid)
        let ref = userPostRef.childByAutoId()
        
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            let longitude = self.currentUserLocation!.coordinate.longitude
            let latitude = self.currentUserLocation!.coordinate.latitude
            let addressLocation = placemarks?.first?.compactAddress ?? ""
            let values = ["caption": caption, "text": self.textView.text, "category": category, "longitude" : longitude, "latitude" : latitude, "address": addressLocation, "creationDate": Date().timeIntervalSince1970] as [String : Any]
            
            ref.updateChildValues(values) { (err, ref) in
                if let err = err {
                    self.createOrderButton.isEnabled = true
                    print("Failed to save post to DB", err)
                    return
                }
                print("Successfully saved post to DB")
                self.dismiss(animated: true, completion: nil)
                //NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
            }
            
            
        }
        
    }

    
    @objc func cancelHandle() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func endEditing() {
        self.captionTextField.resignFirstResponder()
        self.categoryText.resignFirstResponder()
        self.textView.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.locationManager.requestAlwaysAuthorization()
        
        let tap = UISwipeGestureRecognizer(target: self, action: #selector(endEditing))
        tap.direction = .down
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelHandle))
        
        self.view.backgroundColor = .white
        let stackView = UIStackView(arrangedSubviews: [captionTextField, categoryText, textView, createOrderButton])
        
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        
        self.view.addSubview(stackView)
        
        stackView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, left: self.view.safeAreaLayoutGuide.leftAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.safeAreaLayoutGuide.rightAnchor, paddingTop: 12, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue = manager.location else { return }
        self.currentUserLocation = locValue
    }
    
}


extension AddOrderController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

extension CLPlacemark {
    
    var compactAddress: String? {
        if let name = name {
            var result = name
            
            if let city = locality {
                result += ", \(city)"
            }
            
            if let country = country {
                result += ", \(country)"
            }
            
            return result
        }
        
        return nil
    }
    
}


