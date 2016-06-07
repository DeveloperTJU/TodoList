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
        self.dataArr = DataBaseService.sharedInstance.selectAllInDB().1
    }
    
    override func viewDidLoad() {
        isFinished = true
        super.viewDidLoad()
    }
    
    //侧滑删除
//    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//        let deleteButton = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "") {
//            action, index in
//            self.removeData(row: indexPath.row)
//        }
//        UIGraphicsBeginImageContext(CGSize(width: 50, height: 50))
//        UIImage(named: "垃圾箱")!.drawInRect(CGRect(x: 15, y: 10, width: 30, height: 30))
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        deleteButton.backgroundColor = UIColor(patternImage: image)
//        return [deleteButton]
//    }
    
}
