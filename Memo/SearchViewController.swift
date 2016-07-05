//
//  SearchViewController.swift
//  Memo
//
//  Created by tjiese on 16/6/3.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    let cellIdentifier:String = "ItemCell"
    var mainTableView:UITableView = UITableView()
    var dataArr:[ItemModel] = [ItemModel]()
    var dataArr1:[ItemModel] = [ItemModel]()
    var isFinished:Bool!    //表示当前标签页是"已完成"还是"未完成"。
    var dataBase:FMDatabase!
    var dbQueue:FMDatabaseQueue!
    var tabledata:[String] = []
    var searchActive : Bool = false
    
    var filtered:[ItemModel] = [ItemModel]()
    var filtered1:[ItemModel] = [ItemModel]()
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 200, 44))
    var tap:UITapGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tap = UITapGestureRecognizer(target: self, action: "clicked")
        searchBar.delegate = self
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        let tableViewFrame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height - 44)
        self.mainTableView = UITableView(frame: tableViewFrame, style: UITableViewStyle.Grouped)
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
        
        let resetButton = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("reset"))
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        
        self.dataArr.appendContentsOf(DatabaseService.sharedInstance.selectAllInDB().0)
        self.dataArr1.appendContentsOf(DatabaseService.sharedInstance.selectAllInDB().1)
        navigationItem.titleView = searchBar
        self.navigationItem.leftBarButtonItem = resetButton
        
        // Reload the table
        self.mainTableView.reloadData()
    }
    
    
    func clicked(){
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
        self.view.addGestureRecognizer(tap)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
        self.view.removeGestureRecognizer(tap)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchBar.text
        filterContentForSearchText(searchText!)
        filterContentForSearchText1(searchText!)
        
        if(filtered.count == 0 && filtered1.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.mainTableView.reloadData()
    }
    
    // 告诉tableview一共有多少组
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    // 告诉tableview组头应该显示的文字，就算没有设置组头的高度也适用。
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (filtered.count != 0 || filtered1.count != 0) {
            if section == 0 {
                if (filtered.count != 0 ) {
                    return "未完成"
                }
            } else {
                if (filtered1.count != 0 ) {
                    return "完成"
                }
            }
        }
        return nil
    }
    
    // 当某一行cell已经被选中时调用
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let editVC = EditViewController()
        if indexPath.section == 0 {
            editVC.currentList = filtered[indexPath.row]
        } else {
            editVC.currentList = filtered1[indexPath.row]
        }
        self.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(editVC, animated: true)

    }
    
    func reset() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (filtered.count != 0 || filtered1.count != 0) {
            if section == 0 {
                return filtered.count
            }
            else {
                return filtered1.count
            }
        }
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ItemCell
        if(searchActive){
            
            if indexPath.section == 0 {
                let item = self.filtered[indexPath.row]
                cell.titleLabel.text = item.title
                cell.timeLabel.text = friendlyTime(item.lastEditTime)
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            }
            else {
                let item = self.filtered1[indexPath.row]
                cell.titleLabel.text = item.title
                cell.timeLabel.text = friendlyTime(item.lastEditTime)
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            }
        }
        return cell
    }
    
    func filterContentForSearchText(searchText: String) {
        
        filtered = self.dataArr.filter({ ( itemModel: ItemModel) -> Bool in
            
            let titleMatch = itemModel.title.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            let contentMatch = itemModel.content.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            
            return titleMatch != nil || contentMatch != nil
            
        })
    }
    func filterContentForSearchText1(searchText: String) {
        
        filtered1 = self.dataArr1.filter({ ( itemModel: ItemModel) -> Bool in
            
            let titleMatch = itemModel.title.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            let contentMatch = itemModel.content.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            
            return titleMatch != nil || contentMatch != nil
            
        })
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
}
