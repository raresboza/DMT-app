//
//  JobListViewController.swift
//  DMT
//
//  Created by Boza Rares-Dorian on 07/05/2018.
//  Copyright © 2018 Boggy. All rights reserved.
//

import UIKit

class JobListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var labelArray = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"]
    var imageArray = [UIImage(named:"Cancel"),]
    func getDate(number: Int) -> Int
    {
    let currentDate = Date()
    let calendar = Calendar.current
    let month = calendar.component(.month, from: currentDate)
         let day = calendar.component(.day, from: currentDate)
        print("\(month)")
        print("\(day)")
        if number == 1{
    return month
        }else{
    return day
           
        }
   
        
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let month = getDate(number: 1)
        print("\(month)")
        return numOfDaysInMonth[month-1]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        print("\(indexPath.row)")
        cell.dateLabel.text = labelArray[indexPath.row]
        cell.dateImageView.image = imageArray[0]
        return cell
    }
    //

    override func viewDidLoad() {
        super.viewDidLoad()
        
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
   
   
}
