//
//  LocationTitleViewController.swift
//  Geofencing
//
//  Created by shishir sapkota on 5/24/16.
//  Copyright © 2016 shishir sapkota. All rights reserved.
//

import UIKit

protocol RegionNameDelegate {
    func AddRegionTitle(title: String, description: String)
}

class LocationTitleViewController: UIViewController {
    
    
    var delegate: RegionNameDelegate? = nil
    var message = ""
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let btnSave = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(LocationTitleViewController.save))
        self.navigationItem.rightBarButtonItem = btnSave
        // Do any additional setup after loading the view.
    }
    func save(){
        var invitationTitle = ""
        var invitationDescription = ""
        
        if let title = txtTitle.text{
            invitationTitle = title
            self.navigationController?.popViewControllerAnimated(true)
        }
        if let description = txtDescription.text{
            invitationDescription = description
        }
        delegate?.AddRegionTitle(invitationTitle, description: invitationDescription)
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
