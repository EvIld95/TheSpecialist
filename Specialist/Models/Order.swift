//
//  Order.swift
//  Specialist
//


import UIKit
import Foundation
import CoreLocation

struct Order {
    
    var id: String?
    
    let user: User
    let caption: String
    let text: String
    let creationDate: Date
    let category: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let address: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.caption = dictionary["caption"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        self.category = dictionary["category"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
        self.latitude = dictionary["latitude"] as? CLLocationDegrees ?? 0
        self.longitude = dictionary["longitude"] as? CLLocationDegrees ?? 0
        self.address = dictionary["address"] as? String ?? ""
    }
}
