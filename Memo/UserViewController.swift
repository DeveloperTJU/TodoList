//
//  UserViewController.swift
//  Memo
//
//  Created by hui on 16/5/25.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    var currentUser:String = "root"
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.title = "用户"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
