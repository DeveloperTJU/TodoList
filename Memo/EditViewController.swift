//
//  EditViewController.swift
//  toDoList
//
//  Created by Luvian on 16/5/26.
//  Copyright © 2016年 Luvian. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var currentList:ItemModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background")!.drawInRect(CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
        
        //
        //        let textField = UITextField(frame: CGRectMake(30, 120, self.view.frame.size.width - 60, 50))
        //        textField.layer.borderWidth=1  //边框粗细
        //        textField.layer.borderColor=UIColor.grayColor().CGColor //边框颜色
        //        textField.placeholder = "请输入内容"
        ////        textField.text = self.currentList.toDoList
        //        textField.font = UIFont.boldSystemFontOfSize(20)
        //        textField.textAlignment = .Center
        //        textField.delegate = self
        //
        //        self.view.addSubview(textField)
        //
        //        let textview = UITextView(frame: CGRectMake(30, 180, self.view.frame.size.width - 60, 190))
        //        textview.layer.borderWidth=1
        //        textview.layer.borderColor=UIColor.grayColor().CGColor
        ////        textview.text = self.currentList.detail
        //        textview.font = UIFont.boldSystemFontOfSize(16)
        //        textview.delegate = self
        //
        //        self.view.addSubview(textview)
        
        
        self.title = "查看"
        //        self.view.backgroundColor = UIColor.grayColor()
        
        //        //导航栏颜色
        //        let mainColor = UIColor(red: 255/255, green: 223/255, blue: 110/255, alpha: 1)
        //        self.navigationController?.navigationBar.barTintColor = mainColor
        //        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //        //        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIFont(name: "Zapfino", size: 24.0)!];
        
        //给导航增加item
        let rightItem = UIBarButtonItem(title: "编辑", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("EditItem:"))
        rightItem.title = "编辑"
        if currentList.state & 2 == 0{  //未删除
            if currentList.state & 1 == 1{  //未完成
                rightItem.enabled = false
            }
        }
        self.navigationItem.rightBarButtonItem = rightItem
        
        //标题框
        let TextField = UITextField(frame: CGRectMake(15, 20, self.view.frame.size.width - 30, 50))
        TextField.backgroundColor=UIColor.whiteColor()
        TextField.layer.cornerRadius = 10;
        TextField.enabled=false
        self.view.addSubview(TextField)
        
        //大边框
        let TextView = UITextView(frame: CGRectMake(15, 80, self.view.frame.size.width - 30, self.view.frame.size.height-215))
        
        TextView.layer.borderColor = UIColor(red: 60/255, green: 40/255, blue: 129/255, alpha: 1).CGColor;
        //        TextView.layer.borderWidth = 0.5;
        TextView.layer.cornerRadius = 10;
        TextView.editable=false
        self.view.addSubview(TextView)
        
        //添加对勾图片
        let img = UIImage(named: "finished_selected")
        let vImg = UIImageView(image: img)
        vImg.frame = CGRect(x:30,y:35,width:20,height:20)
        self.view.addSubview(vImg)
        
        //添加title
        let titleLabel = UILabel()
        titleLabel.text = currentList.title
        titleLabel.frame = CGRectMake(60, 35, self.view.frame.size.width - 90, 20)
        titleLabel.textColor = UIColor.grayColor()
        self.view.addSubview(titleLabel)
        
        //添加detail
        let detailLabel = UILabel()
        detailLabel.text = currentList.content
        detailLabel.frame = CGRectMake(30, 75, self.view.frame.size.width - 90, 70)
        detailLabel.numberOfLines = 0
        detailLabel.textColor = UIColor.grayColor()
        self.view.addSubview(detailLabel)
        
        //提醒时间语句
        let timeLabel = UILabel()
        timeLabel.text = "提醒时间："
        timeLabel.frame = CGRectMake(40, self.view.frame.size.height - 165, (self.view.frame.size.width / 2 )-30, 20)
        timeLabel.font = UIFont(name:"Zapfino", size:15)
        timeLabel.textColor = UIColor.grayColor()
        self.view.addSubview(timeLabel)
        
        //提醒时间
        let timeLabel1 = UILabel()
        timeLabel1.text = currentList.alertTime
        timeLabel1.frame = CGRectMake(110, self.view.frame.size.height - 168, (self.view.frame.size.width / 2 )-30, 20)
        timeLabel1.textColor = UIColor.grayColor()
        self.view.addSubview(timeLabel1)
        
        //显示星级
        
        
        
        
        //分享按钮
        let shareimg = UIImage(named: "share")
        let vshareImg = UIImageView(image: shareimg)
        vshareImg.frame = CGRect(x:90,y:self.view.frame.size.height - 105,width:25,height:25)
        self.view.addSubview(vshareImg)
        
        
        let shareButton:UIButton = UIButton()
        shareButton.frame=CGRectMake(0, self.view.frame.size.height - 123, self.view.frame.size.width / 2, 60)
        //shareButton.setTitle("分享", forState:UIControlState.Normal)
        //shareButton.backgroundColor=UIColor(red: 238/255, green: 64/255, blue: 86/255, alpha:1)
        self.view.addSubview(shareButton)
        
        //删除按钮
        let deleteimg = UIImage(named: "delete")
        let vdeleteImg = UIImageView(image: deleteimg)
        vdeleteImg.frame = CGRect(x:self.view.frame.size.width / 2 + 90,y:self.view.frame.size.height - 105,width:25,height:25)
        self.view.addSubview(vdeleteImg)
        
        let deleteButton:UIButton = UIButton()
        deleteButton.frame=CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height - 123, self.view.frame.size.width / 2, 60)
        //        deleteButton.setTitle("删除", forState:UIControlState.Normal)
        //        deleteButton.backgroundColor=UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha:1)
        deleteButton.addTarget(self, action: Selector("deleteButtonAction:"), forControlEvents: UIControlEvents.TouchDown)
        self.view.addSubview(deleteButton)
        
        
        
        //        let button:UIButton = UIButton()
        //        button.frame=CGRectMake(30, 400, self.view.frame.size.width - 60, 30)
        //        button.setTitle("编辑完成", forState:UIControlState.Normal)
        //        button.setTitleColor(UIColor.grayColor(),forState: .Highlighted)
        //        button.backgroundColor=UIColor(red: 238/255, green: 64/255, blue: 86/255, alpha:1)
        //        self.view.addSubview(button);
        //
        //        button.addTarget(self,action:#selector(EditViewController.tapped(_:)),forControlEvents:UIControlEvents.TouchUpInside)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func EditItem(right:UIBarButtonItem)
    {
        let editDetailVC = EditDetailViewController()
        editDetailVC.currentList = currentList
        self.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(editDetailVC, animated: true)
        
        
    }
    
    
//    func deleteButtonAction(sender:UIButton){
//        let UnfinishedVC = UnfinishedViewController()
//        //        DataBaseService.sharedInstance.deleteInDB(currentList.createTime)
//        //        FinishedVC.mainTableView.reloadData()
//        var row1 = 0
//        for i in UnfinishedVC.dataArr{
//            if i.createTime == currentList.createTime{
//                break
//            }
//            row1 += 1
//        }
//        UnfinishedVC.removeData(row: row1)
//        FinishedVC.mainTableView.reloadData()
//        //        var row2 = 0
//        //        for i in FinishedVC.dataArr{
//        //            if i.createTime == currentList.createTime{
//        //                break
//        //            }
//        //            row2 += 1
//        //        }
//        //        FinishedVC.removeData(row: row2)
//        //        FinishedVC.mainTableView.reloadData()
//        self.hidesBottomBarWhenPushed = false;
//        self.navigationController?.pushViewController(UnfinishedVC, animated: true)
//        
//        
//    }
    func deleteButtonAction(sender:UIButton){
        var row = 0
        for i in UnfinishedVC.dataArr{
            if i.createTime == currentList.createTime{
                break
            }
            row += 1
        }
        UnfinishedVC.removeData(row: row)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}