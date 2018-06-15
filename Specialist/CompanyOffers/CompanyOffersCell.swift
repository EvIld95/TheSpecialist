//
//  CompanyOffesCell.swift
//  Specialist
//


import Foundation
import UIKit

class CompanyOffersCell: UICollectionViewCell {

    var post: Post? {
        didSet {
            guard let postImageUrl = post?.imageUrl else { return }
            photoImageView.loadImage(urlString: postImageUrl)
            usernameLabel.text = post?.user.username
            
            guard let profileImageUrl = post?.user.profileImageUrl else { return }
            
            userProfileImageView.loadImage(urlString: profileImageUrl)
            
            //            captionLabel.text = post?.caption
            
            setupAttributedCaption()
            titleLabel.text = post?.caption
        }
    }
    
    fileprivate func setupAttributedCaption() {
        guard let post = self.post else { return }
        
        let timeAgoDisplay = post.creationDate.timeAgoDisplay()
        let attributedText = NSMutableAttributedString(string: timeAgoDisplay, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.gray])
        
        attributedText.append(NSAttributedString(string: "\n", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 4)]))
        attributedText.append(NSAttributedString(string: post.address, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.black]))
        captionLabel.attributedText = attributedText
    }
    
    let userProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let photoImageView: CustomImageView = {
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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(userProfileImageView)
        addSubview(usernameLabel)
        addSubview(photoImageView)
        addSubview(captionLabel)
        addSubview(titleLabel)
        
        userProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        userProfileImageView.layer.cornerRadius = 40 / 2
        
        usernameLabel.anchor(top: topAnchor, left: userProfileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        titleLabel.anchor(top: userProfileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        
        photoImageView.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        
        captionLabel.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
