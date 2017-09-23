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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = nutView.dequeueReusableCell(withIdentifier: "NutCell")
        return cell!
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
