//
//  UnfinishedViewController.swift
//  Memo
//
//  Created by hui on 16/5/18.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class UnfinishedViewController: BaseViewController, UITextFieldDelegate{
    
    struct NewItem{
        var firstLineFrame:CGRect!
        var firstLineView:MyRect!       //第一行视图
        var otherFrame:CGRect!
        var otherView:MyRect!           //第二三行视图
        var otherLimitFrame:CGRect!
        var otherLimitView:MyRect!      //用于限制第二三行的显示区域
        let addButton = UIButton()
        let addTextField = UITextField()
        let menuButton = UIButton()
        var isExpanded = false
        let levelLabel = UILabel()
        let levelBar = UIView()         //用于设置等级
        var levelButton = [UIButton]()
        let alertLabel = UILabel()
        let alertButton = UIButton()
        var data = ItemModel()
    }
    var newItem = NewItem()
    
    override func loadTableView() {
        self.dataArr = DatabaseService.sharedInstance.selectAllInDB().0
        super.loadTableView()
        self.loadNewItemView()
    }
    
    override func viewDidLoad() {
        isFinished = false
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadNewItem()
    }
    
    func loadNewItemView(){
        newItem.firstLineFrame = CGRectMake(8, 8, self.view.bounds.width - 16, 42)
        newItem.otherFrame = CGRectMake(0, -74, self.view.bounds.width - 16, 74)
        newItem.otherLimitFrame = CGRectMake(8, 40, self.view.bounds.width - 16, 74)
        newItem.firstLineView = MyRect(frame: newItem.firstLineFrame, color: UIColor(red: 254/255, green: 239/255, blue: 115/255, alpha: 1.0), withShadow: true)
        newItem.otherView = MyRect(frame: newItem.otherFrame)
        newItem.otherLimitView = MyRect(frame: newItem.otherLimitFrame, color: .clearColor(), withShadow: false)
        newItem.otherLimitView.clipsToBounds = true           //超出mainView范围的部分不显示
        
        newItem.addButton.setImage(UIImage(named: "加号"), forState: .Normal)
        newItem.addButton.frame = CGRectMake(11, 11, 20, 20)
        newItem.addButton.addTarget(self, action: "handleAddButton:", forControlEvents: .TouchDown)
        
        newItem.menuButton.setImage(UIImage(named: "三道杠"), forState: .Normal)
        newItem.menuButton.frame = CGRectMake(newItem.firstLineFrame.width-31, 11, 20, 20)
        newItem.menuButton.addTarget(self, action: Selector("newItemViewAnimation"), forControlEvents: .TouchDown)
        
        newItem.addTextField.frame = CGRectMake(42, 11, newItem.firstLineFrame.width-84, 20)
        newItem.addTextField.font = UIFont(name: "HelveticaNeue-Thin", size: 13.0)
        
        newItem.levelLabel.text = "添加星级"
        newItem.levelLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 13.0)
        newItem.levelLabel.frame = CGRectMake(11, 10, 120, 32)
        
        for i in 0..<5 {
            let button = UIButton()
            button.frame = CGRectMake(CGFloat.init(integerLiteral: 20 * i), 0, 15, 15)
            button.setImage(UIImage(named: "黄星"), forState: .Normal)
            button.setImage(UIImage(named: "黄星"), forState: .Highlighted)
            button.addTarget(self, action: Selector("setLevel:"), forControlEvents: .TouchDown)
            newItem.levelButton.append(button)
            newItem.levelBar.addSubview(button)
        }
        newItem.levelBar.frame = CGRectMake(newItem.otherLimitFrame.width-106, 19, 100, 32)
        
        newItem.alertLabel.text = "提醒时间"
        newItem.alertLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 13.0)
        newItem.alertLabel.frame = CGRectMake(11, 42, 120, 32)
        
        newItem.alertButton.setTitle("不提醒", forState: .Normal)
        newItem.alertButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 12.0)
        newItem.alertButton.setTitleColor(.blackColor(),forState: .Normal)
        newItem.alertButton.addTarget(self, action: Selector("selectDate"), forControlEvents: .TouchDown)
        newItem.alertButton.frame = CGRectMake(newItem.otherLimitFrame.width-108, 42, 100, 32)
        
        newItem.firstLineView.addSubview(newItem.addButton)
        newItem.firstLineView.addSubview(newItem.addTextField)
        newItem.firstLineView.addSubview(newItem.menuButton)
        
        newItem.otherView.addSubview(newItem.levelLabel)
        newItem.otherView.addSubview(newItem.levelBar)
        newItem.otherView.addSubview(newItem.alertLabel)
        newItem.otherView.addSubview(newItem.alertButton)
        
        newItem.otherLimitView.addSubview(newItem.otherView)
        self.view.addSubview(newItem.otherLimitView)
        self.view.addSubview(newItem.firstLineView)
        let tableViewFrame = CGRectMake(0, 54, self.view.bounds.width, self.view.bounds.height - 54)
        self.mainTableView.frame = tableViewFrame
    }
    
//    func textFieldShouldReturn(TextField: UITextField) -> Bool
//    {
//        self.newItem.addTextField.resignFirstResponder()
//        return true
//    }
    
    func setLevel(button:UIButton){
        let level = Int.init(button.frame.origin.x) / 20
        newItem.data.level = level
        for i in 0 ... level {
            newItem.levelButton[i].setImage(UIImage(named: "黄星"), forState: .Normal)
        }
        for i in level+1 ..< 5 {
            newItem.levelButton[i].setImage(UIImage(named: "灰星"), forState: .Normal)
        }
    }
    
    func handleAddButton(button:UIButton){
        if newItem.addTextField.text == ""{
            if !newItem.isExpanded{
                self.newItemViewAnimation()
            }
        }
        else{
            let formatter:NSDateFormatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            newItem.data.createTime = formatter.stringFromDate(NSDate())
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            newItem.data.lastEditTime = formatter.stringFromDate(NSDate())
            newItem.data.title = newItem.addTextField.text!
            self.insertData(newItem.data, withAnimation: true)
            self.reloadNewItem()
            //注册通知
//            if newItem.data.alertTime != ""{
//                let notification = UILocalNotification()
//                notification.fireDate = NSDate(timeIntervalSinceNow: 5)
//                notification.alertBody = "Hey you! Yeah you! Swipe to unlock!"
//                notification.alertAction = "be awesome!"
//                notification.soundName = UILocalNotificationDefaultSoundName
//                notification.userInfo = ["CustomField1": "w00t"]
//                UIApplication.sharedApplication().scheduleLocalNotification(notification)
//            }
        }
    }
    
    func reloadNewItem(){
        newItem.data = ItemModel()
        newItem.addTextField.text = ""
        for i in 0..<5 {
            newItem.levelButton[i].setImage(UIImage(named: "黄星"), forState: .Normal)
        }
        newItem.alertButton.setTitle("不提醒", forState: .Normal)
        if newItem.isExpanded{
            newItemViewAnimation()
        }
        self.view.bringSubviewToFront(self.mainTableView)
    }
    
    func selectDate() {
        let alertController:UIAlertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .ActionSheet)
        let datePicker = UIDatePicker()
        datePicker.locale = NSLocale(localeIdentifier: "zh_CN")
        datePicker.date = NSDate()
        alertController.addAction(UIAlertAction(title: "设置提醒", style: .Default){ (alertAction)->Void in
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            self.newItem.data.alertTime = formatter.stringFromDate(datePicker.date)
            self.newItem.alertButton.setTitle(self.newItem.data.alertTime, forState: .Normal)
        })
        alertController.addAction(UIAlertAction(title: "关闭提醒", style: .Default){ (alertAction)->Void in
            self.newItem.data.alertTime = ""
            self.newItem.alertButton.setTitle("不提醒", forState: .Normal)
        })
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel,handler:nil))
        alertController.view.addSubview(datePicker)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func newItemViewAnimation() -> Void
    {
        var y1:CGFloat = 64
        var y2:CGFloat = 74
        if self.newItem.isExpanded {
            y1 = 0
            y2 = 0
        }
        self.newItem.isExpanded = !self.newItem.isExpanded
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: {
            self.mainTableView.layer.setAffineTransform(CGAffineTransformMakeTranslation(0, y1))
            self.newItem.otherView.layer.setAffineTransform(CGAffineTransformMakeTranslation(0, y2))
            }, completion: { (finish:Bool) in
        })
    }
    
    //新建事件按钮（旧版）
//    func handleNewItem(){
//        let alert = UIAlertController(title: "创建任务", message: "", preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
//            textField.placeholder = "Title"
//        }
//        alert.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
//            textField.placeholder = "Content"
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
//                let formatterWithMs:NSDateFormatter = NSDateFormatter()
//                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                formatterWithMs.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
//                self.insertData(ItemModel(title: (alert.textFields?.first)!.text!, content: (alert.textFields?.last)!.text!, createTime: formatterWithMs.stringFromDate(NSDate()), lastEditTime: formatter.stringFromDate(NSDate()), alertTime: formatter.stringFromDate(NSDate()), level: 0, state: 0), withAnimation: true)
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
    
    //更新一条数据
    func updateData(data:ItemModel) -> Void {
        DatabaseService.sharedInstance.updateInDB(data)
        let url = "todolist/index.php/Home/Task/UpdateTask"
        let task = ["title":data.title, "content":data.content, "createtime":data.createTime, "lastedittime":data.lastEditTime, "alerttime":data.alertTime, "level":data.level, "state":data.state]
        let paramDict = ["UID":UserInfo.UID, "TaskModel":task]
        RequestAPI.POST(url, body: paramDict, succeed:{ (task:NSURLSessionDataTask!, responseObject:AnyObject?) -> Void in
            print("update")
            }) { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
        }
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
