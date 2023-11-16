//
//  Is Initial View Controller.swift
//  ImageFeed
//
//  Created by Никита Гончаров on 10.11.2023.
//

import Foundation
import UIKit

final class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func profileImage() -> UIImageView {
        let profileImage = UIImageView(image: UIImage(named: "Avatar"))
        view.addSubview(profileImage)
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = 35
        profileImage.tintColor = .ypGray
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImage)
        return profileImage
    }
    
    private func userName() -> UILabel {
        let userName = UILabel()
        view.addSubview(userName)
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.textColor = .ypWhite
        userName.text = "Екатерина Новикова"
        userName.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        
        return userName
    }
    
    private func nickname() -> UILabel {
        let nickname = UILabel()
        view.addSubview(nickname)
        nickname.translatesAutoresizingMaskIntoConstraints = false
        nickname.textColor = .ypGray
        nickname.text = "@ekaterina_nov"
        nickname.font = UIFont.systemFont(ofSize: 13)
        
        return nickname
    }
    
    private func profileDescription() -> UILabel {
        let profileDescription = UILabel()
        view.addSubview(profileDescription)
        profileDescription.translatesAutoresizingMaskIntoConstraints = false
        profileDescription.textColor = .ypWhite
        profileDescription.text = "Hello, world!"
        profileDescription.font = UIFont.systemFont(ofSize: 13)
        
        return profileDescription
    }
    
    private func logoutButton() -> UIButton {
        let logoutButton = UIButton()
        view.addSubview(logoutButton)
        logoutButton.setImage(UIImage(named: "logout button"), for: .normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        return logoutButton
    }
    
    @objc
    private func didTapLogoutButton() {
    }
    
    private func setupViews() {
        let profileImage = profileImage()
        let userName = userName()
        let nickname = nickname()
        let profileDescription = profileDescription()
        let logoutButton = logoutButton()
        
        NSLayoutConstraint.activate([
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            userName.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            nickname.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 8),
            nickname.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            profileDescription.topAnchor.constraint(equalTo: nickname.bottomAnchor, constant: 8),
            profileDescription.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
        ])
    }
}
