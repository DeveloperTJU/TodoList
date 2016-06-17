//
//  BaseViewController.swift
//  Memo
//
//  Created by hui on 16/5/18.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, ItemCellDelegate, RequestClientDelegate {
    
    let cellIdentifier:String = "ItemCell"
    var mainTableView:UITableView!
    var dataArr:[ItemModel]!                //数据源
    var isFinished:Bool!                    //表示当前标签页是"已完成"还是"未完成"。
    var userButtonImage = UIImageView()
    var userButtonTitle = UILabel()
    var isFirstLoad = true
    let formatter = NSDateFormatter()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.loadTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadTableView()
    }
    
    convenience init(title:String){
        self.init()
        self.title = title
    }
    
    //在初始化时添加TableView以在尚未加载视图时存取dataArr数据。
    func loadTableView() {
        let tableViewFrame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height - 69)
        self.mainTableView = UITableView(frame: tableViewFrame, style: .Plain)
        self.mainTableView.backgroundColor = .whiteColor()
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        let cellNib = UINib(nibName: "ItemCell", bundle: nil)
        self.mainTableView.registerNib(cellNib, forCellReuseIdentifier: cellIdentifier)
        self.mainTableView.tableFooterView = UIView()
        self.view.addSubview(self.mainTableView)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        self.mainTableView.backgroundColor = .clearColor()
        self.mainTableView.separatorStyle = .None
        formatter.locale = NSLocale(localeIdentifier: "zh_CN")
        formatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm:ss.SSS")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        if UserInfo.phoneNumber != "Visitor"{
            let refresher = MJRefreshNormalHeader()
            refresher.setRefreshingTarget(self, refreshingAction: Selector("refreshManually"))
            self.mainTableView.mj_header = refresher
            refresher.stateLabel?.font = UIFont.systemFontOfSize(11)
            refresher.lastUpdatedTimeLabel?.font = UIFont.systemFontOfSize(11)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //添加导航栏按钮
        let refreshButton = UIBarButtonItem(image: UIImage(named: "更新"), style: .Plain, target: self, action: Selector("refreshManually"))
        let searchButton = UIBarButtonItem(image: UIImage(named: "搜索"), style: .Plain, target: self, action: Selector("search"))
        searchButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -25)
        let userButton = UIButton(type: .Custom)
        userButton.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width / 2 - 40, 30)
        userButtonImage.frame = CGRectMake(0, 0, 30, 30)
        userButtonTitle.frame = CGRectMake(35, 0, userButton.frame.size.width - 35, 30)
        userButtonTitle.font = UIFont(name: "HelveticaNeue-Thin", size: 13.0)!
        userButtonTitle.textAlignment = .Left
        userButtonImage.layer.masksToBounds = true
        userButtonImage.layer.cornerRadius = 15
        userButton.addSubview(userButtonImage)
        userButton.addSubview(userButtonTitle)
        PersonalCenterController.loadAvatarImg()
        var image = UIImage(named: (NSHomeDirectory() as String).stringByAppendingFormat("/Documents/\(UserInfo.phoneNumber.md5).jpg"))
        if image == nil || UserInfo.phoneNumber == "Visitor"{
            image = UIImage(named: "默认头像小")
        }
        let scale = image!.size.width > image!.size.height ? image!.size.height/80 : image!.size.width/80
        UserInfo.avatar = UIImage(CGImage: image!.CGImage!, scale: scale, orientation: .Up)
        userButton.addTarget(self, action: Selector("userInfo:"), forControlEvents: .TouchDown)
        let userBarButton = UIBarButtonItem(customView: userButton)
        
        //调节导航栏控件间隔
        let spacer1 = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil,
            action: nil)
        spacer1.width = -5
        let spacer2 = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil,
            action: nil)
        spacer2.width = -5
        
        self.navigationItem.leftBarButtonItems = [spacer1, userBarButton]
        self.navigationItem.rightBarButtonItems = [spacer2, refreshButton, searchButton]
    }
    
    //刷新上次编辑时间和头像昵称
    override func viewWillAppear(animated: Bool) {
        if isFirstLoad{
            isFirstLoad = false
        }
        else{
            for i in 0 ..< self.dataArr.count {
                if let cell = self.mainTableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as? ItemCell {
                    cell.timeLabel.text = friendlyTime(dataArr[i].lastEditTime)
                }
            }
        }
        self.setUserAvatarImage()
    }
    
    func setUserAvatarImage(){
        userButtonImage.image = UserInfo.avatar
        userButtonTitle.text = UserInfo.nickname == "" ? UserInfo.phoneNumber : UserInfo.nickname
    }
    
    //搜索页
    func search(){
        let searchVC = SearchViewController()
        searchVC.hidesBottomBarWhenPushed = true
        self.navigationController!.pushViewController(searchVC,animated:true)
    }
    
    //个人中心页
    func userInfo(sender: UIButton){
        sender.highlighted = false
        let vc = PersonalCenterController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //手动同步
    func refreshManually(){
        if UserInfo.phoneNumber == "Visitor" {
            let alert = UIAlertController(title: "提示", message: "同步功能需要登录后才能使用，是否立即前往登录？", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "取消", style: .Default, handler: nil))
            alert.addAction(UIAlertAction(title: "确定", style: .Default, handler:{ (UIAlertAction) in
                UserInfo = UserInfoStruct()
                self.presentViewController(LogInViewController(), animated: true, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            RequestClient.sharedInstance.delegate = self
            RequestAPI.SynchronizeTask(1)
        }
    }
    
    //显示友好时间戳，参考自http://blog.csdn.net/zhyl8157121/article/details/42155921
    func friendlyTime(dateTime: String) -> String {
        if let date = formatter.dateFromString(dateTime) {
            let delta = NSDate().timeIntervalSinceDate(date)
            if (delta > 0 && delta <= 60) {
                return "刚刚"
            }
            else if (delta > 60 && delta < 3600) {
                return "\(Int(delta / 60))分钟前"
            }
            else {
                let calendar = NSCalendar.currentCalendar()
                let unitFlags:NSCalendarUnit = [.Year,.Month,.Day,.Hour,.Minute]
                
                let comp = calendar.components(unitFlags, fromDate: NSDate())
                let currentYear = String(comp.year)
                let currentMonth = String(comp.month)
                let currentDay = String(comp.day)
                
                let comp2 = calendar.components(unitFlags, fromDate: date)
                let year = String(comp2.year)
                let month = String(comp2.month)
                let day = String(comp2.day)
                var hour = String(comp2.hour)
                var minute = String(comp2.minute)
                
                if comp2.hour < 10 {
                    hour = "0" + hour
                }
                if comp2.minute < 10 {
                    minute = "0" + minute
                }
                if currentYear == year {
                    if currentMonth == month && currentDay == day {
                        return "\(hour):\(minute)"
                    }
                    else {
                        return "\(month)/\(day)"
                    }
                }
                else {
                    return "\(year)/\(month)/\(day)"
                }
            }
        }
        return ""
    }
    
    func reloadDatabase(){
        let arrs = DatabaseService.sharedInstance.selectAllInDB()
        UnfinishedVC.mainTableView.beginUpdates()
        UnfinishedVC.dataArr = arrs.0
        UnfinishedVC.mainTableView.deleteSections(NSIndexSet(index: 0), withRowAnimation: .None)
        UnfinishedVC.mainTableView.insertSections(NSIndexSet(index: 0), withRowAnimation: .None)
        for i in 0 ..< arrs.0.count{
            UnfinishedVC.mainTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: i, inSection: 0)], withRowAnimation: .None)
        }
        UnfinishedVC.mainTableView.endUpdates()
        FinishedVC.mainTableView.beginUpdates()
        FinishedVC.dataArr = arrs.1
        FinishedVC.mainTableView.deleteSections(NSIndexSet(index: 0), withRowAnimation: .None)
        FinishedVC.mainTableView.insertSections(NSIndexSet(index: 0), withRowAnimation: .None)
        for i in 0 ..< arrs.1.count{
            FinishedVC.mainTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: i, inSection: 0)], withRowAnimation: .None)
        }
        FinishedVC.mainTableView.endUpdates()
        self.setUserAvatarImage()
    }
    
    //通过创建时间找到索引，无则返回-1。
    internal func findIndex(createTime:String) -> Int{
        var row = 0
        for i in self.dataArr{
            if i.createTime == createTime{
                return row
            }
            row += 1
        }
        return -1
    }
    
    //返回给定任务的索引，插入数据时调用。
    internal func rank(level:Int, lastEditTime:String) -> Int {
        var index:Int = 0
        for item in self.dataArr{
            if level < item.level{
                index += 1
            }
            else if level == item.level && lastEditTime < item.lastEditTime{
                index += 1
            }
            else{
                break
            }
        }
        return index
    }
    
    //使用插入排序的方式插入数据，使得cell按照优先级与最后编辑时间排序。
    func insertData(data:ItemModel, withAnimation hasAnimation:Bool){
        let index = rank(data.level, lastEditTime: data.lastEditTime)
        data.state = (isFinished! ? 2 : 0)
        if DatabaseService.sharedInstance.insertInDB(data){
            let url = "index.php/Home/Task/AddTask"
            let task = ["title":data.title, "content":data.content, "createtime":data.createTime, "lastedittime":data.lastEditTime, "timestamp":data.timestamp, "alerttime":data.alertTime, "level":data.level, "state":data.state]
            let paramDict = ["UID":UserInfo.UID, "TaskModel":task]
            RequestAPI.POST(url, body: paramDict, succeed:{ (task:NSURLSessionDataTask!, responseObject:AnyObject?) -> Void in
            }) { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
            }
            if data.alertTime != ""{
                self.addNotification(data)
            }
            dataArr.insert(data, atIndex: index)
            self.mainTableView.beginUpdates()
            self.mainTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: hasAnimation ? .Automatic : .None)
            self.mainTableView.endUpdates()
        }
        else{
            data.state = (isFinished! ? 0 : 2)
            print("数据库操作失败")
        }
    }
    
    //删除指定位置的数据，单刷视图。
    func removeData(row index:Int){
        let temp = self.dataArr[index].timestamp
        self.dataArr[index].state += 1
        self.dataArr[index].timestamp = formatter.stringFromDate(NSDate())
        if DatabaseService.sharedInstance.updateInDB(self.dataArr[index]){
            let time = self.dataArr[index].createTime
            let url = "index.php/Home/Task/DeleteTask"
            let paramDict = ["UID":UserInfo.UID, "createtime":self.dataArr[index].createTime, "timestamp":self.dataArr[index].timestamp]
            RequestAPI.POST(url, body: paramDict, succeed:{ (task:NSURLSessionDataTask!, responseObject:AnyObject?) -> Void in
                let resultDict = try! NSJSONSerialization.JSONObjectWithData(responseObject as! NSData, options: NSJSONReadingOptions.MutableContainers)
                if resultDict["isSuccess"] as! Bool {
                    DatabaseService.sharedInstance.deleteInDB(time)
                }
            }) { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
            }
            if dataArr[index].alertTime != ""{
                self.removeNotification(dataArr[index].createTime)
            }
            dataArr.removeAtIndex(index)
            self.mainTableView.beginUpdates()
            self.mainTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .None)
            self.mainTableView.endUpdates()
        }
        else{
            self.dataArr[index].state -= 1
            self.dataArr[index].timestamp = temp
            print("数据库操作失败")
        }
    }
    
    func updateInServer(data:ItemModel) -> Void{
        let url = "index.php/Home/Task/UpdateTask"
        let task = ["title":data.title, "content":data.content, "createtime":data.createTime, "lastedittime":data.lastEditTime, "timestamp":data.timestamp, "alerttime":data.alertTime, "level":data.level, "state":data.state]
        let paramDict = ["UID":UserInfo.UID, "TaskModel":task]
        RequestAPI.POST(url, body: paramDict, succeed:{ (task:NSURLSessionDataTask!, responseObject:AnyObject?) -> Void in
        }) { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
        }
    }
    
    //更新一条数据
    func updateData(data:ItemModel) -> Void {
        let index = findIndex(data.createTime)
        let temp = dataArr[index].timestamp
        data.timestamp = formatter.stringFromDate(NSDate())
        if DatabaseService.sharedInstance.updateInDB(data){
            self.updateInServer(data)
            if dataArr[index].alertTime != ""{
                self.removeNotification(dataArr[index].createTime)
            }
            if data.alertTime != ""{
                self.addNotification(data)
            }
            self.mainTableView.beginUpdates()
            dataArr.removeAtIndex(index)
            self.mainTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .None)
            let row = rank(data.level, lastEditTime: data.lastEditTime)
            dataArr.insert(data, atIndex: row)
            self.mainTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: row, inSection: 0)], withRowAnimation: .None)
            self.mainTableView.endUpdates()
        }
        else{
            print("数据库操作失败")
            dataArr[index].timestamp = temp
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    //设置Cell属性
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) ->UITableViewCell{
        let cell:ItemCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ItemCell
        let item = self.dataArr[indexPath.row]
        cell.titleLabel.text = item.title
        cell.timeLabel.text = friendlyTime(item.lastEditTime)
        cell.createTime = item.createTime
        cell.selectionStyle = .None
        cell.stateButton.setImage(UIImage(named: "完成"), forState: isFinished! ? .Highlighted : .Normal)
        cell.stateButton.setImage(UIImage(named: "完成选中"), forState: isFinished! ? .Normal : .Highlighted)
        cell.delegate = self
        return cell
    }
    
    //Cell高度固定50
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    //点击Cell打开详情页
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let editVC = EditViewController()
        editVC.currentList = dataArr[indexPath.row]
        editVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    //侧滑删除
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .Destructive, title: "  ") {
            action, index in
            self.removeData(row: indexPath.row)
        }
        let image = UIImage(CGImage: (UIImage(named: "垃圾箱")?.CGImage)!, scale: 2.5, orientation: .Up)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 40, height: 40), false, 1.0)
        image.drawInRect(CGRectMake(5, 13, 25, 25))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        deleteButton.backgroundColor = UIColor(patternImage: newImage)
        return [deleteButton]
    }
    
    //切换已完成/未完成状态
    func switchState(button:UIButton, createTime:String){
        var row = findIndex(createTime)
        let data = self.dataArr[row]
        let temp = data.timestamp
        let another = (isFinished! ? UnfinishedVC : FinishedVC)
        var message = (isFinished! ? "已恢复" : "已完成")
        data.state = (isFinished! ? 0 : 2)
        self.dataArr[row].timestamp = formatter.stringFromDate(NSDate())
        if DatabaseService.sharedInstance.updateInDB(data){
            self.updateInServer(data)
            if data.alertTime != ""{
                if isFinished!{
                    self.addNotification(data)
                }
                else{
                    self.removeNotification(createTime)
                }
            }
            self.dataArr.removeAtIndex(row)
            self.mainTableView.beginUpdates()
            self.mainTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: row, inSection: 0)], withRowAnimation: .Automatic)
            self.mainTableView.endUpdates()
            row = another.rank(data.level, lastEditTime: data.lastEditTime)
            another.dataArr.insert(data, atIndex: row)
            another.mainTableView.beginUpdates()
            another.mainTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: row, inSection: 0)], withRowAnimation: .None)
            another.mainTableView.endUpdates()
        }
        else{
            message = "操作失败，请重试"
            print("数据库操作失败")
            self.dataArr[row].state = (isFinished! ? 2 : 0)
            self.dataArr[row].timestamp = temp
        }
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = MBProgressHUDMode.Text
        hud.label.text = message
        hud.hideAnimated(true, afterDelay: 0.5)
    }
    
    func addNotification(data:ItemModel) -> Void{
        let notification = UILocalNotification()
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "zh_CN")
        formatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm")
        notification.fireDate = formatter.dateFromString(data.alertTime)
        notification.alertBody = "任务提醒：\(data.title)"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["time": data.createTime]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func removeNotification(createTime:String) -> Void{
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            let userInfoCurrent = notification.userInfo! as! [String:AnyObject]
            if userInfoCurrent["time"]! as! String == createTime {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                break;
            }
        }
    }
}