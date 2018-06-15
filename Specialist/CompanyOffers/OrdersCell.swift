//
//  OrdersCell.swift
//  Specialist
//


import UIKit

class OrdersCell: UICollectionViewCell {
    
    var order: Order? {
        didSet {
            usernameLabel.text = order?.user.username
            
            guard let profileImageUrl = order?.user.profileImageUrl else { return }
            
            userProfileImageView.loadImage(urlString: profileImageUrl)
            
            setupAttributedCaption()
            titleLabel.text = order?.caption
            textView.text = order?.text
        }
    }
    
    fileprivate func setupAttributedCaption() {
        guard let post = self.order else { return }
        
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
        label.backgroundColor = UIColor(white: 0, alpha: 0.05)
        return label
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.isEditable = false
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(userProfileImageView)
        addSubview(usernameLabel)
        addSubview(captionLabel)
        addSubview(titleLabel)
        addSubview(textView)
        
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 30)
        
        
        userProfileImageView.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        userProfileImageView.layer.cornerRadius = 40 / 2
        
        usernameLabel.anchor(top: titleLabel.bottomAnchor, left: userProfileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        textView.anchor(top: usernameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        captionLabel.anchor(top: textView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
