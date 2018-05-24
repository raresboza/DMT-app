//
//  HomeViewController.swift
//  DMT
//
//  Created by Boza Rares-Dorian on 20/05/2018.
//  Copyright © 2018 Boggy. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UltraWeekCalendarDelegate, UICollectionViewDelegate, UICollectionViewDataSource

{
    var userDetails: NSDictionary? // aceasta instanta este creata atunci cand se va face tranzitia din LoginVC in HomeVC
    
    let reuseIdentifier = "cell"
    var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48"]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as!CollectionViewCell
        
        cell.nameLabel.text = self.items[indexPath.item]
        cell.backgroundColor = UIColor.cyan
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("celula selectata -  \(indexPath.item)!")

    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width-15, height: 80)

    }
    
    var calendar : UltraWeekCalendar? = nil
        
    override func viewDidLoad() {
        print("HomeViewController - viewDidLoad")
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
    
    override func viewWillAppear(_ animated: Bool) {
        print("HomeViewController - viewWillAppear")
        if let userDetails = userDetails {
            print("HomeViewController - user details: \(userDetails) ")
        }
        
    }
    func dateButtonClicked() {
        
    }

    

   

}
