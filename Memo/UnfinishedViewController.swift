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
        var mainView:UIView!            //父视图
        var firstLineView:MyRect!       //第一行视图
        var otherView:MyRect!           //第二三行视图
        var otherLimitView:MyRect!      //用于限制第二三行的显示区域
        let addButton = UIButton()
        let addTextField = UITextField()
        let menuButton = UIButton()
        var isExpanded = false          //记录当前展开状态
        let levelLabel = UILabel()
        let levelBar = UIView()         //用于设置等级
        var levelButton = [UIButton]()
        var originPos:CGPoint!
        let alertLabel = UILabel()
        let alertButton = UIButton()
        var data = ItemModel()
    }
    var newItem = NewItem()
    var tap:UITapGestureRecognizer!
    
    override func loadTableView() {
        self.dataArr = DatabaseService.sharedInstance.selectAllInDB().0
        super.loadTableView()
        self.loadNewItemView()
    }
    
    override func viewDidLoad() {
        isFinished = false
        super.viewDidLoad()
        newItem.addTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadNewItem()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        self.mainTableView.removeGestureRecognizer(tap)
        self.addNewTask()
        if newItem.isExpanded{
            self.newItemAnimation()
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.returnKeyType = .Done
        self.mainTableView.addGestureRecognizer(tap)
        if !newItem.isExpanded{
            self.newItemAnimation()
        }
    }
    
    func hideKeyboard(){
        self.newItem.addTextField.resignFirstResponder()
        self.mainTableView.removeGestureRecognizer(tap)
    }
    
    func loadNewItemView(){
        let mainFrame = CGRectMake(8, 8, self.view.bounds.width - 16, 54)
        let firstLineFrame = CGRectMake(8, 8, self.view.bounds.width - 16, 42)
        let otherFrame = CGRectMake(0, -74, self.view.bounds.width - 16, 74)
        let otherLimitFrame = CGRectMake(8, 40, self.view.bounds.width - 16, 74)
        
        newItem.mainView = UIView(frame: mainFrame)
        newItem.mainView.backgroundColor = .clearColor()
        newItem.firstLineView = MyRect(frame: firstLineFrame, color: UIColor(red: 254/255, green: 239/255, blue: 115/255, alpha: 1.0), withShadow: true)
        newItem.otherView = MyRect(frame: otherFrame)
        newItem.otherLimitView = MyRect(frame: otherLimitFrame, color: .clearColor(), withShadow: false)
        newItem.otherLimitView.clipsToBounds = true           //超出mainView范围的部分不显示
        
        newItem.addButton.setImage(UIImage(named: "加号"), forState: .Normal)
        newItem.addButton.frame = CGRectMake(0, 0, 42, 42)
        newItem.addButton.imageEdgeInsets = UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 11)
        newItem.addButton.addTarget(self, action: "handleAddButton:", forControlEvents: .TouchDown)
        
        newItem.menuButton.setImage(UIImage(named: "三道杠"), forState: .Normal)
        newItem.menuButton.frame = CGRectMake(firstLineFrame.width-42, 0, 42, 42)
        newItem.menuButton.imageEdgeInsets = UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 11)
        newItem.menuButton.addTarget(self, action: Selector("newItemAnimation"), forControlEvents: .TouchDown)
        
        newItem.addTextField.frame = CGRectMake(42, 11, firstLineFrame.width-84, 20)
        newItem.addTextField.attributedPlaceholder = NSAttributedString(string: "添加任务...", attributes: [NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName : UIFont(name: "HelveticaNeue-Thin", size: 13)!])
        
        newItem.levelLabel.text = "添加星级"
        newItem.levelLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 13.0)
        newItem.levelLabel.frame = CGRectMake(11, 10, 120, 32)
        
        for i in 0..<5 {
            let button = UIButton()
            button.frame = CGRectMake(CGFloat.init(integerLiteral: 20 * i), 0, 20, 32)
            button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 2, bottom: 8, right: 2)
            button.setImage(UIImage(named: "黄星"), forState: .Normal)
            button.setImage(UIImage(named: "黄星"), forState: .Highlighted)
            button.addTarget(self, action: Selector("setLevel:"), forControlEvents: .TouchDown)
            newItem.levelButton.append(button)
            newItem.levelBar.addSubview(button)
        }
        newItem.levelBar.frame = CGRectMake(otherLimitFrame.width-106, 10, 100, 32)
        newItem.levelBar.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: Selector("changeLevel:")))
        
        newItem.alertLabel.text = "提醒时间"
        newItem.alertLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 13.0)
        newItem.alertLabel.frame = CGRectMake(11, 42, 120, 32)
        
        newItem.alertButton.setTitle("不提醒", forState: .Normal)
        newItem.alertButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 12.0)
        newItem.alertButton.setTitleColor(.blackColor(),forState: .Normal)
        newItem.alertButton.addTarget(self, action: Selector("selectDate"), forControlEvents: .TouchDown)
        newItem.alertButton.frame = CGRectMake(otherLimitFrame.width-106, 42, 100, 32)
        
        newItem.firstLineView.addSubview(newItem.addButton)
        newItem.firstLineView.addSubview(newItem.addTextField)
        newItem.firstLineView.addSubview(newItem.menuButton)
        
        newItem.otherView.addSubview(newItem.levelLabel)
        newItem.otherView.addSubview(newItem.levelBar)
        newItem.otherView.addSubview(newItem.alertLabel)
        newItem.otherView.addSubview(newItem.alertButton)
        
        newItem.otherLimitView.addSubview(newItem.otherView)
        newItem.mainView.addSubview(newItem.otherLimitView)
        newItem.mainView.addSubview(newItem.firstLineView)
        tap = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.newItem.isExpanded ? 118 : 54
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return newItem.mainView
    }
    
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
    
    func changeLevel(gesture:UIPanGestureRecognizer){
        switch gesture.state{
        case .Began:
            self.newItem.originPos = gesture.locationInView(self.newItem.levelBar)
        case .Changed:
            let level = Int.init(self.newItem.originPos.x + gesture.translationInView(self.newItem.levelBar).x) / 20
            if level >= 0 && level < 5{
                for i in 0 ... level{
                    newItem.levelButton[i].setImage(UIImage(named: "黄星"), forState: .Normal)
                }
                if level < 4{
                    for i in level+1 ..< 5{
                        newItem.levelButton[i].setImage(UIImage(named: "灰星"), forState: .Normal)
                    }
                }
            }
        case .Ended:
            self.newItem.data.level = Int.init(self.newItem.originPos.x + gesture.translationInView(self.newItem.levelBar).x) / 20
        default:
            break
        }
    }
    
    func handleAddButton(button:UIButton){
        if !self.addNewTask() && !newItem.isExpanded{
            self.newItemAnimation()
            self.newItem.addTextField.becomeFirstResponder()
        }
    }
    
    func addNewTask() -> Bool{
        if newItem.addTextField.text != ""{
            let dateTime = formatter.stringFromDate(NSDate())
            newItem.data.createTime = dateTime
            newItem.data.lastEditTime = dateTime
            newItem.data.timestamp = dateTime
            newItem.addTextField.resignFirstResponder()
            newItem.data.title = newItem.addTextField.text!
            self.insertData(newItem.data, withAnimation: true)
            if newItem.data.alertTime != ""{
                let notification = UILocalNotification()
                let formatter = NSDateFormatter()
                formatter.locale = NSLocale(localeIdentifier: "zh_CN")
                formatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm")
                notification.fireDate = formatter.dateFromString(self.newItem.data.alertTime)
                notification.alertBody = self.newItem.data.title
                notification.alertAction = "be awesome!"
                notification.soundName = UILocalNotificationDefaultSoundName
                notification.userInfo = ["详情": self.newItem.data.content]
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            }
            self.reloadNewItem()
            self.mainTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.findIndex(dateTime), inSection: 0), atScrollPosition: .Top, animated: true)
            return true
        }
        return false
    }
    
    func reloadNewItem(){
        newItem.data = ItemModel()
        newItem.addTextField.text = ""
        for i in 0..<5 {
            newItem.levelButton[i].setImage(UIImage(named: "黄星"), forState: .Normal)
        }
        newItem.alertButton.setTitle("不提醒", forState: .Normal)
        if newItem.isExpanded{
            newItemAnimation()
        }
        self.view.bringSubviewToFront(self.mainTableView)
    }
    
    func selectDate() {
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .ActionSheet)
        let alertTimeFormatter = NSDateFormatter()
        alertTimeFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let datePicker = UIDatePicker()
        datePicker.frame = CGRectMake(0, 0, alertController.view.bounds.width-25, 200)
        datePicker.locale = NSLocale(localeIdentifier: "zh_CN")
        datePicker.date = newItem.data.alertTime == "" ? NSDate() : alertTimeFormatter.dateFromString(newItem.data.alertTime)!
        alertController.addAction(UIAlertAction(title: "设置提醒", style: .Default){ (alertAction)->Void in
            self.newItem.data.alertTime = alertTimeFormatter.stringFromDate(datePicker.date)
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
    
    func newItemAnimation() -> Void
    {
        let y:CGFloat = self.newItem.isExpanded ? 0 : 74
        self.newItem.isExpanded = !self.newItem.isExpanded
        let height:CGFloat = self.newItem.isExpanded ? 118 : 54
        self.mainTableView.beginUpdates()
        self.newItem.mainView.frame = CGRectMake(0, 0, self.view.bounds.width, height)
        self.mainTableView.endUpdates()
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: {
            self.mainTableView.beginUpdates()
            self.newItem.otherView.layer.setAffineTransform(CGAffineTransformMakeTranslation(0, y))
            self.mainTableView.endUpdates()
        }, completion: { (finish:Bool) in
        })
    }
    
}
