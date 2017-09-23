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
        
        pillHistoryData.append(HistoryData(foodName: "Zyrtec", calories: 1, timeTaken: dateFormatter.date(from: "09-02-2017 6:23:30 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Ester-c", calories: 1, timeTaken: dateFormatter.date(from: "09-02-2017 13:35:23 EST")!))
   
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

