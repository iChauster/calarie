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
        
        pillHistoryData.append(HistoryData(foodName: "Zyrtec", maxDailyDosage: 1, todayDose: 1, timeTaken: dateFormatter.date(from: "09-02-2017 6:23:30 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Ester-c", maxDailyDosage: 1, todayDose: 1, timeTaken: dateFormatter.date(from: "09-02-2017 13:35:23 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Tums", maxDailyDosage: 7, todayDose: 1, timeTaken: dateFormatter.date(from: "09-02-2017 15:05:49 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Zyrtec", maxDailyDosage: 1, todayDose: 1, timeTaken: dateFormatter.date(from: "09-03-2017 6:20:15 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Ester-c", maxDailyDosage: 1, todayDose: 1, timeTaken: dateFormatter.date(from: "09-03-2017 13:15:02 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Zyrtec", maxDailyDosage: 1, todayDose: 1, timeTaken: dateFormatter.date(from: "09-04-2017 12:02:01 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Ester-c", maxDailyDosage: 1, todayDose: 1, timeTaken: dateFormatter.date(from: "09-04-2017 13:45:00 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Zyrtec", maxDailyDosage: 1, todayDose: 1, timeTaken: dateFormatter.date(from: "09-05-2017 13:45:06 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Ester-c", maxDailyDosage: 1, todayDose: 1, timeTaken: dateFormatter.date(from: "09-05-2017 12:55:06 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Zyrtec", maxDailyDosage: 1, todayDose: 1, timeTaken: dateFormatter.date(from: "09-06-2017 7:45:06 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Tylenol", maxDailyDosage: 4, todayDose: 1, timeTaken: dateFormatter.date(from: "09-06-2017 17:31:25 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Pepto-Bismol", maxDailyDosage: 7, todayDose: 1, timeTaken: dateFormatter.date(from: "09-07-2017 2:22:22 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Pepto-Bismol", maxDailyDosage: 7, todayDose: 2, timeTaken: dateFormatter.date(from: "09-07-2017 6:27:32 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Zyrtec", maxDailyDosage: 1, todayDose: 1, timeTaken: dateFormatter.date(from: "09-07-2017 6:28:56 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Pepto-Bismol", maxDailyDosage: 7, todayDose: 3, timeTaken: dateFormatter.date(from: "09-07-2017 11:57:35 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Pepto-Bismol", maxDailyDosage: 7, todayDose: 5, timeTaken: dateFormatter.date(from: "09-07-2017 15:10:47 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Pepto-Bismol", maxDailyDosage: 7, todayDose: 5, timeTaken: dateFormatter.date(from: "09-07-2017 18:21:02 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Zyrtec", maxDailyDosage: 1, todayDose: 1, timeTaken: dateFormatter.date(from: "09-08-2017 9:03:07 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Ester-c", maxDailyDosage: 1, todayDose: 1, timeTaken: dateFormatter.date(from: "09-08-2017 13:17:55 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Advil", maxDailyDosage: 6, todayDose: 1, timeTaken: dateFormatter.date(from: "09-09-2017 7:15:11 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Zyrtec", maxDailyDosage: 6, todayDose: 1, timeTaken: dateFormatter.date(from: "09-09-2017 8:35:51 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Alka-Seltzer", maxDailyDosage: 5, todayDose: 1, timeTaken: dateFormatter.date(from: "09-09-2017 9:00:01 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Advil", maxDailyDosage: 6, todayDose: 2, timeTaken: dateFormatter.date(from: "09-09-2017 11:15:35 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Advil", maxDailyDosage: 6, todayDose: 3, timeTaken: dateFormatter.date(from: "09-09-2017 15:53:26 EST")!, actionStatement: "YOU MAY NEED TO REFILL SOON"))
        pillHistoryData.append(HistoryData(foodName: "Alka-Seltzer", maxDailyDosage: 5, todayDose: 2, timeTaken: dateFormatter.date(from: "09-09-2017 19:20:01 EST")!))
        pillHistoryData.append(HistoryData(foodName: "Centrum", maxDailyDosage: 1, todayDose: 1, timeTaken: dateFormatter.date(from: "09-10-2017 2:34:38 EST")!))
        
        pillHistoryData.sort { (h1, h2) -> Bool in
            return h1.timeTaken > h2.timeTaken
        }
    }
    
    
    
    func addPillHistory(drugName: String, maxDailyDosage:Int, timeTaken:Date = Date()){
        let pillHistory = HistoryData(foodName: drugName, maxDailyDosage: maxDailyDosage, timeTaken: timeTaken, calculateTodayDose: true)
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
    static let dailyDosageMax = "DailyDosageMax"
    static let dailyDosage = "DailyDosage"
    static let timeTaken = "TimeTaken"
    static let actionStatement = "ActionStatement"
}

