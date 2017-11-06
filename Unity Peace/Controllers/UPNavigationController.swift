//
//  INNavigationController.swift
//  Unity Peace
//
//  Created by bsingh9 on 06/11/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit

class UPNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barStyle = .black
        self.navigationBar.barTintColor = Constants.NavigationBarTintColor
        self.navigationBar.tintColor = .white
        self.navigationBar.isTranslucent = false
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.white ]
        self.view.backgroundColor = .clear
    }
    
}
