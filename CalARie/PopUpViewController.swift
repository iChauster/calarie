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
    var order = ["Energy","Cholesterol","Fatty acids, total staturated", "Sodium, Na", "Sugars, total", "Protein", "Carbohydrate, by difference", "Fiber", "Vitamin D (D2 + D3)", "Calcium, Ca", "Iron, Fe", "Potassium"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return order.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = nutView.dequeueReusableCell(withIdentifier: "NutCell") as! PopupViewCell
        let item = order[indexPath.row]
<<<<<<< HEAD
        cell.key.text = item
        cell.val.text = nutritionData[0][item].string
=======
        
        cell.key.text = nutritionData[0][item].string
        
>>>>>>> 015f6339481e49e51ddd8c388f6812f6f9b53cba
        return cell
    }
    
    @IBOutlet weak var popView: UIView!
    var nutritionData : JSON!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(nutritionData)
        
        popView.layer.cornerRadius = 15
        let gest = UISwipeGestureRecognizer(target: self, action: #selector(dis))
        gest.direction = .down;
        self.view.addGestureRecognizer(gest);
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
