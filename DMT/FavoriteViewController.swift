//
//  FavoriteViewController.swift
//  DMT
//
//  Created by Synergy on 09/05/2018.
//  Copyright © 2018 Boggy. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController, UltraWeekCalendarDelegate {
    
    var calendar : UltraWeekCalendar? = nil
    
    @IBOutlet weak var showDateLabel: UILabel!
    
    func dateButtonClicked() {
        let selectedDate = calendar?.selectedDate
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let stringFromDate = formatter.string(from: selectedDate!)
        let finalDate = formatter.date(from: stringFromDate)
        formatter.dateFormat = "dd-MMM-yyyy"
        let finalStringDate = formatter.string(from: finalDate!)

        print("s-a apasat pe = \(String(describing: selectedDate))")
        showDateLabel.text = finalStringDate

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar = UltraWeekCalendar.init(frame: CGRect(x: 0, y: 30, width: UIScreen.main.bounds.width, height: 50))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let someDateTime = formatter.date(from: "2018/10/08")
        
        calendar?.delegate = self
        calendar?.startDate = Date()
        calendar?.endDate = someDateTime
        self.view.addSubview(calendar!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
