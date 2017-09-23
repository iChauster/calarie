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
    
    @IBOutlet weak var histTable: UITableView!
    
    @IBOutlet weak var total: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        histTable.delegate = self
        
        total.layer.cornerRadius = 10
        
        
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
