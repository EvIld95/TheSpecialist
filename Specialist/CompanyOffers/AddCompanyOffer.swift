//
//  AddCompanyOffer.swift
//  Specialist
//


import UIKit
import Firebase
import CoreLocation

class AddCompanyOfferController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let addImageButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        button.contentMode = .scaleAspectFit
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    let createOfferButton: UIButton = {
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
    
    let addressTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Address"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
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
    
    @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleCreate() {
        guard let caption = captionTextField.text, caption.count > 0 else { return }
        guard let category = categoryText.text, category.count > 0 else { return }
        guard let image = addImageButton.imageView?.image else { return }
        
        guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else { return }
        
        createOfferButton.isEnabled = false
        
        let filename = NSUUID().uuidString
        Storage.storage().reference().child("offers").child(filename).putData(uploadData, metadata: nil) { (metadata, err) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload post image:", err)
                return
            }
            guard let imageUrl = metadata?.downloadURL()?.absoluteString else { return }
            print("Successfully uploaded post image:", imageUrl)
            self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
        }
    }
    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
        guard let caption = captionTextField.text else { return }
        guard let category = categoryText.text, category.count > 0 else { return }
        guard let image = addImageButton.imageView?.image else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let address = addressTextField.text, address.count > 0 else { return }
        let userPostRef = Database.database().reference().child("offers").child(uid)
        let ref = userPostRef.childByAutoId()
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location?.coordinate else { return }
           
            let longitude = location.longitude
            let latitude = location.latitude
            
            let values = ["imageUrl": imageUrl, "caption": caption, "text": self.textView.text, "category": category, "longitude" : longitude, "latitude" : latitude, "address": address, "imageWidth": image.size.width, "imageHeight": image.size.height, "creationDate": Date().timeIntervalSince1970] as [String : Any]
            
            ref.updateChildValues(values) { (err, ref) in
                if let err = err {
                    self.createOfferButton.isEnabled = true
                    print("Failed to save post to DB", err)
                    return
                }
                print("Successfully saved post to DB")
                self.dismiss(animated: true, completion: nil)
                //NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            addImageButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage =
            info["UIImagePickerControllerOriginalImage"] as? UIImage {
            addImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelHandle() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func endEditing() {
        self.captionTextField.resignFirstResponder()
        self.categoryText.resignFirstResponder()
        self.addressTextField.resignFirstResponder()
        self.textView.resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UISwipeGestureRecognizer(target: self, action: #selector(endEditing))
        tap.direction = .down
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelHandle))
        
        self.view.backgroundColor = .white
        let stackView = UIStackView(arrangedSubviews: [addImageButton, captionTextField, categoryText, addressTextField, textView, createOfferButton])
        
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        
        self.view.addSubview(stackView)
        
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        addImageButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/4).isActive = true
        stackView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, left: self.view.safeAreaLayoutGuide.leftAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.safeAreaLayoutGuide.rightAnchor, paddingTop: 12, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
    }
    
}


extension AddCompanyOfferController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}


