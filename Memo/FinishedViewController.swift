//
//  FinishedViewController.swift
//  Memo
//
//  Created by hui on 16/5/18.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class FinishedViewController: BaseViewController {
    
    override func loadTableView() {
        self.dataArr = DataBaseService.sharedInstance.selectAllInDB().1
        super.loadTableView()
    }
    
    override func viewDidLoad() {
        isFinished = true
        super.viewDidLoad()
    }
    
}
