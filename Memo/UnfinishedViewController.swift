//
//  UnfinishedViewController.swift
//  Memo
//
//  Created by hui on 16/5/18.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class UnfinishedViewController: BaseViewController{
    
    struct NewItem{
        var newItemFirstFrame:CGRect!
        var newItemFirstView:MyRect!
        var newItemFrame:CGRect!
        var newItemView:MyRect!
        let addButton = UIButton()
        let menuButton = UIButton()
        let addTextField = UITextField()
    }
    var newItem = NewItem()
    var isFirstShow = true
    
    override func loadTableView() {
        self.dataArr = DataBaseService.sharedInstance.selectAllInDB().0
        newItem.newItemFirstFrame = CGRectMake(0, 0, self.view.bounds.width - 16, 42)
        newItem.newItemFirstView = MyRect(frame: newItem.newItemFirstFrame, color: UIColor(red: 254/255, green: 239/255, blue: 115/255, alpha: 1.0))
        newItem.newItemFrame = CGRectMake(8, 8, self.view.bounds.width - 16, 42)
        newItem.newItemView = MyRect(frame: newItem.newItemFrame)
        newItem.newItemView.addSubview(newItem.newItemFirstView)
        newItem.addButton.setImage(UIImage(named: "new"), forState: .Normal)
        newItem.addButton.frame = CGRectMake(11, 11, 20, 20)
//        newItem.addButton.addTarget(self, action: <#T##Selector#>, forControlEvents: .TouchUpInside)
        newItem.menuButton.setImage(UIImage(named: "menu"), forState: .Normal)
        newItem.menuButton.frame = CGRectMake(newItem.newItemFirstFrame.width-31, 11, 20, 20)
        newItem.addTextField.frame = CGRectMake(42, 11, newItem.newItemFirstFrame.width-84, 20)
        newItem.newItemFirstView.addSubview(newItem.addButton)
        newItem.newItemFirstView.addSubview(newItem.addTextField)
        newItem.newItemFirstView.addSubview(newItem.menuButton)
        self.view.addSubview(newItem.newItemView)
        super.loadTableView()
        let tableViewFrame = CGRectMake(0, 54, self.view.bounds.width, self.view.bounds.height - 54)
        self.mainTableView.frame = tableViewFrame
    }
    
    override func viewDidLoad() {
        isFinished = false
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.dataArr = DataBaseService.sharedInstance.selectAllInDB().0
         UnfinishedVC.mainTableView.reloadData()
    }
    
    //新建事件按钮（旧版）
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
                hud.hideAnimated(true, afterDelay: 0.5)
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
                hud.hideAnimated(true, afterDelay: 0.5)
            }
        }))
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: {(UIAlertAction) in
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = MBProgressHUDMode.Text
            hud.label.text = "已取消"
            hud.hideAnimated(true, afterDelay: 0.5)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func updateData(data:ItemModel) -> Void {
        DataBaseService.sharedInstance.updateInDB(data)
        let index = findIndex(data.createTime)
        let row = rank(data.level, lastEditTime: data.lastEditTime)
        dataArr.removeAtIndex(index)
        dataArr.insert(data, atIndex: row)
        self.mainTableView.beginUpdates()
        self.mainTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .None)
        self.mainTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: row, inSection: 0)], withRowAnimation: .None)
        self.mainTableView.endUpdates()
    }

    //左滑更改level
//    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//        var levelArr:[UITableViewRowAction] = [UITableViewRowAction]()
//        for i in 0 ..< 4{
//            let level = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "") {
//                action, index in
//                self.dataArr[indexPath.row].level = i
//                let data:ItemModel = self.dataArr[indexPath.row]
//                self.removeData(row: indexPath.row)
//                self.insertData(data, withAnimation: true)
//            }
//            switch i{
//            case 0:
//                level.backgroundColor = UIColor(red: 254/255, green: 98/255, blue: 4/255, alpha: 1.0)
//            case 1:
//                level.backgroundColor = UIColor(red: 254/255, green: 228/255, blue: 4/255, alpha: 1.0)
//            case 2:
//                level.backgroundColor = UIColor(red: 75/255, green: 207/255, blue: 45/255, alpha: 1.0)
//            case 3:
//                level.backgroundColor = UIColor(red: 4/255, green: 163/255, blue: 254/255, alpha: 1.0)
//            default:
//                break
//            }
//            levelArr.append(level)
//        }
//        return levelArr
//    }
    
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
//                hud.hideAnimated(true, afterDelay: 0.5)
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
//                hud.hideAnimated(true, afterDelay: 0.5)
//            }
//        }))
//        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: {(UIAlertAction) in
//            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//            hud.mode = MBProgressHUDMode.Text
//            hud.label.text = "已取消"
//            hud.hideAnimated(true, afterDelay: 0.5)
//        }))
//        self.presentViewController(alert, animated: true, completion: nil)
//    }
    
}
