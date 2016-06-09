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
    
    //MJRefresh
    
    //在初始化时添加TableView以在尚未加载视图时存取dataArr数据。
    func loadTableView() {
        let tableViewFrame:CGRect = self.view.bounds
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //添加导航栏按钮
        let refreshButton = UIBarButtonItem(image: UIImage(named: "更新"), style: .Plain, target: self, action: Selector("refreshManually"))
        let searchButton = UIBarButtonItem(image: UIImage(named: "搜索"), style: .Plain, target: self, action: Selector("search"))
        let button = UIButton(type: .System)
        button.frame = CGRectMake(0, 0, 120, 35)
        button.setImage(UIImage(named: UserInfo.phoneNumber.md5), forState: .Normal)
        button.setTitle(" \(UserInfo.nickName)", forState: .Normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 13.0)!
        button.addTarget(self, action: Selector("userInfo:"), forControlEvents: .TouchDown)
        let userButton = UIBarButtonItem(customView: button)
        
        //调节导航栏控件间隔
        let spacer1 = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil,
            action: nil)
        spacer1.width = -35
        let spacer2 = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil,
            action: nil)
        spacer2.width = -5
        let spacer3 = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil,
            action: nil)
        spacer3.width = -20
        
        self.navigationItem.leftBarButtonItems = [spacer1, userButton]
        self.navigationItem.rightBarButtonItems = [spacer2, refreshButton, spacer3, searchButton]
    }
    
    //刷新上次编辑时间的友好显示
    override func viewWillAppear(animated: Bool) {
        for i in 0 ..< self.dataArr.count {
            if let cell = self.mainTableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as? ItemCell {
               cell.timeLabel.text = friendlyTime(dataArr[i].lastEditTime)
            }
        }
    }
    
    //搜索页
    func search(){
        let searchVC = SearchViewController()
        searchVC.hidesBottomBarWhenPushed = true
        self.navigationController!.pushViewController(searchVC,animated:true)
    }
    
    //个人中心页
    func userInfo(sender: UIButton){
        let vc = PersonalCenterController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //手动同步
    func refreshManually(){
        var message = "同步失败"
        if RequestAPI.SynchronizeTask(){
            message = "同步成功"
        }
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = MBProgressHUDMode.Text
        hud.label.text = message
        hud.hideAnimated(true, afterDelay: 0.5)
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
            dataArr.insert(data, atIndex: index)
            self.mainTableView.beginUpdates()
            self.mainTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: hasAnimation ? .Automatic : .None)
            self.mainTableView.endUpdates()
        }
        else{
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = MBProgressHUDMode.Text
            hud.label.text = "数据库操作失败"
            hud.hideAnimated(true, afterDelay: 0.5)
        }
    }
    
    //删除指定位置的数据，单刷视图。
    func removeData(row index:Int){
        self.dataArr[index].state += 1
        if DatabaseService.sharedInstance.updateInDB(self.dataArr[index]){
            dataArr.removeAtIndex(index)
            self.mainTableView.beginUpdates()
            self.mainTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .None)
            self.mainTableView.endUpdates()
        }
        else{
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = MBProgressHUDMode.Text
            hud.label.text = "数据库操作失败"
            hud.hideAnimated(true, afterDelay: 0.5)
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
        let deleteButton = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "    ") {
            action, index in
            self.removeData(row: indexPath.row)
        }
        deleteButton.backgroundColor = UIColor(patternImage: UIImage(named: "垃圾箱")!)
        return [deleteButton]
    }
    
    //切换已完成/未完成状态
    func switchState(button:UIButton, createTime:String){
        var row = findIndex(createTime)
        let data = self.dataArr[row]
        let another = (isFinished! ? UnfinishedVC : FinishedVC)
        var message = (isFinished! ? "已恢复" : "已完成")
        data.state = (isFinished! ? 0 : 2)
        if DatabaseService.sharedInstance.updateInDB(data){
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
            message = "数据库操作失败"
        }
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = MBProgressHUDMode.Text
        hud.label.text = message
        hud.hideAnimated(true, afterDelay: 0.5)
    }
    
}