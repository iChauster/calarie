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

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
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
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
       
      
        pillHistoryData.append(HistoryData(foodName: "Bagel", calories: 256, timeTaken: dateFormatter.date(from: "09-22-2017 11:23:30")!))
        pillHistoryData.append(HistoryData(foodName: "Orange", calories: 44, timeTaken: dateFormatter.date(from: "09-22-2017 11:56:23")!))
        pillHistoryData.append(HistoryData(foodName: "Apple", calories: 52, timeTaken: dateFormatter.date(from: "09-22-2017 11:57:43")!))
        pillHistoryData.append(HistoryData(foodName: "Bannana", calories: 47, timeTaken: dateFormatter.date(from: "09-23-2017 01:35:23")!))
        pillHistoryData.append(HistoryData(foodName: "Water", calories: 0, timeTaken: dateFormatter.date(from: "09-23-2017 01:45:45")!))
        pillHistoryData.append(HistoryData(foodName: "Bottled Water", calories: 1, timeTaken: dateFormatter.date(from: "09-23-2017 01:47:23")!))
        pillHistoryData.append(HistoryData(foodName: "Milk", calories: 103, timeTaken: dateFormatter.date(from: "09-23-2017 10:01:57")!))
        pillHistoryData.append(HistoryData(foodName: "Pizza", calories: 285, timeTaken: dateFormatter.date(from: "09-23-2017 10:05:32")!))
        pillHistoryData.append(HistoryData(foodName: "Bread", calories: 79, timeTaken: dateFormatter.date(from: "09-23-2017 12:05:53")!))
        pillHistoryData.append(HistoryData(foodName: "Bagel", calories: 256, timeTaken: dateFormatter.date(from: "09-23-2017 12:34:12")!))
        pillHistoryData.append(HistoryData(foodName: "Water", calories: 0, timeTaken: dateFormatter.date(from: "09-23-2017 12:47:17")!))
        pillHistoryData.append(HistoryData(foodName: "Pizza", calories: 234, timeTaken: dateFormatter.date(from: "09-23-2017 13:00:59")!))
        pillHistoryData.append(HistoryData(foodName: "Yellow", calories: 53, timeTaken: dateFormatter.date(from: "09-23-2017 13:05:14")!))
        pillHistoryData.append(HistoryData(foodName: "Apple", calories: 42, timeTaken: dateFormatter.date(from: "09-23-2017 13:07:46")!))
        pillHistoryData.append(HistoryData(foodName: "Coffee", calories: 1, timeTaken: dateFormatter.date(from: "09-23-2017 13:14:59")!))
        pillHistoryData.append(HistoryData(foodName: "Tea", calories: 2, timeTaken: dateFormatter.date(from: "09-23-2017 13:16:57")!))
        var str = "[\n  {\n    \"Sodium, Na\" : [\n      \"505\",\n      \"mg\"\n    ],\n    \"Energy\" : [\n      \"278\",\n      \"kcal\"\n    ],\n    \"Magnesium, Mg\" : [\n      \"25\",\n      \"mg\"\n    ],\n    \"Iron, Fe\" : [\n      \"3.98\",\n      \"mg\"\n    ],\n    \"Fatty acids, total polyunsaturated\" : [\n      \"0.642\",\n      \"g\"\n    ],\n    \"Phosphorus, P\" : [\n      \"84\",\n      \"mg\"\n    ],\n    \"Zinc, Zn\" : [\n      \"0.77\",\n      \"mg\"\n    ],\n    \"Water\" : [\n      \"32.70\",\n      \"g\"\n    ],\n    \"Vitamin A, RAE\" : [\n      \"33\",\n      \"µg\"\n    ],\n    \"Fatty acids, total saturated\" : [\n      \"0.421\",\n      \"g\"\n    ],\n    \"Vitamin A, IU\" : [\n      \"109\",\n      \"IU\"\n    ],\n    \"Riboflavin\" : [\n      \"0.235\",\n      \"mg\"\n    ],\n    \"Protein\" : [\n      \"10.60\",\n      \"g\"\n    ],\n    \"Thiamin\" : [\n      \"0.536\",\n      \"mg\"\n    ],\n    \"Niacin\" : [\n      \"3.443\",\n      \"mg\"\n    ],\n    \"Vitamin B-6\" : [\n      \"0.087\",\n      \"mg\"\n    ],\n    \"Fatty acids, total monounsaturated\" : [\n      \"0.420\",\n      \"g\"\n    ],\n    \"Total lipid (fat)\" : [\n      \"2.10\",\n      \"g\"\n    ],\n    \"Potassium, K\" : [\n      \"68\",\n      \"mg\"\n    ],\n    \"Vitamin C, total ascorbic acid\" : [\n      \"0.6\",\n      \"mg\"\n    ],\n    \"Calcium, Ca\" : [\n      \"13\",\n      \"mg\"\n    ],\n    \"Vitamin B-12\" : [\n      \"0.16\",\n      \"µg\"\n    ],\n    \"Cholesterol\" : [\n      \"24\",\n      \"mg\"\n    ],\n    \"Fiber, total dietary\" : [\n      \"2.3\",\n      \"g\"\n    ],\n    \"Carbohydrate, by difference\" : [\n      \"53.00\",\n      \"g\"\n    ],\n    \"Folate, DFE\" : [\n      \"134\",\n      \"µg\"\n    ]\n  }\n]"
        
        if let dataFromString = str.data(using: .utf8, allowLossyConversion: false) {
            let nutritionFacts = JSON(data: dataFromString)
            pillHistoryData.append(HistoryData(foodName: "Bagel", calories: 24, timeTaken: dateFormatter.date(from: "09-24-2017 13:16:57")!, nutrition : nutritionFacts))
            
        }
   
        pillHistoryData.sort { (h1, h2) -> Bool in
            return h1.timeTaken > h2.timeTaken
        }
    }
    
    
    
    func addPillHistory(foodName: String, calories:Int, nutrition : JSON, timeTaken:Date = Date()){
        let pillHistory = HistoryData(foodName: foodName, calories: calories, timeTaken: timeTaken, calculateTodayDose: true, nutrition : nutrition)
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
    static let nutrition = "Nutrition"
}

