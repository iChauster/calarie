//
//  HistoryData.swift
//  CalARie
//
//  Created by Ivan Chau on 9/22/17.
//  Copyright © 2017 Brendon Ho. All rights reserved.
//


import UIKit
import SwiftyJSON
class HistoryData: NSObject {
    
    var foodName: String = ""
    var calories: Int = 0
    var timeTaken: Date = Date()
    var actionStatement: String = ""
    var nutrition : JSON = JSON.null;
    init(foodName: String, calories:Int = 4, timeTaken: Date = Date(), actionStatement: String = "", calculateTodayDose:Bool = false, nutrition : JSON = JSON.null){
        super.init()
        self.foodName = foodName
        self.calories = calories
        self.timeTaken = timeTaken
        self.actionStatement = actionStatement
        self.nutrition = nutrition;
    }
    
    static func calculateTakenToday(foodName: String) -> Int{
        var similarPills = [HistoryData]()
        for pill in FoodManager.shared().pillHistoryData {
            if pill.foodName.lowercased() == foodName.lowercased(){
                similarPills.append(pill)
            }
        }
        
        var sameDay = 0
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        for history in similarPills{
            if dateFormatter.string(from: history.timeTaken) == dateFormatter.string(from: Date()){
                sameDay += 1
            }
        }
        return sameDay
    }
    
    func toDictionary()->[String:Any]{
        return [PillHistoryKeys.name: self.foodName, PillHistoryKeys.calorieIntake: self.calories, PillHistoryKeys.timeTaken: self.timeTaken, PillHistoryKeys.nutrition : self.nutrition]
    }
    
    init(dictionary: [String:Any]) {
        if let name = dictionary[PillHistoryKeys.name] as? String{
            self.foodName = name
        }
        if let calories = dictionary[PillHistoryKeys.calorieIntake] as? Int{
            self.calories = calories
        }
        if let timeTaken = dictionary[PillHistoryKeys.timeTaken] as? Date{
            self.timeTaken = timeTaken
        }
        if let actionStatment = dictionary[PillHistoryKeys.actionStatement] as? String{
            self.actionStatement = actionStatment
        }
        if let nutrition = dictionary[PillHistoryKeys.nutrition] as? String{
            self.nutrition = JSON(nutrition)
        }
    }
    
    
}

