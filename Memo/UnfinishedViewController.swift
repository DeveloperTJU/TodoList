//
//  UnfinishedViewController.swift
//  Memo
//
//  Created by hui on 16/5/18.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class UnfinishedViewController: BaseViewController{
    
    override func loadData() {
        super.loadData()
        self.dataArr = self.selectAllInDB().0
    }
    
    override func loadTableView() {
        let newItemFirstFrame = CGRectMake(0, 0, self.view.bounds.width - 16, 42)
        let newItemFirstView = MyRect(frame: newItemFirstFrame, color: UIColor(red: 254/255, green: 239/255, blue: 115/255, alpha: 1.0))
        let newItemFrame = CGRectMake(8, 8, self.view.bounds.width - 16, 42)
        let newItemView = MyRect(frame: newItemFrame)
        newItemView.addSubview(newItemFirstView)
        self.view.addSubview(newItemView)
        super.loadTableView()
        let tableViewFrame = CGRectMake(0, 54, self.view.bounds.width, self.view.bounds.height - 54)
        self.mainTableView.frame = tableViewFrame
        
//        let 
    }
    
    override func viewDidLoad() {
        isFinished = false
        super.viewDidLoad()
    }
    
    //新建事件按钮
    func handleNewItem(){
        let alert = UIAlertController(title: "创建任务", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "Title"
        }
        alert.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "Content"
        }
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction) in
            if (alert.textFields?.first)!.text == ""{
                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                hud.mode = MBProgressHUDMode.Text
                hud.label.text = "请输入标题"
                hud.hideAnimated(true, afterDelay: 1.5)
            }
            else{
                let formatter:NSDateFormatter = NSDateFormatter()
                let formatterWithMs:NSDateFormatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                formatterWithMs.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                self.insertData(ItemModel(title: (alert.textFields?.first)!.text!, content: (alert.textFields?.last)!.text!, createTime: formatterWithMs.stringFromDate(NSDate()), lastEditTime: formatter.stringFromDate(NSDate()), alertTime: formatter.stringFromDate(NSDate()), level: 0, state: 0), withAnimation: true)
                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                hud.mode = MBProgressHUDMode.Text
                hud.label.text = "完成"
                hud.hideAnimated(true, afterDelay: 1.5)
            }
        }))
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: {(UIAlertAction) in
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = MBProgressHUDMode.Text
            hud.label.text = "已取消"
            hud.hideAnimated(true, afterDelay: 1.5)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    //左滑更改level
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        var levelArr:[UITableViewRowAction] = [UITableViewRowAction]()
        for i in 0 ..< 4{
            let level = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "") {
                action, index in
                self.dataArr[indexPath.row].level = i
                let data:ItemModel = self.dataArr[indexPath.row]
                self.removeData(row: indexPath.row)
                self.insertData(data, withAnimation: true)
            }
            switch i{
            case 0:
                level.backgroundColor = UIColor(red: 254/255, green: 98/255, blue: 4/255, alpha: 1.0)
            case 1:
                level.backgroundColor = UIColor(red: 254/255, green: 228/255, blue: 4/255, alpha: 1.0)
            case 2:
                level.backgroundColor = UIColor(red: 75/255, green: 207/255, blue: 45/255, alpha: 1.0)
            case 3:
                level.backgroundColor = UIColor(red: 4/255, green: 163/255, blue: 254/255, alpha: 1.0)
            default:
                break
            }
            levelArr.append(level)
        }
        return levelArr
    }
    
    //Cell点击事件，编辑事件。
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let alert = UIAlertController(title: "编辑任务", message: "", preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
//            textField.placeholder = "Title"
//            textField.text = self.dataArr[indexPath.row].title
//        }
//        alert.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
//            textField.placeholder = "Content"
//            textField.text = self.dataArr[indexPath.row].content
//        }
//        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction) in
//            if (alert.textFields?.first)!.text == ""{
//                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                hud.mode = MBProgressHUDMode.Text
//                hud.label.text = "请输入标题"
//                hud.hideAnimated(true, afterDelay: 1.5)
//            }
//            else{
//                let formatter:NSDateFormatter = NSDateFormatter()
//                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                let data = ItemModel(title: (alert.textFields?.first)!.text!, content: (alert.textFields?.last)!.text!, createTime: self.dataArr[indexPath.row].createTime, lastEditTime: self.dataArr[indexPath.row].lastEditTime, alertTime: self.dataArr[indexPath.row].alertTime, level: self.dataArr[indexPath.row].level, state: self.dataArr[indexPath.row].state)
//                self.removeData(row: indexPath.row)
//                self.insertData(data, withAnimation: true)
//                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                hud.mode = MBProgressHUDMode.Text
//                hud.label.text = "完成"
//                hud.hideAnimated(true, afterDelay: 1.5)
//            }
//        }))
//        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: {(UIAlertAction) in
//            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//            hud.mode = MBProgressHUDMode.Text
//            hud.label.text = "已取消"
//            hud.hideAnimated(true, afterDelay: 1.5)
//        }))
//        self.presentViewController(alert, animated: true, completion: nil)
//    }
    
}
