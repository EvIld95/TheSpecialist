//
//  DetailCompanyOffer.swift
//  Specialist
//
//  Created by Paweł Szudrowicz on 08.06.2018.
//  Copyright © 2018 Paweł Szudrowicz. All rights reserved.
//

import UIKit

class DetailCompanyOffer: UIViewController {
    var post: Post? {
        didSet {
            self.captionLabel.text = post!.caption
            
        }
    }
    
    let captionLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let userProfileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .yellow
        iv.clipsToBounds = true
        return iv
    }()
    
    let photoImageView: UIImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .green
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.backgroundColor = .brown
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        self.view.addSubview(userProfileImageView)
        self.view.addSubview(usernameLabel)
        self.view.addSubview(photoImageView)
        userProfileImageView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, left: self.view.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        userProfileImageView.layer.cornerRadius = 40 / 2
        
        usernameLabel.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, left: userProfileImageView.rightAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        photoImageView.anchor(top: userProfileImageView.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        photoImageView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        
    }
}
