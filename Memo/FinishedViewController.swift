//
//  FinishedViewController.swift
//  Memo
//
//  Created by hui on 16/5/18.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class FinishedViewController: BaseViewController {
    
    override func loadData() {
        super.loadData()
        self.dataArr = self.selectAllInDB().1
    }
    
    override func viewDidLoad() {
        isFinished = true
        super.viewDidLoad()
    }
    
    //侧滑删除
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "删除") {
            action, index in
            self.removeData(row: indexPath.row)
        }]
    }
    
}
