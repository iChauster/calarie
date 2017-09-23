//
//  HistoryTableViewController.swift
//  CalARie
//
//  Created by Brendon Ho on 9/22/17.
//  Copyright © 2017 Brendon Ho. All rights reserved.
//

import UIKit
import DeckTransition

class HistoryTableViewController:UIViewController, UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell")
        
        return cell!
    }
    
    @IBOutlet weak var histTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        histTable.delegate = self
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
    
    
}
