//
//  UserDetailCell.swift
//  SaltMiniProject
//
//  Created by Hafshy Yazid Albisthami on 20/10/23.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class UserInfoCell: UITableViewCell {
    static let identifier = "UserInfoCell"
    
    private let stackView = UIStackView()       // MARK: Stack for name and email(object)
    
//  MARK: Avatar picture (object)
    private let avatarView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "questionmark")
        iv.tintColor = .white
        iv.clipsToBounds = true
        return iv
    }()

//  MARK: Full Name Label (object)
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "name_placeholder"
        label.numberOfLines = 2
        return label
    }()

//  MARK: Email Label (object)
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.text = "email_placeholder"
        return label
    }()

//  MARK: Setup Full Name and Email
    private func configureStackView() {
        self.contentView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 4
        
        configureFullName()
        configureEmail()
    }
    
    func configureFullName() {
        stackView.addArrangedSubview(fullNameLabel)
        
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fullNameLabel.leftAnchor.constraint(equalTo: stackView.leftAnchor)
        ])
    }
    
    func configureEmail() {
        stackView.addArrangedSubview(emailLabel)
        
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailLabel.leftAnchor.constraint(equalTo: stackView.leftAnchor)
        ])
    }
    
//  MARK: Call to execute building cell
    public func configure(userInfo: UserInfoData) {
        AF.request(userInfo.avatar).responseImage { response in
            if let image = response.value {
                self.avatarView.image = image
            }
        }
        self.fullNameLabel.text = "\(userInfo.firstName) \(userInfo.lastName)"
        self.emailLabel.text = userInfo.email
        self.setupCell()
    }
    
//  MARK: Setup all components
    private func setupCell() {
        self.configureStackView()
        self.contentView.addSubview(avatarView)
        
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor, constant: 4),
            avatarView.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            avatarView.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 24),
            stackView.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor)
        ])
    }
}
