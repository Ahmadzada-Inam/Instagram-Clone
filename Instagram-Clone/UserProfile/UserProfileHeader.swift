//
//  UserProfileHeader.swift
//  Instagram-Clone
//
//  Created by Inam Ahmad-zada on 2018-01-08.
//  Copyright © 2018 Inam Ahmad-zada. All rights reserved.
//

import UIKit

class UserProfilerHeader: UICollectionViewCell {
    
    var user: InstagramUser? {
        didSet {
            guard let profileImageUrlString = user?.imageUrl else { return }
            userImageView.loadImage(with: profileImageUrlString)
            usernameLabel.text = user?.username
        }
    }
    
    let userImageView: CustomImageView = {
        let view = CustomImageView()
        return view
    }()
    
    let gridButton: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        return view
    }()
    
    let listButton: UIButton = {
        let view = UIButton(type: .system)
        view.tintColor = UIColor(white: 0, alpha: 0.2)
        view.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        return view
    }()
    
    let bookmarkButton: UIButton = {
        let view = UIButton(type: .system)
        view.tintColor = UIColor(white: 0, alpha: 0.2)
        view.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        return view
    }()
    
    let postsLabel: UILabel = {
        let view = UILabel()
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray]))
        view.attributedText = attributedText
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    let followersLabel: UILabel = {
        let view = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray]))
        view.attributedText = attributedText
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    let followingLabel: UILabel = {
        let view = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray]))
        view.attributedText = attributedText
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    let editProfileButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Edit Profile", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 5
        return view
    }()
    
    let usernameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.boldSystemFont(ofSize: 14)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(userImageView)
        userImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, topPadding: 12, leftPadding: 12, bottomPadding: 0, rightPadding: 0, width: 80, height: 80)
        userImageView.layer.cornerRadius = 80 / 2
        userImageView.clipsToBounds = true
        
        setupBottomToolbar()
        setupUserStats()
        addSubview(editProfileButton)
        editProfileButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, topPadding: 2, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 34)
        addSubview(usernameLabel)
        usernameLabel.anchor(top: editProfileButton.bottomAnchor, left: leftAnchor, bottom: gridButton.topAnchor, right: rightAnchor, topPadding: 3, leftPadding: 12, bottomPadding: 0, rightPadding: 12, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupBottomToolbar() {
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 50)
        
        let topBorder = UIView()
        topBorder.backgroundColor = .lightGray
        
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = .lightGray
        
        addSubview(topBorder)
        addSubview(bottomBorder) 
        topBorder.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 0.5)
        bottomBorder.anchor(top: nil, left: leftAnchor, bottom: stackView.bottomAnchor, right: rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 0.5)
    }
    
    fileprivate func setupUserStats() {
        let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: userImageView.rightAnchor, bottom: nil, right: rightAnchor, topPadding: 12, leftPadding: 12, bottomPadding: 0, rightPadding: 12, width: 0, height: 50)
    }
}
