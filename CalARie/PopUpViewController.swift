//
//  PopUpViewController.swift
//  CalARie
//
//  Created by Brendon Ho on 9/23/17.
//  Copyright © 2017 Brendon Ho. All rights reserved.
//

import UIKit
import SwiftyJSON
class PopUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var nutView: UITableView!
    var order = ["Energy","Cholesterol","Total lipid (fat)", "Sodium, Na", "Sugars, total", "Protein", "Carbohydrate, by difference", "Fiber, total dietary", "Vitamin D (D2 + D3)", "Calcium, Ca", "Iron, Fe", "Potassium, K"]
    var dailyAmounts = [String: Double]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return order.count
        
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = nutView.dequeueReusableCell(withIdentifier: "NutCell") as! PopupViewCell
        let item = order[indexPath.row]

        cell.key.text = item
        if(nutritionData[0][item].exists()){
            cell.val.text = String(describing: nutritionData[0][item][0].string!) + String(describing: nutritionData[0][item]   [1].string!)
            let value = Double(nutritionData[0][item][0].string!)
            if let da = dailyAmounts[item] {
                let doub = value! / da
                let p = round(100.0 * doub) / 100.0
                cell.percentage.text = String(p)
            }else{
                cell.percentage.text = "0%"
            }
        }else{
            cell.val.text = "0.0"
            cell.percentage.text = "0%"
        }

        return cell
    }
    
    @IBOutlet weak var popView: UIView!
    var nutritionData : JSON!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(nutritionData)
        self.nutView.estimatedRowHeight = 100
        self.nutView.rowHeight = UITableViewAutomaticDimension
        popView.layer.cornerRadius = 15
        let gest = UISwipeGestureRecognizer(target: self, action: #selector(dis))
        gest.direction = .down;
        self.view.addGestureRecognizer(gest);
        dailyAmounts["Water"] = 2700
        dailyAmounts["Energy"] = 10500
        dailyAmounts["Protein"] = 56
        dailyAmounts["Total lipid (fat)"] = 70
        dailyAmounts["Carbohydrate, by difference"] = 310
        dailyAmounts["Sugars, total"] = 90
        dailyAmounts["Sodium, Na"] = 2.3 * 1000
        dailyAmounts["Fiber, total dietary"] = 30
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   @objc func dis(){
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
