//
//  BaseViewController.swift
//  Memo
//
//  Created by hui on 16/5/18.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, ItemCellDelegate {
    
    let cellIdentifier:String = "ItemCell"
    var mainTableView:UITableView!
    var dataArr:[ItemModel]!                //数据源
    var isFinished:Bool!                    //表示当前标签页是"已完成"还是"未完成"。
    
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
    
    //初始化数据库并存入测试数据
    func initTestData(){
        
        //CGAffineTransformIdentity
        //MJRefresh
        
        //该方法仅供测试
        let dataBase = DataBaseService.sharedInstance.getDataBase()
        dataBase.open()
        var sqlStr = "DROP TABLE IF EXISTS data_\(UserVC.currentUser.md5)"
        dataBase.executeUpdate(sqlStr, withArgumentsInArray: [])
        sqlStr = "CREATE TABLE IF NOT EXISTS data_\(UserVC.currentUser.md5)(TITLE TEXT, CONTENT TEXT, CREATE_TIME TEXT, LAST_EDIT_TIME TEXT, ALERT_TIME TEXT, LEVEL INT, STATE INT, PRIMARY KEY(CREATE_TIME))"
        dataBase.executeUpdate(sqlStr, withArgumentsInArray: [])
        sqlStr = "INSERT INTO data_\(UserVC.currentUser.md5) VALUES (?, ?, ?, ?, ?, ?, ?)"
        dataBase.executeUpdate(sqlStr, withArgumentsInArray: ["task1", "no content1", "2016-05-27 12:01:00", "2016-05-27 12:01:00", "2017-05-27 12:01:00", 1, 4])
        dataBase.executeUpdate(sqlStr, withArgumentsInArray: ["task2", "no content2", "2016-05-27 12:02:01", "2016-05-27 12:02:01", "2017-05-27 12:02:01", 1, 4])
        dataBase.executeUpdate(sqlStr, withArgumentsInArray: ["task3", "no content3", "2016-05-27 12:03:02", "2016-05-27 12:03:02", "2017-05-27 12:03:02", 1, 0])
        dataBase.executeUpdate(sqlStr, withArgumentsInArray: ["task4", "no content4", "2016-05-27 12:04:03", "2016-05-27 12:04:03", "2017-05-27 12:04:03", 1, 0])
        dataBase.executeUpdate(sqlStr, withArgumentsInArray: ["task5", "no content5", "2016-05-27 12:05:02", "2016-05-27 12:05:02", "2017-05-27 12:05:02", 1, 1])
        dataBase.executeUpdate(sqlStr, withArgumentsInArray: ["task6", "no content6", "2016-05-27 12:06:00", "2016-05-27 12:06:00", "2017-05-27 12:06:00", 1, 1])
        dataBase.close()
    }
    
    //在初始化时添加TableView以在尚未加载视图时存取dataArr数据。
    func loadTableView() {
//        self.initTestData()
        let tableViewFrame:CGRect = self.view.bounds
        self.mainTableView = UITableView(frame: tableViewFrame, style: UITableViewStyle.Plain)
        self.mainTableView.backgroundColor = UIColor.whiteColor()
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        let cellNib = UINib(nibName: "ItemCell", bundle: nil)
        self.mainTableView.registerNib(cellNib, forCellReuseIdentifier: cellIdentifier)
        self.mainTableView.tableFooterView = UIView()
        self.view.addSubview(self.mainTableView)
        self.view.backgroundColor = UIColor(patternImage: RootTabBarController.compressImage(image: UIImage(named: "background")!, toSize: self.view.frame.size))
        self.mainTableView.backgroundColor = UIColor.clearColor()
        self.mainTableView.separatorStyle = .None
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //添加导航栏按钮
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
    
    //搜索页
    func search(){
//        let nav = SearchViewController()
//        nav.hidesBottomBarWhenPushed = true
//        self.navigationController!.pushViewController(nav,animated:true);
    }
    
    //个人中心页
    func userInfo(sender: UIButton){
        let vc = PersonalCenterController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //手动同步
    func refreshManually(){
        
    }
    
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
        data.state = data.state % 2 + (isFinished == true ? 2 : 0)
        if DataBaseService.sharedInstance.insertInDB(data){
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
        if DataBaseService.sharedInstance.deleteInDB(self.dataArr[index].createTime){
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
    
    //设置Cell属性
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) ->UITableViewCell{
        let cell:ItemCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ItemCell
        let item = self.dataArr[indexPath.row]
        cell.titleLabel.text = item.title
        cell.timeLabel.text = friendlyTime(item.lastEditTime)
        cell.createTime = item.createTime
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.stateButton.setImage(UIImage(named: "finished"), forState: isFinished == true ? .Highlighted : .Normal)
        cell.stateButton.setImage(UIImage(named: "finished_selected"), forState: isFinished == false ? .Highlighted : .Normal)
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
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    //侧滑删除
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "    ") {
            action, index in
            self.removeData(row: indexPath.row)
        }
        UIGraphicsBeginImageContext(CGSize(width: 50, height: 50))
        UIImage(named: "垃圾箱")!.drawInRect(CGRect(x: 5, y: 15, width: 20, height: 20))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        deleteButton.backgroundColor = UIColor(patternImage: image)
        return [deleteButton]
    }
    
    //切换已完成/未完成状态
    func switchState(button:UIButton, createTime:String){
        var hudText = ""
        var row = 0
        for i in self.dataArr{
            if i.createTime == createTime{
                break
            }
            row += 1
        }
        let temp = self.dataArr[row]
        self.removeData(row: row)
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
    
}