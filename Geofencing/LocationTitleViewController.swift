//
//  LocationTitleViewController.swift
//  Geofencing
//
//  Created by shishir sapkota on 5/24/16.
//  Copyright © 2016 shishir sapkota. All rights reserved.
//

import UIKit

protocol RegionNameDelegate {
    func AddRegionTitle(title: String)
}

class LocationTitleViewController: UIViewController {
    
    var delegate: RegionNameDelegate? = nil
    var message = ""
    @IBOutlet weak var txtTitle: UITextField!
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        let btnSave = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(LocationTitleViewController.save))
        self.navigationItem.rightBarButtonItem = btnSave
        // Do any additional setup after loading the view.
    }
    func save(){
        if let title = txtTitle.text{
            delegate?.AddRegionTitle(title)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
