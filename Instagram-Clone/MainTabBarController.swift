//
//  MainTabBarController.swift
//  Instagram-Clone
//
//  Created by Inam Ahmad-zada on 2018-01-08.
//  Copyright © 2018 Inam Ahmad-zada. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async { [weak self] in
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self?.present(navController, animated: true, completion: nil)
            }
        }
        
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let navController = UINavigationController(rootViewController: userProfileController)
        
        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        tabBar.tintColor = .black
        
        viewControllers = [navController]
    }
}
