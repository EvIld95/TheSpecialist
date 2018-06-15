//
//  LoginController.swift
//  Specialist
//


import Foundation
import UIKit
import Firebase

class LoginController: UIViewController {
    var stackViewButton: UIStackView!
    
    let logoContainerView: UIView = {
        let view = UIView()
        let logoText = UILabel()
        logoText.text = "The Specialist"
        logoText.font = UIFont.boldSystemFont(ofSize: 30)
        logoText.numberOfLines = 0
        logoText.textAlignment = .center
        logoText.textColor = .white
    
        view.addSubview(logoText)
        logoText.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
        logoText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoText.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20).isActive = true
        
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            loginButton.isEnabled = true
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
                self.stackViewButton.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                self.stackViewButton.layoutIfNeeded()
            }, completion: nil)
        } else {
            loginButton.isEnabled = false
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
                self.stackViewButton.layoutMargins = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 80)
                self.stackViewButton.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        button.isEnabled = false
        
        return button
    }()
    
    @objc fileprivate func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let pass = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: pass) { (user, err) in
            if let err = err {
                let alertController = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            print("Successfully logged back in with user:", user?.uid ?? "")
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            mainTabBarController.setupViewControllers()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Dont have an account? ", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.setTitle("Dont have an account? Sign up", for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleSignUp() {
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func endEditing() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        view.backgroundColor = .white
        view.addSubview(dontHaveAccountButton)
        view.addSubview(logoContainerView)
        
        navigationController?.isNavigationBarHidden = true
        
        logoContainerView.anchor(top: view.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
        
        dontHaveAccountButton.anchor(top: nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        setupInputFields()
        
    }
    
    fileprivate func setupInputFields() {
        self.stackViewButton = UIStackView(arrangedSubviews: [loginButton])
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, stackViewButton])
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        

        view.addSubview(stackView)
        
        stackViewButton.layoutMargins = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 80)
        stackViewButton.isLayoutMarginsRelativeArrangement = true
        stackView.anchor(top: logoContainerView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 140)
    }
}
