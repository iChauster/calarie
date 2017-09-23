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
class HistoryTableViewController:UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var histTable: UITableView!
    @IBOutlet weak var total: UIView!
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
        performSegue(withIdentifier: "Poppop", sender: self)
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        histTable.delegate = self
        
        total.layer.cornerRadius = 10
        
        //setup PieChart
        
        let chart = self.pieChartView
        // 2. generate chart data entries
        let track = ["Income", "Expense", "Wallet", "Bank"]
        let money = [650, 456.13, 78.67, 856.52]
        
        var entries = [PieChartDataEntry]()
        for (index, value) in money.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = value
            entry.label = track[index]
            entries.append( entry)
        }
        
        // 3. chart setup
        let set = PieChartDataSet( values: entries, label: "Pie Chart")
        // this is custom extension method. Download the code for more details.
        var colors: [UIColor] = []
        
        for _ in 0..<money.count {
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
        d.text = "iOSCharts.io"
        chart.chartDescription = d
        chart.centerText = "Pie Chart"
        chart.holeRadiusPercent = 0.2
        chart.transparentCircleColor = UIColor.clear
        
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
