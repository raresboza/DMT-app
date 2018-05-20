//
//  HomeViewController.swift
//  DMT
//
//  Created by Boza Rares-Dorian on 20/05/2018.
//  Copyright © 2018 Boggy. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UltraWeekCalendarDelegate {
    
    var calendar : UltraWeekCalendar? = nil
        
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar = UltraWeekCalendar.init(frame: CGRect(x: 0, y: Constraints.topBarHeight, width: UIScreen.main.bounds.width, height: 60))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let someDateTime = formatter.date(from: "2018/10/08")
        calendar?.delegate = self
        calendar?.startDate = Date()
        calendar?.endDate = someDateTime
        calendar?.selectedDate = Date()
        self.view.addSubview(calendar!)
        
    
    }
    func dateButtonClicked() {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    

   

}
