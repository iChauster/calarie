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
        var str = "[\n  {\n    \"Sodium, Na\" : \"474\",\n    \"Energy\" : \"24\",\n    \"Magnesium, Mg\" : \"15\",\n    \"Iron, Fe\" : \"0.96\",\n    \"Fatty acids, total polyunsaturated\" : \"0.121\",\n    \"Fatty acids, total trans\" : \"0.000\",\n    \"Phosphorus, P\" : \"27\",\n    \"Zinc, Zn\" : \"0.22\",\n    \"Caffeine\" : \"0\",\n    \"Water\" : \"91.28\",\n    \"Vitamin A, RAE\" : \"22\",\n    \"Vitamin A, IU\" : \"435\",\n    \"Vitamin D\" : \"0\",\n    \"Fatty acids, total saturated\" : \"0.041\",\n    \"Vitamin K (phylloquinone)\" : \"2.8\",\n    \"Riboflavin\" : \"0.065\",\n    \"Protein\" : \"1.20\",\n    \"Thiamin\" : \"0.024\",\n    \"Niacin\" : \"0.991\",\n    \"Vitamin B-6\" : \"0.098\",\n    \"Fatty acids, total monounsaturated\" : \"0.045\",\n    \"Total lipid (fat)\" : \"0.30\",\n    \"Potassium, K\" : \"297\",\n    \"Sugars, total\" : \"3.56\",\n    \"Vitamin C, total ascorbic acid\" : \"7.0\",\n    \"Vitamin D (D2 + D3)\" : \"0.0\",\n    \"Calcium, Ca\" : \"14\",\n    \"Vitamin B-12\" : \"0.00\",\n    \"Vitamin E (alpha-tocopherol)\" : \"1.44\",\n    \"Cholesterol\" : \"0\",\n    \"Fiber, total dietary\" : \"1.5\",\n    \"Carbohydrate, by difference\" : \"5.31\",\n    \"Folate, DFE\" : \"9\"\n  }\n]"
        
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

