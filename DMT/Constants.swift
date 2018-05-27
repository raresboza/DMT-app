//
//  Constants.swift
//  DMT
//
//  Created by Boggy on 04/03/2018.
//  Copyright © 2018 Boggy. All rights reserved.
//

import Foundation
import UIKit
struct UserDefaultsKeys {
    static let rememberSwitchState = "switchState"
    static let savedEmail = "savedEmail"
    static let savedPassword = "passwordEmail"
    static let noEmail = ""
    static let noPassword = ""
}
struct Colors {
    
    static let myCyan = UIColor(red: (171/255.0), green: (245/255.0), blue: (255/255.0), alpha: 1.0)
    static let seaBlue = UIColor(red: (54/255.0), green: (90/255.0), blue: (255/255.0), alpha: 1.0)
    static let bgPurple = UIColor(red: (173/255.0), green: (0/255.0), blue: (255/255.0), alpha: 0.37)
    static let transparent = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 0.0)
    static let bgRed = UIColor(red: (255/255.0), green: (18/255.0), blue: (18/255.0), alpha: 0.64)
    static let bgWhite = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 0.4)
}



struct Constraints{
    
    static let topBarHeight = UIApplication.shared.statusBarFrame.size.height + 44.0
}
