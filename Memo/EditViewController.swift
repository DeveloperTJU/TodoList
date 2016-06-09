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
        
        
        
        self.title = "查看"
        
        //给导航增加item
        let rightItem = UIBarButtonItem(title: "编辑", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("EditItem:"))
        rightItem.title = "编辑"
        if currentList.state & 1 == 0{  //未删除
            if currentList.state & 2 == 2{  // 以完成
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
        self.view.addSubview(shareButton)
        
        //删除按钮
        let deleteimg = UIImage(named: "delete")
        let vdeleteImg = UIImageView(image: deleteimg)
        vdeleteImg.frame = CGRect(x:self.view.frame.size.width / 2 + 90,y:self.view.frame.size.height - 105,width:25,height:25)
        self.view.addSubview(vdeleteImg)
        
        let deleteButton:UIButton = UIButton()
        deleteButton.frame=CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height - 123, self.view.frame.size.width / 2, 60)
        deleteButton.addTarget(self, action: Selector("deleteButtonAction:"), forControlEvents: UIControlEvents.TouchDown)
        self.view.addSubview(deleteButton)
        
        
        
        
        
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
    
    
    func deleteButtonAction(sender:UIButton){
//        var row = 0
//        for i in UnfinishedVC.dataArr{
//            if i.createTime == currentList.createTime{
//                break
//            }
//            row += 1
//        }
        if currentList.state & 2 == 2{  // 以完成
            let row = FinishedVC.findIndex(currentList.createTime)
            FinishedVC.removeData(row: row)
        }
        else{
            let row = UnfinishedVC.findIndex(currentList.createTime)
            UnfinishedVC.removeData(row: row)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}