//
//  GoogleAPIManager.swift
//  CalARie
//
//  Created by Ivan Chau on 9/22/17.
//  Copyright © 2017 Brendon Ho. All rights reserved.
//
import Foundation
import UIKit
import SwiftyJSON

class GoogleAPIManager {
    
    var googleAPIKey = "AIzaSyByivg-aBj5AYJHzWWWbWfcioFM4Vcmgbw"
    var googleURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
    }
    let session = URLSession.shared
    
    static var sharedInstance: GoogleAPIManager = {
        let apiManager = GoogleAPIManager()
        
        return apiManager
    }()
    
    class func shared() -> GoogleAPIManager {
        return sharedInstance
    }
    
    func identifyDrug(image: UIImage, completionHandler:@escaping (((itemName: String, instructions: String, maximum: JSON)?) -> ())) {
        // Base64 encode the image and create the request
        let binaryImagePacket = base64EncodeImage(image)
        
        //FIX ME
        createRequest(with: binaryImagePacket, completionHandler: completionHandler)
    }
    
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    func base64EncodeImage(_ image: UIImage) -> (String, CGSize) {
        var imagedata = UIImagePNGRepresentation(image)!
        
        // Resize the image if it exceeds the 2MB API limit
        if (imagedata.count > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        
        return (imagedata.base64EncodedString(options: .endLineWithCarriageReturn), image.size)
    }
    
    func createRequest(with imageBase64: (String, CGSize), completionHandler: @escaping (((itemName: String, instructions: String, maximum: JSON)?) -> ())) {
        // Create our request URL
        
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": imageBase64.0
                ],
                "features": [
                    [
                        "type": "LOGO_DETECTION",
                        "maxResults": 3
                    ],
                    [
                        "type": "WEB_DETECTION",
                        "maxResults": 3
                    ]
                    
                ]
            ]
        ]
        
        
        let jsonObject = JSON(jsonRequest)
        
        // Serialize the JSON
        guard let data = try? jsonObject.rawData() else {
            return
        }
        
        request.httpBody = data
        
        // Run the request on a background thread
        DispatchQueue.global().async {
            let task: URLSessionDataTask = self.session.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "")
                    return
                }
                print("4----------------")
                
                DispatchQueue.main.async(execute: {
                    print("5----------------")
                    
                    // Use SwiftyJSON to parse results
                    let json = JSON(data: data)
                    let errorObj: JSON = json["error"]
                    if (errorObj.dictionaryValue != [:]) {
                        print("Error code \(errorObj["code"]): \(errorObj["message"])")
                    }
                    var responses: [String] = []
                    if let logoResults = json["responses"][0]["logoAnnotations"].array, logoResults.count > 0 {
                        for item in logoResults{
                            if let description = item["description"].string {
                                responses.append(description)
                            }
                        }
                    }
                    
                    if let webEntities = json["responses"][0]["webDetection"]["webEntities"].array, webEntities.count > 0 {
                        for item in webEntities {
                            if let description = item["description"].string {
                                responses.append(description)
                            }
                        }
                    }
                    let apiManager = NutritionAPIManager.shared()
                    var calls = 0
                    // Call hasura api for each result from Google
                    responses = responses.map {
                        $0.replacingOccurrences(of: " ", with: "-")
                    }
                    var lowestResponseNum = 1000
                    var lowestResponse: (classification: String, data: JSON)? = nil
                    for response in responses {
                        let handler = {
                            (data: (classification: String, data: JSON)?) in
                            if data != nil {
                                let responseIndex = responses.index(of: response)
                                print("Response: \(responseIndex) \(response)")
                                if responseIndex! <= lowestResponseNum {
                                    lowestResponseNum = responseIndex!
                                    lowestResponse = data
                                }
                            }
                            calls += 1
                            if calls == responses.count {
                                if lowestResponseNum == 1000{
                                    
                                    completionHandler(nil)
                                }else{
                                    print("FINAL RESULT")
                                    print("7----------------")
                                    completionHandler((responses[lowestResponseNum], lowestResponse!.classification, lowestResponse!.data))
                                    
                                }
                            }
                        }
                        
                        // For each item returned by Google, get its usage information
                        //                        apiManager.getUsageForDrug("\(response)", completionHandler: { (response) in
                        //                            if response != nil{
                        //
                        //                            }
                        //                        })
                        apiManager.getInfoFromFood("\(response)", completionHandler: handler)
                    }
                    
                })
            }
            
            task.resume()
        }
    }
    
    
    func distanceFromPointToCenterSize(p1:CGPoint, s2:CGSize) -> Double {
        let midSize = CGPoint(x: s2.width / 2, y: s2.height / 2)
        let xDist = p1.x - midSize.x
        let yDist = p1.y - midSize.y
        return Double(sqrt(xDist * xDist + yDist * yDist))
    }
    
    
}

