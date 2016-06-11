//
//  ChangePaswordController.swift
//  MySqliteConnect
//
//  Created by tjise on 16/5/31.
//  Copyright © 2016年 tjise. All rights reserved.
//

import UIKit

class ChangePaswordController: UIViewController,UITableViewDelegate,UITableViewDataSource ,UITextFieldDelegate{
    
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
        // self.addRightButtonItem()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        // self.setMainTableView()
        self.setMainView()
        
    }
    
    //设置登录式UI界面
    func setMainView(){
        //获取屏幕尺寸
        let mainSize = self.view.bounds.size
        self.view.backgroundColor = .whiteColor()
        let img = UIImage(named:"background")
        let vImg = UIImageView(image: img)
        vImg.frame = CGRect(x:0,y:0,width:mainSize.width ,height:mainSize.height)
        self.view.sendSubviewToBack(vImg)
        self.view.addSubview(vImg)
        
        //登录框背景
        let passwordView = UIView(frame:CGRectMake(10, 148, mainSize.width - 20, 132))
        self.view.addSubview(passwordView)
        passwordView.addSubview(MyRect(frame: CGRectMake(0, 41, mainSize.width - 20, 3)))
        passwordView.layer.cornerRadius = 3
        passwordView.backgroundColor = .whiteColor()
        
        //原密码输入框
        oldPasswordText = UITextField(frame:CGRectMake(0, 0, passwordView.frame.size.width , 44))
        oldPasswordText.placeholder = "请输入原密码"
        oldPasswordText.delegate = self
        oldPasswordText.becomeFirstResponder()
        oldPasswordText.secureTextEntry = true
        oldPasswordText.leftView = UIView(frame:CGRectMake(0, 0, 44, 44))
        oldPasswordText.leftViewMode = UITextFieldViewMode.Always
        
        //用户名输入框左侧图标
        let oldImg =  UIImageView(frame:CGRectMake(11, 11, 22, 22))
        oldImg.image = UIImage(named:"灰锁")
        oldPasswordText.leftView!.addSubview(oldImg)
        passwordView.addSubview(oldPasswordText)
        
        //新密码输入框
        newPasswordText = UITextField(frame:CGRectMake(0, 44, passwordView.frame.size.width , 44))
        newPasswordText.delegate = self
        newPasswordText.placeholder = "请输入新密码"
        newPasswordText.secureTextEntry = true
        newPasswordText.leftView = UIView(frame:CGRectMake(0, 0, 44, 44))
        newPasswordText.leftViewMode = UITextFieldViewMode.Always
        passwordView.addSubview(MyRect(frame: CGRectMake(0, 85, mainSize.width - 20, 3)))
        
        //认证密码输入框
        confirmPasswordText = UITextField(frame:CGRectMake(0, 88, passwordView.frame.size.width , 44))
        confirmPasswordText.delegate = self
        confirmPasswordText.placeholder = "请确认新密码"
        confirmPasswordText.secureTextEntry = true
        confirmPasswordText.leftView = UIView(frame:CGRectMake(0, 0, 44, 44))
        confirmPasswordText.leftViewMode = UITextFieldViewMode.Always
        
        //密码输入框左侧图标
        let newImg =  UIImageView(frame:CGRectMake(11, 11, 22, 22))
        newImg.image = UIImage(named:"灰锁")
        newPasswordText.leftView!.addSubview(newImg)
        passwordView.addSubview(newPasswordText)
        
        let confirmImg =  UIImageView(frame:CGRectMake(11, 11, 22, 22))
        confirmImg.image = UIImage(named:"灰锁")
        confirmPasswordText.leftView!.addSubview(confirmImg)
        passwordView.addSubview(confirmPasswordText)
        
        let finishBtn:UIButton = UIButton(type:.System)
        //设置按钮位置和大小
        finishBtn.frame = CGRectMake(10, 290, passwordView.frame.size.width , 44)
        finishBtn.backgroundColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
        finishBtn.tintColor = UIColor(red: 232/255, green: 208/255, blue: 120/255, alpha: 1)
        finishBtn.layer.cornerRadius = 4
        //设置按钮文字
        finishBtn.setTitle("修   改", forState:UIControlState.Normal)
        finishBtn.addTarget(self,action:Selector("finishChangePassword"),forControlEvents: .TouchUpInside)
        self.view.addSubview(finishBtn)
    }
    
    
    //设置密码tableView
    func setMainTableView(){
        let tableViewFrame:CGRect = CGRectMake(10, 10, self.view.bounds.width-20, self.view.bounds.height-10)
        self.mainTableView = UITableView(frame: tableViewFrame, style: .Plain)
        self.mainTableView.backgroundColor = .whiteColor()
        self.mainTableView.dataSource = self
        self.mainTableView.delegate = self
        let cellNib = UINib(nibName: "ChangePasswodCell", bundle: nil)
        self.mainTableView.registerNib(cellNib, forCellReuseIdentifier: cellIdentifier)
        self.mainTableView.backgroundColor = .clearColor()
        self.mainTableView.separatorStyle = .None
        self.view.addSubview(self.mainTableView)
    }
    
    //设置样式
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ChangePasswodCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ChangePasswodCell
        cell.titleLabel.text = dataArr[indexPath.section][indexPath.row]
        cell.passwordText.secureTextEntry = true
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundColor = .clearColor()
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr[section].count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    //设置分区头视图
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clearColor()
        view.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 20)
        return view
    }
    
    //添加导航栏左侧按钮
    func addLeftButtonItem(){
        let leftBtn:UIBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "backPersonalCenter")
        self.navigationItem.leftBarButtonItem = leftBtn
    }
    
    func addRightButtonItem(){
        let rightBtn:UIBarButtonItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Plain, target: self, action: "finishChangePassword")
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    func backPersonalCenter(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    //获取网络状态
    func netWorkState()->String{
        let reachability = Reachability.reachabilityForInternetConnection()
        if reachability!.isReachableViaWiFi(){
            return "连接类型，WIFI"
        }else if reachability!.isReachableViaWWAN(){
            return "连接类型，移动网络"
        }else{
            return "无可用网络"
        }
    }
    
    func updateDataNetWork(oldPassword:String,newPassword:String){
        let url:String = "todolist/index.php/Home/User/ChangePassword"
        let paramDict:Dictionary = ["UID":UserInfo.UID,"user_oldPassword":oldPassword,"user_newPassword":newPassword.md5]
        RequestAPI.POST(url, body: paramDict, succeed: { (task:NSURLSessionDataTask!, responseObject:AnyObject?) -> Void in
            //成功回调
            let resultDict = try! NSJSONSerialization.JSONObjectWithData(responseObject as! NSData, options: NSJSONReadingOptions.MutableContainers)
            print("请求结果：\(resultDict)")
            self.isPasswordChanged = true
            
        }) { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
            //失败回调
            print("网络调用失败:\(error)")
            self.isPasswordChanged = false
        }
    }
    
    func finishChangePassword(){
        //获取输入密码框文本
        //        let indexpath1:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        //        let cell1:ChangePasswodCell = self.mainTableView.cellForRowAtIndexPath(indexpath1) as! ChangePasswodCell
        //        let oldPassword = cell1.passwordText.text! as String
        //
        //        let indexPath2:NSIndexPath = NSIndexPath(forRow: 0, inSection: 1)
        //        let cell2:ChangePasswodCell = self.mainTableView.cellForRowAtIndexPath(indexPath2) as! ChangePasswodCell
        //        let newPassword = cell2.passwordText.text! as String
        //
        //        let indexPath3:NSIndexPath = NSIndexPath(forRow: 0, inSection: 2)
        //        let cell3:ChangePasswodCell = self.mainTableView.cellForRowAtIndexPath(indexPath3) as! ChangePasswodCell
        //        let confirmPassword = cell3.passwordText.text! as String
        
        let oldPassword = self.oldPasswordText.text! as String
        let newPassword = self.newPasswordText.text! as String
        let confirmPassword = self.confirmPasswordText.text! as String
        
        let result = self.getErrorType(oldPassword, newPassword: newPassword, confirmPasswod: confirmPassword)
        let reachability = Reachability.reachabilityForInternetConnection()
        if !reachability!.isReachable(){
            self.showAlert("网络连接失败")
        }
        else if result == "ok"{
            //判断修改密码的可能情况
            self.updateDataNetWork(oldPassword, newPassword: newPassword)
            if self.isPasswordChanged{
                self.showAlert("修改密码成功，请重新登录")
            }else{
                self.showAlert("数据更新错误，修改密码失败")
                // self.navigationController?.popViewControllerAnimated(true)
            }
        }
        else{
            showAlert(result)
        }
    }
    
    //修改密码的错误类型
    func getErrorType(oldPassword:String,newPassword:String,confirmPasswod:String) -> String{
        if oldPassword == ""{
            return "请输入原密码"
        }else if newPassword == ""{
            return "请输入新密码"
        }else if newPassword != confirmPasswod{
            return "密码不一致"
        }else{
            return "ok"
        }
    }
    
    func showAlert(message:String){
        let alert:UIAlertController = UIAlertController(title: "提示", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: { (cancelAction) in
            if message == "修改密码成功，请重新登录"{
                UserInfo = UserInfoStruct()
                self.presentViewController(LogInViewController(), animated: true, completion: nil)
            }else if message == "数据更新错误，修改密码失败"{
                self.navigationController?.popViewControllerAnimated(true)
            }
        })
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
