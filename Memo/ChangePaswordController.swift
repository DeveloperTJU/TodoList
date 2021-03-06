//
//  ChangePaswordController.swift
//  MySqliteConnect
//
//  Created by tjise on 16/5/31.
//  Copyright © 2016年 tjise. All rights reserved.
//

import UIKit

class ChangePaswordController: UIViewController ,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource{
    
    var currentPassword:String!
    var mainTableView:UITableView!
    let cellIdentifier:String = "ChangePasswodCell"
    var dataArr:[[String]] = [["原密码"],["新密码"],["确认密码"]]
    var isPasswordChanged:Bool = false//服务器密码修改成功
    
    var oldPasswordText:UITextField!
    var newPasswordText:UITextField!
    var confirmPasswordText:UITextField!
    var logIn:UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改密码"
        self.addLeftButtonItem()
        self.addRightButtonItem()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        self.view.userInteractionEnabled = true
        let tapGeture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "onViewClicked:")
        self.view.addGestureRecognizer(tapGeture)
        
        self.setPasswordText()
        self.setMainTableView()
        
    }
    
    func setMainTableView(){
        let tableViewFrame:CGRect = CGRectMake(8, self.view.bounds.size.height/2 - 150, self.view.bounds.size.width-16, self.view.bounds.height)
        self.mainTableView = UITableView(frame: tableViewFrame, style: .Plain)
        self.mainTableView.dataSource = self
        self.mainTableView.delegate = self
        self.mainTableView.backgroundColor = .clearColor()
        self.mainTableView.separatorStyle = .None
        self.mainTableView.scrollEnabled = true
        self.view.addSubview(self.mainTableView)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 42
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let frame:CGRect = CGRectMake(0, 0, self.view.bounds.size.width, 42)
        let cell = UITableViewCell(frame: frame)
        cell.layer.cornerRadius = 3
        if indexPath.row == 0{
            cell.addSubview(self.oldPasswordText)
            cell.addSubview(MyRect(frame: CGRectMake(0, 39, self.view.bounds.size.width - 20, 3)))
        }else if indexPath.row == 1{
            cell.addSubview(self.newPasswordText)
            cell.addSubview(MyRect(frame: CGRectMake(0, 39, self.view.bounds.size.width - 20, 3)))
        }else {
            cell.addSubview(self.confirmPasswordText)
        }
        return cell;
    }
    
    func setPasswordText(){
        let frame:CGRect = CGRectMake(0, 0, self.view.bounds.size.width-10, 42)
        self.oldPasswordText = UITextField(frame: frame)
        oldPasswordText = UITextField(frame:frame)
        oldPasswordText.placeholder = "请输入原密码"
        oldPasswordText.delegate = self
        oldPasswordText.becomeFirstResponder()
        oldPasswordText.secureTextEntry = true
        oldPasswordText.leftView = UIView(frame:CGRectMake(0, 0, 44, 44))
        oldPasswordText.leftViewMode = UITextFieldViewMode.Always
        let oldImg =  UIImageView(frame:CGRectMake(11, 11, 22, 22))
        oldImg.image = UIImage(named:"灰锁")
        oldPasswordText.leftView!.addSubview(oldImg)
        self.oldPasswordText.clearButtonMode = .WhileEditing
        
        self.newPasswordText = UITextField(frame: frame)
        newPasswordText = UITextField(frame:frame)
        newPasswordText.placeholder = "请输入新密码"
        newPasswordText.delegate = self
        newPasswordText.secureTextEntry = true
        newPasswordText.leftView = UIView(frame:CGRectMake(0, 0, 44, 44))
        newPasswordText.leftViewMode = UITextFieldViewMode.Always
        let newImg =  UIImageView(frame:CGRectMake(11, 11, 22, 22))
        newImg.image = UIImage(named:"灰锁")
        newPasswordText.leftView!.addSubview(newImg)
        self.newPasswordText.clearButtonMode = .WhileEditing

        self.confirmPasswordText = UITextField(frame: frame)
        confirmPasswordText = UITextField(frame:frame)
        confirmPasswordText.placeholder = "请确认新密码"
        confirmPasswordText.delegate = self
        confirmPasswordText.secureTextEntry = true
        confirmPasswordText.leftView = UIView(frame:CGRectMake(0, 0, 44, 44))
        confirmPasswordText.leftViewMode = UITextFieldViewMode.Always
        let confirmImg =  UIImageView(frame:CGRectMake(11, 11, 22, 22))
        confirmImg.image = UIImage(named:"灰锁")
        confirmPasswordText.clearButtonMode = .WhileEditing
        confirmPasswordText.leftView!.addSubview(confirmImg)

    }
    
    //添加导航栏左侧按钮
    func addLeftButtonItem(){
        let leftBtn:UIBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "backPersonalCenter")
        self.navigationItem.leftBarButtonItem = leftBtn
    }
    
    //设置修改密码完成按钮
    func addRightButtonItem(){
        let rightBtn = UIBarButtonItem(title: "完成", style: .Plain, target: self, action: "updateDataNetWork")
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    
    func backPersonalCenter(){
        self.navigationController?.popViewControllerAnimated(true)
    }
        
    func updateDataNetWork(){
        let oldPassword = self.oldPasswordText.text! as String
        let newPassword = self.newPasswordText.text! as String
        let confirmPassword = self.confirmPasswordText.text! as String
        let result = self.getErrorType(oldPassword, newPassword: newPassword, confirmPasswod: confirmPassword)
        if result == "ok"{
            let url:String = "index.php/Home/User/ChangePassword"
            let paramDict:Dictionary = ["UID":UserInfo.UID,"user_oldPassword":oldPassword.md5,"user_newPassword":newPassword.md5]
            RequestAPI.POST(url, body: paramDict, succeed: { (task:NSURLSessionDataTask!, responseObject:AnyObject?) -> Void in
                //成功回调
                let resultDict = try! NSJSONSerialization.JSONObjectWithData(responseObject as! NSData, options: NSJSONReadingOptions.MutableContainers)
                if resultDict["isSuccess"] as! Int == 1 {
                    //self.showAlert("修改密码成功，请重新登录")
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text
                    hud.label.text = "修改密码成功"
                    hud.hideAnimated(true, afterDelay: 0.5)
                    self.navigationController?.popViewControllerAnimated(true)
                }
                else{
                    self.showAlert("数据更新错误，修改密码失败")
                }
                
            }) { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
                //失败回调
//                print("网络调用失败:\(error)")
                self.showAlert("数据更新错误，修改密码失败")
            }
        }else{
            self.showAlert(result)
        }
    }
    
    //修改密码的错误类型
    func getErrorType(oldPassword:String,newPassword:String,confirmPasswod:String) -> String{
        if oldPassword == ""{
            return "请输入原密码"
        }else if newPassword.characters.count < 6{
            return "密码不能少于6位数"
        }
        else if newPassword == ""{
            return "请输入新密码"
        }else if newPassword != confirmPasswod{
            return "密码不一致"
        }else if newPassword == oldPassword{
            return "密码与原密码相同"
        }
        else{
            return "ok"
        }
    }
    
    func showAlert(message:String){
        let alert:UIAlertController = UIAlertController(title: "提示", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: { (cancelAction) in
            if message == "数据更新错误，修改密码失败"{
                self.navigationController?.popViewControllerAnimated(true)
            }
        })
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func onViewClicked(gesture:UIGestureRecognizer){
        self.oldPasswordText.resignFirstResponder()
        self.newPasswordText.resignFirstResponder()
        self.confirmPasswordText.resignFirstResponder()
    }

}
