//
//  AboutViewController.swift
//  Memo
//
//  Created by tjise on 16/6/12.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    var mainTableView:UITableView!
    var imageView = UIImageView()
    var dataArrs:[[String]] = [[String]]()
    var versionText:UILabel!
    var urlText1:UrlLabel = UrlLabel()
    var urlText2:UrlLabel = UrlLabel()
    var urlText3:UrlLabel = UrlLabel()
    var urlText4:UrlLabel = UrlLabel()
    var urlText5:UrlLabel = UrlLabel()
    var urlText6:UrlLabel = UrlLabel()
    var urlText7:UrlLabel = UrlLabel()
    var urlText8:UrlLabel = UrlLabel()
    var dataArr:[UrlLabel]!
    var cellHeight:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化数据
        self.title = "关于我们"
        initDataArrs()
        cellHeight = self.view.bounds.size.height/16

        self.setTableView()
        //添加头像
        self.setAvaterImage()
        self.setversionText()
        //添加返回按钮
        self.addLeftButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.versionText.text = UserInfo.nickname == "" ? UserInfo.phoneNumber : UserInfo.nickname
    }
    
    //添加tableView
    func setTableView(){
        let tableViewFrame:CGRect = CGRectMake(8, 0, self.view.bounds.width-16, self.view.bounds.height)
        self.mainTableView = UITableView(frame: tableViewFrame, style: .Plain)
        self.mainTableView.dataSource = self
        self.mainTableView.delegate = self
        self.mainTableView.backgroundColor = .clearColor()
        self.mainTableView.separatorStyle = .None
        self.mainTableView.scrollEnabled = true
        self.view.addSubview(self.mainTableView)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }
    
    //添加返回按钮
    func addLeftButtonItem(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: "backMain")
    }
    
    //返回按钮事件
    func backMain(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //初始化tableView
    func initDataArrs() {
        let arr0 = [""]
        let arr1 = ["开发团队"]
        //let arr2 = ["指导教师"]
        let arr3 = ["开发小组", "    薛成韵乀(ˉεˉ乀)",  "    张彦辉",  "    郑艺峰",  "    nmpp:Github@hailuy",  "    杨若岚",  "    李训涛",  "    田佳诺","    杨耀华"]
        self.dataArrs = [arr0,arr1,arr3]
    }
    
    //设置第一行头像
    func setAvaterImage(){
        self.imageView = UIImageView(frame: CGRectMake(self.view.bounds.size.width/2 - cellHeight*5/6, 10, cellHeight * 5/3, cellHeight*5/3))
        print(imageView.bounds.width)
        self.imageView.layer.cornerRadius = 10
        self.imageView.layer.masksToBounds = true
        let image = UIImage(named: "Icon-76")
        self.imageView.image = image
    }
    
    //设置昵称
    func setversionText(){
        let textFrame:CGRect = CGRectMake(self.view.bounds.size.width/2 - cellHeight*5/6-3, cellHeight*9/5, 100, 50)
        self.versionText = UILabel(frame: textFrame)
    }
    
    //控制分区数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataArrs.count
    }
    
    //控制行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArrs[section].count
    }
    
    //控制分区头
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    //设置行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0{
            return cellHeight * 3
        }
        else{
            return cellHeight
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
    
    //设置分区头样式
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clearColor()
        view.frame = CGRectMake(0, 0, self.view.bounds.size.width, 42)
        return view
    }
    
    //控制样式
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.separatorStyle = .None
        let frame:CGRect = CGRectMake(20, 20, 20, 42)
        var cell = UITableViewCell(frame:frame)
        let sectionArr = dataArrs[indexPath.section]
        cell.textLabel?.text = sectionArr[indexPath.row]
        let font = UIFont(name: "HelveticaNeue-Thin", size: 14.0)
        cell.textLabel!.font = font
        if indexPath.section == 1 && indexPath.row == 0{
            tableView.separatorStyle = .SingleLine
            let frame:CGRect = CGRectMake(self.view.bounds.size.width - 250, 0, 200, 42)
            let developerText = UILabel(frame: frame)
            developerText.text = "tju酱油一号"
            developerText.textAlignment = .Right
            developerText.font = font
            cell.addSubview(developerText)
        }
        else if indexPath.section == 2 && indexPath.row > 0{
            cell.textLabel?.textAlignment = .Left
            cell.textLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 14.0)
            tableView.separatorStyle = .SingleLine
            cell.textLabel?.autoresizingMask = UIViewAutoresizing.FlexibleWidth
            let textFrame:CGRect = CGRectMake(self.view.bounds.size.width - 200,4,180,34)
            switch(indexPath.row){
            case 1:
                urlText1 = UrlLabel(frame: textFrame)
                urlText1.text = "github.com/xuexcy"
                cell.addSubview(urlText1)
            case 2:
                urlText2 = UrlLabel(frame: textFrame)
                urlText2.text = "gitHub.com/CodeInDreams"
                cell.addSubview(urlText2)
            case 3:
                urlText3 = UrlLabel(frame: textFrame)
                urlText3.text = "github.com/hyiszcx"
                cell.addSubview(urlText3)
            case 4:
                urlText4 = UrlLabel(frame: textFrame)
                urlText4.text = "github.com/hailuy"
                cell.addSubview(urlText4)
            case 5:
                urlText5 = UrlLabel(frame: textFrame)
                urlText5.text = "github.com/luvianlan"
                cell.addSubview(urlText5)
            case 6:
                urlText6 = UrlLabel(frame: textFrame)
                urlText6.text = "github.com/lixuntao"
                cell.addSubview(urlText6)
            case 7:
                urlText7 = UrlLabel(frame: textFrame)
                urlText7.text = "github.com/tysb"
                cell.addSubview(urlText7)
            case 8:
                urlText8 = UrlLabel(frame: textFrame)
                urlText8.text = "github.com/yangyaohua"
                cell.addSubview(urlText8)
            default:break
            }
        }
        else{
            if indexPath.section == 0 && indexPath.row == 0{
                let frame:CGRect = CGRectMake(20, 0, 200, 200)
                cell = UITableViewCell(frame: frame)
                cell.addSubview(imageView)
                self.versionText.text = "咕嘟笔记 v1.0"
                cell.addSubview(versionText)
                versionText.font = font
                cell.selectionStyle = .None
            }
        }
        cell.selectionStyle = .None
        cell.layer.cornerRadius = 3
        return cell
    }
}