//
//  Post.swift
//  Specialist
//
//  Created by Paweł Szudrowicz on 07.06.2018.
//  Copyright © 2018 Paweł Szudrowicz. All rights reserved.
//

import Foundation
struct Post {
    
    var id: String?
    
    let user: User
    let imageUrl: String
    let caption: String
    let text: String
    let creationDate: Date
    let category: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        self.category = dictionary["category"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
