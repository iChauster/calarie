//
//  DataManager.swift
//  PillAR
//
//  Created by Avery Lamp on 9/9/17.
//  Copyright © 2017 Ryan Sullivan. All rights reserved.
//

import UIKit
import SwiftyJSON
enum HistoryVisible {
    case Visible
    case Hidden
}

class FoodManager {
    static var sharedInstance: FoodManager = {
        let dataManager = FoodManager()
        return dataManager
    }()
    
    var historyState:HistoryVisible = .Hidden
    
    class func shared() -> FoodManager {
        return sharedInstance
    }
    
    init(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss zzz"
        
        pillHistoryData.append(HistoryData(foodName: "Bagel", calories: 256, timeTaken: dateFormatter.date(from: "09-22-2017 11:23:30 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Orange", calories: 44, timeTaken: dateFormatter.date(from: "09-22-2017 11:56:23 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Apple", calories: 52, timeTaken: dateFormatter.date(from: "09-22-2017 11:57:43 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Bannana", calories: 47, timeTaken: dateFormatter.date(from: "09-23-2017 01:35:23 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Water", calories: 0, timeTaken: dateFormatter.date(from: "09-23-2017 01:45:45 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Bottled Water", calories: 1, timeTaken: dateFormatter.date(from: "09-23-2017 01:47:23 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Milk", calories: 103, timeTaken: dateFormatter.date(from: "09-23-2017 10:01:57 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Pizza", calories: 285, timeTaken: dateFormatter.date(from: "09-23-2017 10:05:32 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Bread", calories: 79, timeTaken: dateFormatter.date(from: "09-23-2017 12:05:53 EST")!))

   
        pillHistoryData.sort { (h1, h2) -> Bool in
            return h1.timeTaken > h2.timeTaken
        }
    }
    
    
    
    func addPillHistory(foodName: String, calories:Int, timeTaken:Date = Date()){
        let pillHistory = HistoryData(foodName: foodName, calories: calories, timeTaken: timeTaken, calculateTodayDose: true)
        pillHistoryData.append(pillHistory)
        pillHistoryData.sort { (h1, h2) -> Bool in
            return h1.timeTaken > h2.timeTaken
        }
        //NotificationCenter.default.post(name: pillTakenUpdateNotification, object: nil)
    }
    
    
    var pillHistoryData:[HistoryData] = [HistoryData]()
    var logoCache = [String:UIImage]()
    var drugUsageCache = [String:(String, JSON)] ()
    
}

struct PillHistoryKeys {
    static let name = "Name"
    static let calorieIntake = "Calories"
    static let timeTaken = "TimeTaken"
    static let actionStatement = "ActionStatement"
}

