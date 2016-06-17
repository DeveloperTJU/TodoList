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
        let resetButton = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("reset"))
        resetButton.title = "返回"
        let rightItem = UIBarButtonItem(title: "编辑", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("EditItem:"))
        rightItem.title = "编辑"
        if currentList.state & 1 == 0{  //未删除
            if currentList.state & 2 == 2{  // 以完成
                rightItem.enabled = false
            }
        }
        self.navigationItem.leftBarButtonItem = resetButton
        self.navigationItem.rightBarButtonItem = rightItem
        
        //标题框
        let TextField = UITextField(frame: CGRectMake(15, 20, self.view.frame.size.width - 30, 50))
        TextField.backgroundColor=UIColor.whiteColor()
        TextField.layer.cornerRadius = 3;
        TextField.enabled=false
        self.view.addSubview(TextField)
        
        //大边框
        let TextView = UITextView(frame: CGRectMake(15, 80, self.view.frame.size.width - 30, self.view.frame.size.height-215))
        
        TextView.layer.borderColor = UIColor(red: 60/255, green: 40/255, blue: 129/255, alpha: 1).CGColor;
        //        TextView.layer.borderWidth = 0.5;
        TextView.layer.cornerRadius = 3;
        TextView.editable=false
        self.view.addSubview(TextView)
        
        //添加对勾图片
        let img = UIImage(named: "完成选中")
        let vImg = UIImageView(image: img)
        vImg.frame = CGRect(x:30,y:35,width:20,height:20)
        self.view.addSubview(vImg)
        
        //添加title
        let titleLabel = UILabel()
        titleLabel.text = currentList.title
        titleLabel.frame = CGRectMake(60, 35, self.view.frame.size.width - 90, 20)
        titleLabel.textColor = UIColor.grayColor()
        titleLabel.font = UIFont.systemFontOfSize(15)
        self.view.addSubview(titleLabel)
        
        //添加detail
        let detailView = UITextView(frame: CGRectMake(30, 85, self.view.frame.size.width - 60, self.view.frame.size.height-250))
        detailView.editable = false
        
        let comment_message_style = NSMutableParagraphStyle()
        comment_message_style.firstLineHeadIndent = 24.0
        comment_message_style.headIndent = 10.0
        let comment_message_indent = NSMutableAttributedString(string:
            currentList.content)
        comment_message_indent.addAttribute(NSParagraphStyleAttributeName,
                                            value: comment_message_style,
                                            range: NSMakeRange(0, comment_message_indent.length))
        comment_message_indent.addAttribute(NSFontAttributeName,
                                            value: UIFont.systemFontOfSize(15),
                                            range: NSMakeRange(0, comment_message_indent.length))
        comment_message_indent.addAttribute(NSForegroundColorAttributeName,
                                            value: UIColor.grayColor(),
                                            range: NSMakeRange(0, comment_message_indent.length))
        detailView.attributedText = comment_message_indent
        
        self.view.addSubview(detailView)
        
        //提醒时间语句
        let timeLabel = UILabel()
        timeLabel.text = "提醒时间："
        timeLabel.frame = CGRectMake(30, self.view.frame.size.height - 165, (self.view.frame.size.width / 2 )-30, 20)
        timeLabel.font = UIFont.systemFontOfSize(12)
        timeLabel.textColor = UIColor.grayColor()
        self.view.addSubview(timeLabel)
        
        //提醒时间
        let timeLabel1 = UILabel()
        if self.currentList.alertTime == ""{
            timeLabel1.text = "无"
        }
        else{
            timeLabel1.text = currentList.alertTime
        }
        timeLabel1.frame = CGRectMake(85, self.view.frame.size.height - 165, (self.view.frame.size.width / 2 )-30, 20)
        timeLabel1.textColor = UIColor.grayColor()
        timeLabel1.font = UIFont.systemFontOfSize(12)
        self.view.addSubview(timeLabel1)
        
        //显示星级
        for i in 0..<currentList.level+1 {
            let button = UIButton()
            button.frame = CGRectMake(self.view.frame.size.width - 125 + CGFloat.init(integerLiteral: 20 * i ), self.view.frame.size.height - 165, 15, 15)
            button.setImage(UIImage(named: "黄星"), forState: .Normal)
            button.setImage(UIImage(named: "黄星"), forState: .Highlighted)
            self.view.addSubview(button)
        }
        if currentList.level != 5{
        for i in currentList.level+1..<5 {
            let button = UIButton()
            button.frame = CGRectMake(self.view.frame.size.width - 125 + CGFloat.init(integerLiteral: 20 * i), self.view.frame.size.height - 165, 15, 15)
            button.setImage(UIImage(named: "灰星"), forState: .Normal)
            button.setImage(UIImage(named: "灰星"), forState: .Highlighted)
            self.view.addSubview(button)
        }
        }
        
        
        //分享按钮
        let shareimg = UIImage(named: "黑分享")
        let vshareImg = UIImageView(image: shareimg)
        vshareImg.frame = CGRect(x:self.view.frame.size.width / 4,y:self.view.frame.size.height - 105,width:25,height:25)
        self.view.addSubview(vshareImg)
        
        
        let shareButton:UIButton = UIButton()
        shareButton.frame=CGRectMake(0, self.view.frame.size.height - 123, self.view.frame.size.width / 2, 60)
        self.view.addSubview(shareButton)
        
        //删除按钮
        let deleteimg = UIImage(named: "垃圾箱")
        let vdeleteImg = UIImageView(image: deleteimg)
        vdeleteImg.frame = CGRect(x:self.view.frame.size.width * 3 / 4 - 25,y:self.view.frame.size.height - 105,width:25,height:25)
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
    
    func reset() {
        //        let nav = BaseViewController()
        self.navigationController!.popViewControllerAnimated(true)
    }
    
}