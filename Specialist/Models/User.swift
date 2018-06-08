//
//  User.swift
//  Specialist
//
//  Created by Paweł Szudrowicz on 07.06.2018.
//  Copyright © 2018 Paweł Szudrowicz. All rights reserved.
//

import Foundation

struct User {
    let uid: String
    let username: String
    let profileImageUrl: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"]  as? String ?? ""
    }
}
