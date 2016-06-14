//
//  UnfinishedController.swift
//  Memo
//
//  Created by hui on 16/5/18.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class CustomNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = UIColor(red: 254/255, green: 239/255, blue: 115/255, alpha: 1.0)
        self.navigationBar.translucent = false
        self.navigationBar.tintColor = .blackColor()
        let attr = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 16.0)!]
        UIBarButtonItem.appearance().setTitleTextAttributes(attr, forState: .Normal)
        self.navigationBar.titleTextAttributes = attr
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
