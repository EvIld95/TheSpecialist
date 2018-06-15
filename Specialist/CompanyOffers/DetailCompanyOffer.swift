//
//  DetailCompanyOffer.swift
//  Specialist
//


import UIKit

class DetailCompanyOffer: UIViewController {
    var post: Post? {
        didSet {
            self.captionLabel.text = post!.caption
            self.usernameLabel.text = post?.user.username
            self.addressLabel.text = post?.address
            self.textView.text = post?.text
        }
    }
    
    var profileImage: UIImage? {
        didSet {
            self.userProfileImageView.image = profileImage
        }
    }
    
    var image: UIImage? {
        didSet {
            self.photoImageView.image = image
        }
    }
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let userProfileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
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
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.layer.cornerRadius = 5.0
        tv.layer.borderColor = UIColor(white: 0, alpha: 0.05).cgColor
        tv.layer.borderWidth = 2.0
        tv.isEditable = false
        return tv
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
        self.view.backgroundColor = .white
        self.view.addSubview(userProfileImageView)
        self.view.addSubview(usernameLabel)
        self.view.addSubview(photoImageView)
        self.view.addSubview(captionLabel)
        self.view.addSubview(textView)
        self.view.addSubview(addressLabel)
        
        userProfileImageView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, left: self.view.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        userProfileImageView.layer.cornerRadius = 40 / 2
        
        usernameLabel.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, left: userProfileImageView.rightAnchor, bottom: nil, right: self.addressLabel.leftAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        addressLabel.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, left: self.usernameLabel.rightAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        captionLabel.anchor(top: self.usernameLabel.bottomAnchor, left: self.view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: self.view.safeAreaLayoutGuide.rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 40)
        
        photoImageView.anchor(top: captionLabel.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        photoImageView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        
        textView.anchor(top: photoImageView.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 50)
        
        
        
    }
}
