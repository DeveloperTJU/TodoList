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
    var nicknameText:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化数据
        self.title = "关于我们"
        initDataArrs()
        
        self.setTableView()
        //添加头像
        self.setAvaterImage()
        self.setNicknameText()
        //添加返回按钮
        self.addLeftButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.nicknameText.text = UserInfo.nickname == "" ? UserInfo.phoneNumber : UserInfo.nickname
    }
    
    //添加tableView
    func setTableView(){
        let tableViewFrame:CGRect = CGRectMake(8, 0, self.view.bounds.width-16, self.view.bounds.height)
        self.mainTableView = UITableView(frame: tableViewFrame, style: .Plain)
        self.mainTableView.dataSource = self
        self.mainTableView.delegate = self
        self.mainTableView.backgroundColor = .clearColor()
        self.mainTableView.separatorStyle = .None
        self.mainTableView.scrollEnabled = false
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
        let arr2 = ["指导教师"]
        let arr3 = ["开发小组","薛成韵  张彦辉  郑艺峰  王贝妮  杨若岚  李训涛  田嘉诺"]
        self.dataArrs = [arr0,arr1,arr2,arr3]
    }
    
    //设置第一行头像
    func setAvaterImage(){
        self.imageView = UIImageView(frame: CGRectMake(self.view.bounds.size.width/2 - 50, 10, 80, 80))
        self.imageView.layer.cornerRadius = CGRectGetHeight(imageView.bounds)/2
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.borderColor = UIColor.grayColor().CGColor
        self.imageView.layer.borderWidth = 1
        let image = UIImage(named: "logo")
        self.imageView.image = image
    }
    
    //设置昵称
    func setNicknameText(){
        let textFrame:CGRect = CGRectMake(150, 80, 100, 50)
        self.nicknameText = UILabel(frame: textFrame)
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
            return 140
        }
        else{
            return 42
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
        var font = UIFont(name: "HelveticaNeue-Thin", size: 14.0)
        if indexPath.section == 1 && indexPath.row == 0{
            let frame:CGRect = CGRectMake(self.view.bounds.size.width - 250, 0, 200, 42)
            let phoneNumberText = UILabel(frame: frame)
            phoneNumberText.text = "天软swift开发团队"
            phoneNumberText.textAlignment = .Right
            phoneNumberText.font = font
            cell.addSubview(phoneNumberText)
        }
        else if indexPath.section == 2 && indexPath.row == 0{
            let frame:CGRect = CGRectMake(self.view.bounds.size.width - 250, 0, 200, 42)
            let phoneNumberText = UILabel(frame: frame)
            phoneNumberText.text = "孙小圆老师"
            phoneNumberText.textAlignment = .Right
            phoneNumberText.font = font
            cell.addSubview(phoneNumberText)
        }
        else if indexPath.section == 3 && indexPath.row == 1{
            cell.textLabel?.textAlignment = .Center
        }
        else{
            if indexPath.section == 0 && indexPath.row == 0{
                let frame:CGRect = CGRectMake(20, 0, 200, 200)
                cell = UITableViewCell(frame: frame)
                cell.addSubview(imageView)
                self.nicknameText.text = "ToDoList v1.0.0"
                cell.addSubview(nicknameText)
                nicknameText.font = font
                cell.selectionStyle = .None
            }
        }
        cell.textLabel!.font = font
        cell.selectionStyle = .None
        cell.layer.cornerRadius = 3
        return cell
    }
}