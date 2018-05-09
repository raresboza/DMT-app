//
//  CustomUITabController.swift
//  DMT
//
//  Created by Synergy on 09/05/2018.
//  Copyright © 2018 Boggy. All rights reserved.
//

import UIKit

class CustomUITabController: UITabBarController {
    let bigButton = UIButton.init(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bigButton.setTitle("+", for: .normal)
        bigButton.setTitleColor(.green, for: .normal)
        bigButton.setTitleColor(.blue, for: .highlighted)
        bigButton.backgroundColor = .orange
        bigButton.layer.borderWidth = 3
        bigButton.layer.borderColor = UIColor.black.cgColor
        self.view.insertSubview(bigButton, aboveSubview: self.tabBar)
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bigButton.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.tabBar.center.y - 49, width: 64, height: 64)
        bigButton.layer.cornerRadius = 32
    }


}
