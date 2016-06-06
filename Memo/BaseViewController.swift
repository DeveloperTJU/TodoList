//
//  BaseViewController.swift
//  Memo
//
//  Created by hui on 16/5/18.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    
    let cellIdentifier:String = "ItemCell"
    var mainTableView:UITableView!
    private var originConstant: CGFloat = 0
    var dataArr:[ItemModel]!
    var isFinished:Bool!    //表示当前标签页是"已完成"还是"未完成"。
    var dataBase:FMDatabase!
    var dbQueue:FMDatabaseQueue!
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.loadData()
        self.loadTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadData()
        self.loadTableView()
    }
    
    convenience init(title:String){
        self.init()
        self.title = title
    }
    
    //从数据库读入数据
    func loadData(){
        self.dataBase = DataBaseService.getDataBase()
        self.dbQueue = DataBaseService.getDataBaseQueue()
        
        //CGAffineTransformIdentity
        //MJRefresh
        
        self.dataBase.open()
        var sqlStr = "DROP TABLE IF EXISTS data_\(UserVC.currentUser.md5)"
        self.dataBase.executeUpdate(sqlStr, withArgumentsInArray: [])
        sqlStr = "CREATE TABLE IF NOT EXISTS data_\(UserVC.currentUser.md5)(TITLE TEXT, CONTENT TEXT, CREATE_TIME TEXT, LAST_EDIT_TIME TEXT, ALERT_TIME TEXT, LEVEL INT, STATE INT, PRIMARY KEY(CREATE_TIME))"
        self.dataBase.executeUpdate(sqlStr, withArgumentsInArray: [])
        sqlStr = "INSERT INTO data_\(UserVC.currentUser.md5) VALUES (?, ?, ?, ?, ?, ?, ?)"
        self.dataBase.executeUpdate(sqlStr, withArgumentsInArray: ["task1", "no content1", "2016-05-27 12:01:00", "2016-05-27 12:01:00", "2017-05-27 12:01:00", 1, 4])
        self.dataBase.executeUpdate(sqlStr, withArgumentsInArray: ["task2", "no content2", "2016-05-27 12:02:01", "2016-05-27 12:02:01", "2017-05-27 12:02:01", 1, 4])
        self.dataBase.executeUpdate(sqlStr, withArgumentsInArray: ["task3", "no content3", "2016-05-27 12:03:02", "2016-05-27 12:03:02", "2017-05-27 12:03:02", 1, 0])
        self.dataBase.executeUpdate(sqlStr, withArgumentsInArray: ["task4", "no content4", "2016-05-27 12:04:03", "2016-05-27 12:04:03", "2017-05-27 12:04:03", 1, 0])
        self.dataBase.executeUpdate(sqlStr, withArgumentsInArray: ["task5", "no content5", "2016-05-27 12:05:02", "2016-05-27 12:05:02", "2017-05-27 12:05:02", 1, 1])
        self.dataBase.executeUpdate(sqlStr, withArgumentsInArray: ["task6", "no content6", "2016-05-27 12:06:00", "2016-05-27 12:06:00", "2017-05-27 12:06:00", 1, 1])
        self.dataBase.close()
    }
    
    //在初始化时添加TableView以在尚未加载视图时存取数据。
    func loadTableView() {
        let tableViewFrame:CGRect = self.view.bounds
        self.mainTableView = UITableView(frame: tableViewFrame, style: UITableViewStyle.Plain)
        self.mainTableView.backgroundColor = UIColor.whiteColor()
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        let cellNib = UINib(nibName: "ItemCell", bundle: nil)
        self.mainTableView.registerNib(cellNib, forCellReuseIdentifier: cellIdentifier)
        self.mainTableView.tableFooterView = UIView()
        self.view.addSubview(self.mainTableView)
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background")!.drawInRect(CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        self.mainTableView.backgroundColor = UIColor.clearColor()
        self.mainTableView.separatorStyle = .None
//        let panGesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
//        panGesture.delegate = self
//        self.mainTableView.addGestureRecognizer(panGesture)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshButton = UIBarButtonItem(image: RootTabBarController.compressImage(image: UIImage(named: "refresh")!, toSize: CGSizeMake(20, 20)), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("refreshManually"))
        let searchButton = UIBarButtonItem(image: RootTabBarController.compressImage(image: UIImage(named: "search")!, toSize: CGSizeMake(20, 20)), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("search"))
        let button = UIButton(type: .System)
        button.frame = CGRectMake(0, 0, 120, 35)
        button.setImage(RootTabBarController.compressImage(image: UIImage(named: "finished_selected")!, toSize: CGSizeMake(25, 25)), forState: .Normal)
        button.imageForState(.Highlighted)
        button.setTitle("Username", forState: .Normal)
        button.addTarget(self, action: Selector("userInfo:"), forControlEvents: .TouchUpInside)
        let userButton = UIBarButtonItem(customView: button)
        
        //用于消除左边空隙，要不然按钮顶不到最前面
        let spacer = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil,
            action: nil)
        spacer.width = -20;
        
        self.navigationItem.rightBarButtonItems = [refreshButton, searchButton]
        self.navigationItem.leftBarButtonItems = [spacer, userButton]
//        let baseURL = NSURL(string: "http://10.1.33.164")
//        let manager = AFHTTPSessionManager(baseURL: baseURL)
//        let paramDict = ["user_phoneNumber":"18222773726", "user_psw":"nihao"]
//        manager.POST("todolist/index.php/Home/User/Login", parameters: paramDict, success: {(task:NSURLSessionDataTask, responseObject:AnyObject?) -> Void in
//                print("Succeed")
//            }, failure: {(task:NSURLSessionDataTask?, error:NSError?) -> Void in
//                print("Failed:\(error)")
//        })
        
    }
    
    func search(){
        
    }
    
    func userInfo(sender: UIButton){
        
    }
    
    func refreshManually(){
        
    }
    
    func handlePan(gesture:UIPanGestureRecognizer){
        let touchPoint = gesture.locationInView(self.mainTableView)
        let indexPath = self.mainTableView.indexPathForRowAtPoint(touchPoint)
        let currentItem = self.dataArr[indexPath!.row]
        print("touchPoint:\(touchPoint)")
//        switch gesture.state{
////        case .Began:
//        case .Began:
//            originConstant = self.mainTableView.cellForRowAtIndexPath(indexPath!)
//        case .Changed:
//            let translation = gesture.translationInView(self.mainTableView)
//            self.mainTableView.cellForRowAtIndexPath(indexPath!).constant = translation.x
//            
//            // 划动移动1/3宽度为有效划动
//            let finished = fabs(translation.x) > CGRectGetWidth(bounds) / 3
//            if translation.x < originConstant { // 右划
//                if finished {
//                    deleteOnDragRelease = true
//                    rightLabel.textColor = UIColor.redColor()
//                } else {
//                    deleteOnDragRelease = false
//                    rightLabel.textColor = UIColor.whiteColor()
//                }
//            } else { // 左划
//                if finished {
//                    completeOnDragRelease = true
//                    leftLabel.textColor = UIColor.greenColor()
//                } else {
//                    completeOnDragRelease = false
//                    leftLabel.textColor = UIColor.whiteColor()
//                }
//            }
//        case .Ended:
//            centerConstraint.constant = originConstant
//            
//            if deleteOnDragRelease {
//                deleteOnDragRelease = false
//                if let onDelete = onDelete {
//                    onDelete(self)
//                }
//            }
//            
//            if completeOnDragRelease {
//                completeOnDragRelease = false
//                if let onComplete = onComplete {
//                    onComplete(self)
//                }
//            }
//        default:
//            break
//        }
    }
    
//    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
//            let translation = panGesture.translationInView(self.mainTableView)
//            return fabs(translation.x) > fabs(translation.y)
//        }
//        return true
//    }
    
    //显示友好时间戳，参考自http://blog.csdn.net/zhyl8157121/article/details/42155921
    func friendlyTime(dateTime: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "zh_CN")
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm:ss")
        if let date = dateFormatter.dateFromString(dateTime) {
            let delta = NSDate().timeIntervalSinceDate(date)
            if (delta < 60) {
                return "刚刚"
            }
            else if (delta < 3600) {
                return "\(Int(delta / 60))分钟前"
            }
            else {
                let calendar = NSCalendar.currentCalendar()
                let unitFlags:NSCalendarUnit = [.Year,.Month,.Day,.Hour,.Minute]
                
                let comp = calendar.components(unitFlags, fromDate: NSDate())
                let currentYear = String(comp.year)
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
                    if currentDay == day {
                        return "\(hour):\(minute)"
                    } else {
                        return "\(month)/\(day)"
                    }  
                } else {  
                    return "\(year)/\(month)/\(day)"
                }  
            }  
        }  
        return ""
    }
    
    //使用插入排序的方式插入数据，使得cell按照优先级与最后编辑时间排序。
    func insertData(data:ItemModel, withAnimation hasAnimation:Bool){
        var index:Int = 0
        for item in dataArr{
            if data.level > item.level{
                index += 1
            }
            else if data.level == item.level && data.lastEditTime < item.lastEditTime{
                index += 1
            }
            else{
                break
            }
        }
        let state = data.state % 4 + (isFinished == true ? 4 : 0)
        if self.insertInDB(data, state: state){
            dataArr.insert(data, atIndex: index)
            self.mainTableView.beginUpdates()
            self.mainTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: hasAnimation ? .Automatic : .None)
            self.mainTableView.endUpdates()
        }
        else{
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = MBProgressHUDMode.Text
            hud.label.text = "数据库操作失败"
            hud.hideAnimated(true, afterDelay: 1.5)
        }
    }
    
    //删除指定位置的数据，单刷视图。
    func removeData(row index:Int){
        if self.deleteInDB(index){
            dataArr.removeAtIndex(index)
            self.mainTableView.beginUpdates()
            self.mainTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .None)
            self.mainTableView.endUpdates()
        }
        else{
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = MBProgressHUDMode.Text
            hud.label.text = "数据库操作失败"
            hud.hideAnimated(true, afterDelay: 1.5)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) ->UITableViewCell{
        let cell:ItemCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ItemCell
        let item = self.dataArr[indexPath.row]
        cell.titleLabel.text = item.title
        cell.timeLabel.text = friendlyTime(item.lastEditTime)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if false{
            var hudText = ""
            let temp = self.dataArr[indexPath.row]
            self.removeData(row: indexPath.row)
            if (isFinished == true){
                UnfinishedVC.insertData(temp, withAnimation: true)
                hudText = "已恢复"
            }
            else{
                FinishedVC.insertData(temp, withAnimation: true)
                hudText = "已完成"
            }
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = MBProgressHUDMode.Text
            hud.label.text = hudText
            hud.hideAnimated(true, afterDelay: 1.5)
        }
        else{
            let editVC = EditViewController()
            editVC
            self.presentViewController(EditViewController(), animated: true, completion: nil)
        }
    }
    
    func insertInDB(data:ItemModel, state:Int) -> Bool {
        self.dataBase.open()
        let sqlStr = "INSERT INTO data_\(UserVC.currentUser.md5) VALUES (?, ?, ?, ?, ?, ?, ?)"
        let succeed = self.dataBase.executeUpdate(sqlStr, withArgumentsInArray: [data.title, data.content, data.createTime, data.lastEditTime, data.alertTime, data.level, state])
        self.dataBase.close()
        return succeed
    }
    
    
    func deleteInDB(index:Int) -> Bool {
        self.dataBase.open()
        let sqlStr = "DELETE FROM data_\(UserVC.currentUser.md5) WHERE CREATE_TIME=?"
        let succeed =  self.dataBase.executeUpdate(sqlStr, withArgumentsInArray: [self.dataArr[index].createTime])
        self.dataBase.close()
        return succeed
    }
    
    func updateInDB(data:ItemModel, index:Int) -> Bool {
        self.dataBase.open()
        let sqlStr = "UPDATE data_\(UserVC.currentUser.md5) set TITLE=?, CONTENT=?, LAST_EDIT_TIME=?, ALERT_TIME=?, LEVEL=?, STATE=? WHERE CREATE_TIME=?"
        let succeed = self.dataBase.executeUpdate(sqlStr, withArgumentsInArray: [data.title, data.content, data.createTime, data.lastEditTime, data.alertTime, data.level, data.state, self.dataArr[index].createTime])
        self.dataBase.close()
        return succeed
    }
    
    func selectAllInDB() -> ([ItemModel], [ItemModel]) {
        self.dataBase.open()
        let sqlStr = "SELECT * FROM data_\(UserVC.currentUser.md5) ORDER BY LEVEL, LAST_EDIT_TIME DESC"
        let rs =  self.dataBase.executeQuery(sqlStr, withArgumentsInArray: [])
        var unfinished:[ItemModel] = [ItemModel]()
        var finished:[ItemModel] = [ItemModel]()
        while rs.next(){
            let state = rs.longForColumn("STATE")
            let data = ItemModel(title: rs.stringForColumn("TITLE"), content: rs.stringForColumn("CONTENT"), createTime: rs.stringForColumn("CREATE_TIME"), lastEditTime: rs.stringForColumn("LAST_EDIT_TIME"), alertTime: rs.stringForColumn("ALERT_TIME"), level: rs.longForColumn("LEVEL"), state: state)
            if state & 2 == 0{  //未删除
                if rs.longForColumn("state") >= 4{
                    finished.append(data)
                }
                else{
                    unfinished.append(data)
                }
            }
        }
        self.dataBase.close()
        return (unfinished, finished)
    }
    
}