//
//  NutritionAPIManager.swift
//  CalARie
//
//  Created by Ivan Chau on 9/22/17.
//  Copyright © 2017 Brendon Ho. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class NutritionAPIManager {
    //key : 3C6hpqd584ozuRiyC4uZtZqTViLRBoXbEyZl0iRp

    var nutritionURL: URL {
        return URL(string: "https://api.nal.usda.gov/ndb/search/?format=json&ds=Standard%20Reference&sort=r&api_key=3C6hpqd584ozuRiyC4uZtZqTViLRBoXbEyZl0iRp")!
    }
    let session = URLSession.shared
    
    static var sharedInstance: NutritionAPIManager = {
        let apiManager = NutritionAPIManager()
        
        return apiManager
    }()
    
    class func shared() -> NutritionAPIManager {
        return sharedInstance
    }
    
    func getInfoFromFood(_ food: String, completionHandler: @escaping (((classification: String, information : JSON)?) ->())) {
        print("Getting usages for \(food)")
        if  FoodManager.shared().drugUsageCache[food.lowercased()] != nil {
            print("Cache Hit !!!!!")
            let cachedResult = FoodManager.shared().drugUsageCache[food.lowercased()]
            completionHandler(cachedResult)
            return
        }
        
        // Create our request URL
        var request = URLRequest(url: URL(string : nutritionURL.absoluteString + "&q=" + food.lowercased())!)
        
        print(request.url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Run the request on a background thread
        DispatchQueue.global().async {
            let task: URLSessionDataTask = self.session.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "")
                    completionHandler(nil)
                    return
                }
                
                DispatchQueue.main.async(execute: {
                    // Use SwiftyJSON to parse results
                    let json = JSON(data: data)
                    let errorObj: JSON = json["error"]
                    if (errorObj.dictionaryValue != [:]) {
                        print("Error code \(errorObj["code"]): \(errorObj["message"])")
                        completionHandler(nil)
                        return
                    }
                    var classification: String = "No instructions could be found"
                    
                    if (!json["errors"].exists()) {
                        var item = json["list"]["item"][0]
                        classification = item["name"].string!
                        var ndbno = item["ndbno"].string!
                        print(ndbno)
                        var facts = self.getNutritionFacts(b: ndbno)
                        FoodManager.shared().drugUsageCache[food.lowercased()] = (classification,facts)
                        print("6----------------")
                        completionHandler((classification,facts))
                        return
                    }else{
                        completionHandler(nil)
                        return
                    }
                    
                })
            }
            task.resume()
        }
    }
    func getNutritionFacts(b : String) {
        print("testing with " + b);
        var request = URLRequest(url: URL(string:"https://api.nal.usda.gov/ndb/reports/?ndbno=" + b + "&type=b&format=json&api_key=3C6hpqd584ozuRiyC4uZtZqTViLRBoXbEyZl0iRp")!)
        DispatchQueue.global().async {
            let task: URLSessionDataTask = self.session.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "")
                    return
                }
                
                DispatchQueue.main.async(execute: {
                    // Use SwiftyJSON to parse results
                    let json = JSON(data: data)
                    let errorObj: JSON = json["error"]
                    if (errorObj.dictionaryValue != [:]) {
                        print("Error code \(errorObj["code"]): \(errorObj["message"])")
                        return
                    }
                    return json
                    
                })
            }
            task.resume()
        }
    }
    
    func getLogoForDrug( drug: String, completionHandler: @escaping (UIImage)-> ()){
        if let cachedImage = FoodManager.shared().logoCache[drug.lowercased()]{
            completionHandler(cachedImage)
            return
        }
        
        Alamofire.request(nutritionURL.appendingPathComponent("logo/\(drug)")).responseJSON { (response) in
            if let json = response.data {
                let data = JSON(data: json)
                print(data)
                if let urlStr = data["url"].string{
                    let url = URL(string: urlStr)!
                    self.downloadImage(url: url, searchTerm: drug, completionHandler: completionHandler)
                }
            }
            
        }
        
        
    }
    
    func downloadImage(url: URL, searchTerm:String, completionHandler:@escaping (UIImage)->()) {
        print("Download Started")
        print(url)
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            //            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            if let image =  UIImage(data: data){
                FoodManager.shared().logoCache[searchTerm.lowercased()] = image
                DispatchQueue.main.async() { () -> Void in
                    completionHandler(image)
                }
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
}
