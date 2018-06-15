//
//  ProfileViewController.swift
//  Specialist
//


import UIKit


class ProfileViewController: UIViewController {
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = iv.frame.width/2
        iv.backgroundColor = .specialistBlue
        
        return iv
    }()
    
    override func viewDidLoad() {
        
    }
}
