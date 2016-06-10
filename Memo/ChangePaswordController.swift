//
//  ChangePaswordController.swift
//  MySqliteConnect
//
//  Created by tjise on 16/5/31.
//  Copyright © 2016年 tjise. All rights reserved.
//

import UIKit

protocol BackForNewPasswordDelegate:NSObjectProtocol{
    func setNewPassword(password:String)
}

class ChangePaswordController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var currentPassword:String!
    var delegate:BackForNewPasswordDelegate?
    var mainTableView:UITableView!
    let cellIdentifier:String = "ChangePasswodCell"
    var dataArr:[[String]] = [["原密码"],["新密码"],["确认密码"]]
    var isPasswordChanged:Bool = false//服务器密码修改成功
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改密码"
        self.addLeftButtonItem()
        self.addRightButtonItem()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        self.setMainTableView()
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
    
    //获取服务器数据库密码
    func getNewWorkPassword()->String{
//        let baseURL = NSURL(string: "http://10.1.43.56/")
//        let manager = AFHTTPSessionManager(baseURL: baseURL)
//        let paramDict:Dictionary = ["user_phoneNumber":txtUser.text!,"user_psw":txtPwd.text!.md5]
//        let url:String = "todolist/index.php/Home/User/Login"
//        //请求数据的序列化器
//        manager.requestSerializer = AFHTTPRequestSerializer()
//        //返回数据的序列化器
//        manager.responseSerializer = AFHTTPResponseSerializer()
//        let resSet = NSSet(array: ["text/html"])
//        manager.responseSerializer.acceptableContentTypes = resSet as? Set<String>
//        manager.POST(url, parameters: paramDict, success: { (task:NSURLSessionDataTask!, responseObject:AnyObject?) -> Void in
//            //成功回调
//            print("success")
//            
//            let resultDict = try! NSJSONSerialization.JSONObjectWithData(responseObject as! NSData, options: NSJSONReadingOptions.MutableContainers)
//            
//            print("请求结果：\(resultDict)")
//            
//            
//        }) { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
//            //失败回调
//            print("网络调用失败:\(error)")
//        }

        return "123456"
    }
    
    //修改密码的错误类型
    func getErrorType(oldPassword:String,newPassword:String,confirmPasswod:String) -> String{
        if oldPassword == ""{
            return "请输入原密码"
        }else if oldPassword != self.getNewWorkPassword(){
            return "原密码不正确"
        }else if newPassword == ""{
            return "请输入新密码"
        }else if newPassword != confirmPasswod{
            return "密码不一致"
        }else{
            return "ok"
        }
    }
    
    
    func updateDataNetWork(oldPassword:String,newPassword:String){
        let url:String = "todolist/index.php/Home/User/ChangePassword"
        let paramDict:Dictionary = ["UID":"","user_oldPassword":oldPassword,"user_newPassword":newPassword.md5]
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
        let indexpath1:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        let cell1:ChangePasswodCell = self.mainTableView.cellForRowAtIndexPath(indexpath1) as! ChangePasswodCell
        let oldPassword = cell1.passwordText.text! as String
        
        let indexPath2:NSIndexPath = NSIndexPath(forRow: 0, inSection: 1)
        let cell2:ChangePasswodCell = self.mainTableView.cellForRowAtIndexPath(indexPath2) as! ChangePasswodCell
        let newPassword = cell2.passwordText.text! as String
        
        let indexPath3:NSIndexPath = NSIndexPath(forRow: 0, inSection: 2)
        let cell3:ChangePasswodCell = self.mainTableView.cellForRowAtIndexPath(indexPath3) as! ChangePasswodCell
        let confirmPassword = cell3.passwordText.text! as String
        
        
        //判断修改密码的可能情况
        let reachability = Reachability.reachabilityForInternetConnection()
        if reachability!.isReachable(){
            let result:String = self.getErrorType(oldPassword, newPassword: newPassword, confirmPasswod: confirmPassword)
            if result == "ok"{
                let alert:UIAlertController = UIAlertController(title: "警告", message: "确定修改密码，需要重新登录", preferredStyle: UIAlertControllerStyle.Alert)
                let confirmAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (confirmAction) in
                    //修改服务器数据库
                    self.updateDataNetWork(oldPassword, newPassword: newPassword)
                    if self.isPasswordChanged{
                        self.delegate?.setNewPassword(newPassword)
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                    else{
                        print("后台数据未更新，修改密码失败")
                    }
                })
                let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (cancelAction) in
                })
                alert.addAction(confirmAction)
                alert.addAction(cancelAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }else{
                let alert:UIAlertController = UIAlertController(title: "错误提示", message: result, preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(cancelAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }else{
            print("网络不可用")
        }
    }


}
