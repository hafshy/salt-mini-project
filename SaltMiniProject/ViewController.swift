//
//  ViewController.swift
//  SaltMiniProject
//
//  Created by Hafshy Yazid Albisthami on 20/10/23.
//

import UIKit
import Alamofire

//  MARK: Login View (ViewController name to know where the App Entry Code)
class ViewController: UIViewController {
//  MARK: View Objects
    private let stackView = UIStackView()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let submitButton = UIButton()
    private let loadingView = UIActivityIndicatorView(style: .large)
    private let alert = UIAlertController(title: "Try Again", message: "Wrong Email or Password", preferredStyle: .alert)

//  MARK: Entry Point
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureStackView()
        alert.addAction(UIAlertAction(title: "OK", style: .default))
    }

//  MARK: Setup All Components
    func configureStackView() {
        self.view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 16
        
        configureEmailTextField()
        configurePasswordTextField()
        configureSubmitButton()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -100).isActive = true
    }

//  MARK: Setup Email Field
    func configureEmailTextField() {
        emailTextField.placeholder = "Email"
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.borderStyle = .roundedRect
        
        stackView.addArrangedSubview(emailTextField)
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailTextField.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            emailTextField.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            emailTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

//  MARK: Setup Password Field
    func configurePasswordTextField() {
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        passwordTextField.borderStyle = .roundedRect
        
        stackView.addArrangedSubview(passwordTextField)
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordTextField.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            passwordTextField.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

//  MARK: Setup Button
    func configureSubmitButton() {
        submitButton.backgroundColor = .systemBlue
        submitButton.setTitle("Submit", for: .normal)
        submitButton.layer.cornerRadius = 12
        submitButton.tintColor = .white
        
        stackView.addArrangedSubview(submitButton)
        
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            submitButton.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            submitButton.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            submitButton.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 52)
        ])
        submitButton.addTarget(self, action: #selector(login), for: .touchUpInside)
    }

//  MARK: Loading when fetching API
    private func configureLoadingIndicator() {
        self.view.addSubview(loadingView)
        loadingView.startAnimating()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

//  MARK: Stop Loading when API fetched
    private func removeLoadingIndicator() {
        loadingView.stopAnimating()
        loadingView.removeFromSuperview()
    }
    
//  MARK: Fetch Login API
    @objc
    private func login() {
        let params = [
            "email": emailTextField.text,
            "password": passwordTextField.text
        ]
        self.configureLoadingIndicator()
        let request = AF.request("https://reqres.in/api/login", method: .post, parameters: params)
        request.responseDecodable(of: TokenDataModel.self) { response in
            self.removeLoadingIndicator()
            if let successResponse = response.value {
                UserDefaults.standard.set(successResponse.token, forKey: "token")
                let homepageVC = HomePageViewController()
                self.navigationController?.pushViewController(homepageVC, animated: true)
            } else {
                self.present(self.alert, animated: true, completion: nil)
            }
        }
    }
}

