//
//  PhoneNumberViewController.swift
//  hw2
//
//  Created by zyf on 16/5/29.
//  Copyright © 2016年 zyf. All rights reserved.
//

import UIKit

class PhoneNumberViewController: UIViewController ,UITextFieldDelegate{

    
    var phoneText:UITextField!
    var txtPwd:UITextField!
    //var txtPwdConfirm:UITextField!
    var txtVerifyCode:UITextField!
    var txtNickname:UITextField!
    var register:UIButton!
    var sendVerifyCode:UIButton!
    var dataBase:FMDatabase!
    
    var VerifyCodeRight:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        let mainSize = UIScreen.mainScreen().bounds.size
        let img = UIImage(named:"bgimage")
        let vImg = UIImageView(image: img)
        vImg.frame = CGRect(x:0,y:0,width:mainSize.width ,height:mainSize.height)
        self.view.sendSubviewToBack(vImg)
        self.view.addSubview(vImg)
        //添加登录框
        let vLogin =  UIView(frame:CGRectMake(15, 150, mainSize.width - 30, 176))
        vLogin.layer.borderWidth = 0.5
        vLogin.layer.borderColor = UIColor.lightGrayColor().CGColor
        vLogin.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(vLogin)
        
        //手机号输入框
        phoneText = UITextField(frame:CGRectMake(0, 0, vLogin.frame.size.width, 44))
        self.createTextField(phoneText,isPasswordTextfield: false, hint: "手机号码")
        self.addImageToTextfield(phoneText, imageName: "iconfont-user")
        vLogin.addSubview(phoneText)
        //密码输入框
        txtPwd = UITextField(frame:CGRectMake(0, 132, vLogin.frame.size.width , 44))
        self.createTextField(txtPwd,isPasswordTextfield: true,hint: "输入密码，至少六位")
        self.addImageToTextfield(txtPwd, imageName: "iconfont-password")
        vLogin.addSubview(txtPwd)
        //密码确认框
//        txtPwdConfirm = UITextField(frame:CGRectMake(30, 210, vLogin.frame.size.width - 60, 44))
//        self.createTextField(txtPwdConfirm,isPasswordTextfield: true,hint: "确认密码")
//        self.addImageToTextfield(txtPwdConfirm, imageName: "iconfont-password")
//        vLogin.addSubview(txtPwdConfirm)
        //验证码输入框
        txtVerifyCode = UITextField(frame:CGRectMake(0, 44, vLogin.frame.size.width , 44))
        self.createTextField(txtVerifyCode,isPasswordTextfield: false,hint: "请输入验证码")
        self.addImageToTextfield(txtVerifyCode, imageName: "iconfont-password")
        vLogin.addSubview(txtVerifyCode)
        //昵称输入框
        txtNickname = UITextField(frame:CGRectMake(0, 88, vLogin.frame.size.width , 44))
        self.createTextField(txtNickname,isPasswordTextfield: false, hint: "请输入昵称")
        self.addImageToTextfield(txtNickname, imageName: "iconfont-user")
        vLogin.addSubview(txtNickname)
        
        self.register = UIButton(type:.System)
        //设置按钮位置和大小
        self.register.frame=CGRectMake(vLogin.frame.size.width - 120, 0, 90, 44)
        self.register.tintColor = UIColor(red: 232/255, green: 208/255, blue: 120/255, alpha: 1)
        //设置按钮文字
        self.register.setTitle("发送验证码", forState:UIControlState.Normal)
        self.register.addTarget(self,action:#selector(tapped(_:)),forControlEvents:.TouchUpInside)
        vLogin.addSubview(self.register)
        
        let buttonVerifyCode:UIButton = UIButton(type:.System)
        //设置按钮位置和大小
        buttonVerifyCode.frame=CGRectMake(15, 340, vLogin.frame.size.width , 44)
        buttonVerifyCode.backgroundColor = UIColor.grayColor()
        //设置按钮文字
        buttonVerifyCode.setTitle("注册", forState:UIControlState.Normal)
        buttonVerifyCode.backgroundColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
        buttonVerifyCode.tintColor = UIColor(red: 232/255, green: 208/255, blue: 120/255, alpha: 1)
        buttonVerifyCode.addTarget(self,action:#selector(tapped1(_:)),forControlEvents:.TouchUpInside)
        self.view.addSubview(buttonVerifyCode)
        
        
        let buttonlogin:UIButton = UIButton(type:.System)
        //设置按钮位置和大小
        buttonlogin.frame=CGRectMake(15, 390, 100, 22)
        
        //设置按钮文字
        buttonlogin.setTitle("登录", forState:UIControlState.Normal)
        buttonlogin.tintColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
        buttonlogin.addTarget(self,action:#selector(tapped2(_:)),forControlEvents:.TouchUpInside)
        self.view.addSubview(buttonlogin)
        
        
        
        let buttonVisitor:UIButton = UIButton(type:.System)
        //设置按钮位置和大小
        buttonVisitor.frame=CGRectMake(15+vLogin.frame.size.width-100, 390, 100, 22)

        //设置按钮文字
        buttonVisitor.setTitle("游客模式", forState:UIControlState.Normal)
        buttonVisitor.tintColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
        buttonVisitor.addTarget(self,action:#selector(tapped3(_:)),forControlEvents:.TouchUpInside)
        self.view.addSubview(buttonVisitor)
    
    
    }
    
    //设置输入框属性
    func createTextField(textField:UITextField!, isPasswordTextfield:Bool, hint:String)  {
        textField.delegate = self
        textField.placeholder = hint
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.lightGrayColor().CGColor
        textField.layer.borderWidth = 0.5
        textField.secureTextEntry = isPasswordTextfield
        textField.leftView = UIView(frame:CGRectMake(0, 0, 44, 44))
        textField.leftViewMode = UITextFieldViewMode.Always
    }
    
    //输入框左侧添加图片
    func addImageToTextfield(textField:UITextField!, imageName:String) {
        let imgUser =  UIImageView(frame:CGRectMake(11, 11, 22, 22))
        imgUser.image = UIImage(named:imageName)
        textField.leftView!.addSubview(imgUser)
    }
    
    //弹窗
    func alertWindow(title:String, message:String)  {
        let alert : UIAlertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "Back")
        alert.show()
    }
    
    //发送验证码
    func tapped(button:UIButton){
        let phoneNum = phoneText.text
        SMSSDK.getVerificationCodeByMethod(SMSGetCodeMethodSMS, phoneNumber:phoneNum, zone: "86",customIdentifier: nil,result: {(error: NSError!) ->Void in
            if(error == nil){
                NSLog("发送成功")
                self.register.setTitle("再次发送", forState: UIControlState.Normal)
                //self.countDown(10)
            }else{
                self.alertWindow("error", message: error.debugDescription)
            }
            
        })
    }
    //13207620165
    func tapped1(button:UIButton){
        
        let authCode = txtVerifyCode.text
        let phoneNum = phoneText.text
        var resultMessage = ""
        SMSSDK.commitVerificationCode(authCode, phoneNumber: phoneNum, zone: "86" ,
                                      result:{ (error: NSError!) -> Void in
                                        if(error == nil){
                                            resultMessage = "恭喜您，验证成功！123"
                                            NSLog("验证成功")
                                            self.VerifyCodeRight = true
                                            
                                        }else{
                                            resultMessage = "很抱歉，验证失败！456"
                                            NSLog("验证失败！" , error)
                                            self.VerifyCodeRight = false
                                            
                                        }
                                        self.alertWindow("验证结果789", message: resultMessage)
        })
        print(self.VerifyCodeRight)
        
        
//        if self.checkPassword(){
//
//            if self.submitAuthCode(){
                print("zhuce")
                self.dataBase = DataBaseService.getDataBase()
                self.dataBase.open()
                let baseURL = NSURL(string: "http://10.1.43.56/")
                let manager = AFHTTPSessionManager(baseURL: baseURL)
                let paramDict:Dictionary = ["user_phoneNumber": phoneText.text!,"user_psw":txtPwd.text!.md5,"user_nickname":txtNickname.text!]
                let url:String = "todolist/index.php/Home/User/SignUp"
                //请求数据的序列化器
                manager.requestSerializer = AFHTTPRequestSerializer()
                //返回数据的序列化器
                manager.responseSerializer = AFHTTPResponseSerializer()
                let resSet = NSSet(array: ["text/html"])
                manager.responseSerializer.acceptableContentTypes = resSet as? Set<String>
                manager.POST(url, parameters: paramDict, success: { (task:NSURLSessionDataTask!, responseObject:AnyObject?) -> Void in
                    //成功回调
                    print("success")
                    
                    let resultDict = try! NSJSONSerialization.JSONObjectWithData(responseObject as! NSData, options: NSJSONReadingOptions.MutableContainers)
                    
                    print("请求结果：\(resultDict)")
                    self.alertWindow("Success", message: "Register Successfully!")
                    
                }) { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
                    //失败回调
                    print("网络调用失败:\(error)")
                }
//
//                
//                
//            }
//            
//        
//        }
    }
    
    
    func tapped2(button:UIButton){
        
        let login = LogInViewController()
        self.presentViewController(login, animated: true, completion: nil)
        
    }
    
    
    
    func tapped3(button:UIButton){
        
        self.dataBase = DataBaseService.getDataBase()
        self.dataBase.open()

                        var sqlStr = "CREATE TABLE IF NOT EXISTS TASKFORvisitor(CONTENT TEXT,TIME TEXT,DDLDATE TEXT)"
                        var isSuccess = self.dataBase.executeUpdate(sqlStr, withArgumentsInArray: [])
        
                        if !isSuccess {
                            print("Error:\(self.dataBase.lastErrorMessage())")
                        }
                        sqlStr = "CREATE TABLE IF NOT EXISTS COMPLETETASKFORvisitor(CONTENT TEXT,TIME TEXT,DDLDATE TEXT)"
                        isSuccess = self.dataBase.executeUpdate(sqlStr, withArgumentsInArray: [])
        
                        if !isSuccess {
                            print("Error:\(self.dataBase.lastErrorMessage())")
                        }
                        self.dataBase.close()
        let rootVC = RootTabBarController()
        self.presentViewController(rootVC, animated: true, completion: nil)
        
    }
    
    func submitAuthCode() -> Void{
        let authCode = txtVerifyCode.text
        let phoneNum = phoneText.text
        var resultMessage = ""
        self.VerifyCodeRight = false
        SMSSDK.commitVerificationCode(authCode, phoneNumber: phoneNum, zone: "86" ,
                                      result:{ (error: NSError!) -> Void in
                                        if(error == nil){
                                            resultMessage = "恭喜您，验证成功！123"
                                            NSLog("验证成功")
                                            self.VerifyCodeRight = true
                                            
                                        }else{
                                            resultMessage = "很抱歉，验证失败！456"
                                            NSLog("验证失败！" , error)
                                            self.VerifyCodeRight = false
                                            
                                        }
                                        self.alertWindow("验证结果789", message: resultMessage)
        })

    }
    
    

    
    func checkPassword() -> Bool  {
        
        if txtPwd.text == Optional(""){
            alertWindow("错误", message: "密码为空1")
            print("used")
            return false
        }
        
        else if txtPwd.text?.characters.count < 6{
            alertWindow("错误", message: "密码至少是六位")
            return false
        }
        
        return true
    }
    
    
    

}
