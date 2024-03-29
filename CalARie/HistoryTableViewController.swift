//
//  HistoryTableViewController.swift
//  CalARie
//
//  Created by Brendon Ho on 9/22/17.
//  Copyright © 2017 Brendon Ho. All rights reserved.
//

import UIKit
import DeckTransition
import ScrollableGraphView
import Charts
import SwiftyJSON
class HistoryTableViewController:UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var histTable: UITableView!

    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var pieChartView : PieChartView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FoodManager.shared().pillHistoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryTableViewCell
        let item = FoodManager.shared().pillHistoryData[indexPath.row]
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "h:m a"
        let time = dateformatter.string(from: item.timeTaken)
        dateformatter.dateFormat = "E MMM d yyyy"
        let date = dateformatter.string(from: item.timeTaken)
        
        
        
        cell.food.text = item.foodName;
        cell.date.text = "\(time)\n\(date)"
        cell.calories.text = String(item.calories)
        cell.datNutritionData = item.nutrition
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "pop") as! PopUpViewController
        let selectedCell = self.histTable.cellForRow(at: indexPath) as! HistoryTableViewCell
        
        controller.nutritionData = selectedCell.datNutritionData
        self.histTable.deselectRow(at: indexPath, animated: true)
        self.present(controller, animated: true, completion: nil)
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        histTable.delegate = self
        var calorieSum = 0
        var basicJSON = JSON()
        //iterate, sum history and store in cache.
        var history = FoodManager.shared().pillHistoryData as [HistoryData]
        for historyData in 0..<history.count {
            let food = history[historyData] as HistoryData
            let nutrients = food.nutrition[0] as JSON
            /*
 
             calculate total calories
             
             */
            let date = food.timeTaken
            let twentyfourBefore = Date(timeIntervalSinceNow: -3600 * 24)
            if(date >= twentyfourBefore){
                calorieSum += food.calories
            }
            for (_, value) in nutrients.enumerated() {
                print(value)
                var nutrientData = value.1
                let name = value.0
                if(basicJSON[name].exists()){
                    print(nutrientData[0])
                    print(basicJSON[name][0])
                    var sum = Double(nutrientData[0].rawString()!)! + Double(basicJSON[name][0].rawString()!)!
                    basicJSON[name][0] = JSON(sum)
                }else{
                    print("setting to \(nutrientData[0])")
                    basicJSON[name] = nutrientData
                }
            }
        }
        print(basicJSON)
        total.text = String(calorieSum)
        
        //setup PieChart
       
        let chart = self.pieChartView!
        // 2. generate chart data entries
        var dailyAmounts = [String: Double]()
        dailyAmounts["Water"] = 2700
        dailyAmounts["Energy"] = 10500
        dailyAmounts["Protein"] = 56
        dailyAmounts["Total lipid (fat)"] = 70
        dailyAmounts["Carbohydrate, by difference"] = 310
        dailyAmounts["Sugars, total"] = 90
        dailyAmounts["Sodium, Na"] = 2.3 * 1000
        dailyAmounts["Fiber, total dietary"] = 30

        var entries = [PieChartDataEntry]()
        var objs = 0
        for (key, object) in basicJSON {
            objs += 1
            let entry = PieChartDataEntry()
            if let da = dailyAmounts[key] {
                entry.y = object[0].doubleValue / da
                entry.label = key
                if(entry.y > 0.05){
                    entries.append(entry)
                }
            }
            
        }
        
        // 3. chart setup
        let set = PieChartDataSet( values: entries, label: "Nutrients")
        // this is custom extension method. Download the code for more details.
        var colors: [UIColor] = []
        
        for _ in 0..<objs {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        set.colors = colors
        let data = PieChartData(dataSet: set)
        chart.data = data
        chart.noDataText = "No data available"
        // user interaction
        chart.isUserInteractionEnabled = true
        
        let d = Description()
        d.text = "CALARIE"
        chart.chartDescription = d
        chart.chartDescription?.textColor = .white
        chart.centerText = "Nutrients"
        chart.holeRadiusPercent = 0.2
        chart.transparentCircleColor = UIColor.clear
        chart.legend.textColor = .white
        
    }
    func tableViewDidScroll(_ tableView: UITableView) {
        guard tableView.isEqual(histTable) else {
            return
        }
        
        if let delegate = transitioningDelegate as? DeckTransitioningDelegate {
            if tableView.contentOffset.y > 0 {
                // Normal behaviour if the `scrollView` isn't scrolled to the top
                tableView.bounces = true
                delegate.isDismissEnabled = false
            } else {
                if tableView.isDecelerating {
                    // If the `scrollView` is scrolled to the top but is decelerating
                    // that means a swipe has been performed. The view and
                    // scrollviewʼs subviews are both translated in response to this.
                    view.transform = CGAffineTransform(translationX: 0, y: -tableView.contentOffset.y)
                    tableView.subviews.forEach {
                        $0.transform = CGAffineTransform(translationX: 0, y: tableView.contentOffset.y)
                    }
                } else {
                    // If the user has panned to the top, the scrollview doesnʼt bounce and
                    // the dismiss gesture is enabled.
                    tableView.bounces = false
                    delegate.isDismissEnabled = true
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "Poppop"){
            let projectionvc = segue.destination as! PopUpViewController
            
            let selectedIndexPath = self.histTable.indexPathForSelectedRow
            let selectedCell = self.histTable.cellForRow(at: selectedIndexPath!) as! HistoryTableViewCell
            
            projectionvc.nutritionData = selectedCell.datNutritionData
        }
        
    }
    

    
    
}
