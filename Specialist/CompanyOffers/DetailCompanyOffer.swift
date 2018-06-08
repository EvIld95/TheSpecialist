//
//  DetailCompanyOffer.swift
//  Specialist
//
//  Created by Paweł Szudrowicz on 08.06.2018.
//  Copyright © 2018 Paweł Szudrowicz. All rights reserved.
//

import UIKit

class DetailCompanyOffer: UIViewController {
    let captionLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let userProfileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let photoImageView: UIImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
