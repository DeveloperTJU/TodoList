//
//  EditDetailViewController.swift
//  toDoList
//
//  Created by Luvian on 16/6/2.
//  Copyright © 2016年 Luvian. All rights reserved.
//

import UIKit

class EditDetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var currentList:ItemModel!
    var titleTextField:UITextField!
    var contentTextView:UITextView!
    var timeButton:UIButton!
    var tapGuesture:UITapGestureRecognizer!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background")!.drawInRect(CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
        
        self.title = "编辑"
        
        //给导航增加item
        let rightItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("FinishItem:"))
        rightItem.title = "完成"
        self.navigationItem.rightBarButtonItem = rightItem
        
        //标题
        let titleView = UITextView(frame: CGRectMake(15, 20, self.view.frame.size.width - 30, 50))
        titleView.backgroundColor=UIColor.whiteColor()
        titleView.layer.cornerRadius = 10;
        titleView.editable=false
        self.view.addSubview(titleView)
        
        self.titleTextField = UITextField(frame: CGRectMake(30, 20, self.view.frame.size.width - 60, 50))
        self.titleTextField.backgroundColor=UIColor.whiteColor()
        self.titleTextField.layer.cornerRadius = 10;
        self.titleTextField.text = currentList.title
        self.titleTextField.delegate = self
        self.view.addSubview(self.titleTextField)
        
        
        
        
        //提醒时间边框
        let timeTV = UITextView(frame: CGRectMake(15, self.view.frame.size.height - 160, self.view.frame.size.width - 30, 80))
        timeTV.editable=false
        timeTV.layer.borderColor = UIColor(red: 60/255, green: 40/255, blue: 129/255, alpha: 1).CGColor;
        timeTV.layer.borderWidth = 0.4;
        timeTV.layer.cornerRadius = 10;
        self.view.addSubview(timeTV)
        
        //提醒时间
        let timeLabel = UILabel()
        timeLabel.text = "提醒时间"
        timeLabel.frame = CGRectMake(40, self.view.frame.size.height - 105, (self.view.frame.size.width / 2 )-30, 20)
        timeLabel.font = UIFont(name:"Zapfino", size:15)
        self.view.addSubview(timeLabel)
        
        //显示提醒时间
        self.timeButton = UIButton()
        self.timeButton.frame = CGRectMake(self.view.frame.size.width - 200 , self.view.frame.size.height - 107, (self.view.frame.size.width / 2 )-30, 20)
        self.timeButton.setTitle(currentList.alertTime, forState:UIControlState.Normal)
        self.timeButton.setTitleColor(UIColor.blackColor(),forState: .Normal)
        self.timeButton.addTarget(self, action: Selector("selectDate:"), forControlEvents: .TouchUpInside)
        self.view.addSubview(self.timeButton)
        
        //添加星级边框
        let starTV = UITextView(frame: CGRectMake(15, self.view.frame.size.height - 195, self.view.frame.size.width - 30, 80))
        starTV.editable=false
        starTV.layer.borderColor = UIColor(red: 60/255, green: 40/255, blue: 129/255, alpha: 1).CGColor;
        starTV.layer.borderWidth = 0.4;
        starTV.layer.cornerRadius = 10;
        self.view.addSubview(starTV)
        
        //添加星级
        let starLabel = UILabel()
        starLabel.text = "添加星级"
        starLabel.frame = CGRectMake(40, self.view.frame.size.height - 140, (self.view.frame.size.width / 2 )-30, 20)
        starLabel.font = UIFont(name:"Zapfino", size:15)
        self.view.addSubview(starLabel)
        
        //大边框
        self.contentTextView = UITextView(frame: CGRectMake(15, 80, self.view.frame.size.width - 30, self.view.frame.size.height - 230))
        
        self.contentTextView.layer.borderColor = UIColor(red: 60/255, green: 40/255, blue: 129/255, alpha: 1).CGColor;
        self.contentTextView.layer.borderWidth = 0.4;
        self.contentTextView.layer.cornerRadius = 10;
        self.contentTextView.delegate = self
        
        let comment_message_style = NSMutableParagraphStyle()
        comment_message_style.firstLineHeadIndent = 24.0
        comment_message_style.headIndent = 10.0
        let comment_message_indent = NSMutableAttributedString(string:
            currentList.content)
        comment_message_indent.addAttribute(NSParagraphStyleAttributeName,
                                            value: comment_message_style,
                                            range: NSMakeRange(0, comment_message_indent.length))
        comment_message_indent.addAttribute(NSFontAttributeName,
                                            value: UIFont.systemFontOfSize(16),
                                            range: NSMakeRange(0, comment_message_indent.length))
        self.contentTextView.attributedText = comment_message_indent
        
        self.view.addSubview(self.contentTextView)
        
        
        self.tapGuesture = UITapGestureRecognizer(target: self, action: Selector("hideKeyBoard"))
        self.view.addGestureRecognizer(self.tapGuesture)
        
    }
    
    func hideKeyBoard() -> Void {
        self.contentTextView.resignFirstResponder()
        self.titleTextField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func FinishItem(right:UIBarButtonItem)
    {
        currentList.title = self.titleTextField.text!
        currentList.content = self.contentTextView.text!

        UnfinishedVC.updateData(currentList)
       
        UnfinishedVC.hidesBottomBarWhenPushed = false;
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    func selectDate(sender: AnyObject) {
        
        let alertController:UIAlertController=UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let datePicker = UIDatePicker( )
        datePicker.locale = NSLocale(localeIdentifier: "zh_CN")
        datePicker.date = NSDate()
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default){
            (alertAction)->Void in
            print("date select: \(datePicker.date.description)")
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

            self.currentList.alertTime = formatter.stringFromDate(datePicker.date)
                
            //刷新表面数据
            self.timeButton.setTitle(self.currentList.alertTime, forState:UIControlState.Normal)
            })
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel,handler:nil))
        
        alertController.view.addSubview(datePicker)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(TextField: UITextField) -> Bool
    {
        self.titleTextField.resignFirstResponder()
        return true;
    }
    
    
}
