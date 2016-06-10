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
    var txtVerifyCode:UITextField!
    var txtNickname:UITextField!
    var register:UIButton!
    var sendVerifyCode:UIButton!
    
    var VerifyCodeRight:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .whiteColor()
        let mainSize = UIScreen.mainScreen().bounds.size
        let img = UIImage(named:"background")
        let vImg = UIImageView(image: img)
        vImg.frame = CGRect(x:0,y:0,width:mainSize.width ,height:mainSize.height)
        self.view.sendSubviewToBack(vImg)
        self.view.addSubview(vImg)
        
        //添加注册框
        let vReg = UIView(frame:CGRectMake(10, 102, mainSize.width - 20, 176))
        self.view.addSubview(vReg)
        vReg.addSubview(MyRect(frame: CGRectMake(0, 41, mainSize.width - 20, 3)))
        vReg.addSubview(MyRect(frame: CGRectMake(0, 85, mainSize.width - 20, 3)))
        vReg.addSubview(MyRect(frame: CGRectMake(0, 129, mainSize.width - 20, 3)))
        vReg.layer.cornerRadius = 3
        vReg.backgroundColor = .whiteColor()
        
        //手机号输入框
        phoneText = UITextField(frame:CGRectMake(0, 0, vReg.frame.size.width, 44))
        self.createTextField(phoneText,isPasswordTextfield: false, hint: "手机号码")
        self.addImageToTextfield(phoneText, imageName: "灰手机")
        vReg.addSubview(phoneText)
        
        //密码输入框
        txtPwd = UITextField(frame:CGRectMake(0, 132, vReg.frame.size.width , 44))
        self.createTextField(txtPwd,isPasswordTextfield: true,hint: "输入密码，至少六位")
        self.addImageToTextfield(txtPwd, imageName: "灰锁")
        vReg.addSubview(txtPwd)
        
        //验证码输入框
        txtVerifyCode = UITextField(frame:CGRectMake(0, 44, vReg.frame.size.width , 44))
        self.createTextField(txtVerifyCode,isPasswordTextfield: false,hint: "请输入验证码")
        self.addImageToTextfield(txtVerifyCode, imageName: "灰锁")
        vReg.addSubview(txtVerifyCode)
        
        //昵称输入框
        txtNickname = UITextField(frame:CGRectMake(0, 88, vReg.frame.size.width, 44))
        self.createTextField(txtNickname, isPasswordTextfield: false, hint: "请输入昵称")
        self.addImageToTextfield(txtNickname, imageName: "灰手机")
        vReg.addSubview(txtNickname)
        
        self.register = UIButton(type:.System)
        //设置按钮位置和大小
        self.register.frame = CGRectMake(vReg.frame.size.width - 125, 7, 114, 31)
        self.register.tintColor = UIColor(red: 232/255, green: 208/255, blue: 120/255, alpha: 1)
        //设置按钮文字
        self.register.backgroundColor = UIColor(patternImage: UIImage(named: "发验证码框")!)
        self.register.setTitle("发送验证码", forState:UIControlState.Normal)
        self.register.addTarget(self, action:Selector("tapped:"),forControlEvents: .TouchUpInside)
        vReg.addSubview(self.register)
        
        let buttonVerifyCode:UIButton = UIButton(type:.System)
        //设置按钮位置和大小
        buttonVerifyCode.frame = CGRectMake(10, 290, vReg.frame.size.width , 44)
        buttonVerifyCode.backgroundColor = .grayColor()
        //设置按钮文字
        buttonVerifyCode.setTitle("注   册", forState:UIControlState.Normal)
        buttonVerifyCode.backgroundColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
        buttonVerifyCode.tintColor = UIColor(red: 232/255, green: 208/255, blue: 120/255, alpha: 1)
        buttonVerifyCode.addTarget(self, action:Selector("tapped1:"),forControlEvents: .TouchUpInside)
        buttonVerifyCode.layer.cornerRadius = 4
        self.view.addSubview(buttonVerifyCode)
        
        let buttonlogin:UIButton = UIButton(type:.System)
        //设置按钮位置和大小
        buttonlogin.frame = CGRectMake(10, 340, 100, 22)
        
        //设置按钮文字
        buttonlogin.setTitle("账号登录", forState:UIControlState.Normal)
        buttonlogin.tintColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
        buttonlogin.addTarget(self,action:Selector("tapped2:"),forControlEvents: .TouchUpInside)
        self.view.addSubview(buttonlogin)
        
        let buttonVisitor:UIButton = UIButton(type:.System)
        //设置按钮位置和大小
        buttonVisitor.frame = CGRectMake(vReg.frame.size.width-85, 340, 100, 22)

        //设置按钮文字
        buttonVisitor.setTitle("游客模式", forState:UIControlState.Normal)
        buttonVisitor.tintColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
        buttonVisitor.addTarget(self,action:Selector("tapped3:"),forControlEvents:.TouchUpInside)
        self.view.addSubview(buttonVisitor)
        }
    
    //设置输入框属性
    func createTextField(textField:UITextField!, isPasswordTextfield:Bool, hint:String)  {
        textField.delegate = self
        textField.placeholder = hint
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
        
//        let authCode = txtVerifyCode.text
//        let phoneNum = phoneText.text
//        var resultMessage = ""
//        SMSSDK.commitVerificationCode(authCode, phoneNumber: phoneNum, zone: "86" ,
//                                      result:{ (error: NSError!) -> Void in
//                                        if(error == nil){
//                                            resultMessage = "恭喜您，验证成功！123"
//                                            NSLog("验证成功")
//                                            self.VerifyCodeRight = true
//                                            
//                                        }else{
//                                            resultMessage = "很抱歉，验证失败！456"
//                                            NSLog("验证失败！" , error)
//                                            self.VerifyCodeRight = false
//                                            
//                                        }
//                                        self.alertWindow("验证结果789", message: resultMessage)
//        })
//        print(self.VerifyCodeRight)
        
        
//        if self.checkPassword(){
//
        //            if self.submitAuthCode(){
        let url:String = "todolist/index.php/Home/User/SignUp"
        let paramDict:Dictionary = ["user_phoneNumber": phoneText.text!, "user_psw":txtPwd.text!.md5, "user_nickname":txtNickname.text!]
        RequestAPI.POST(url, body: paramDict, succeed: { (task:NSURLSessionDataTask!, responseObject:AnyObject?) -> Void in
            //成功回调
            let resultDict = try! NSJSONSerialization.JSONObjectWithData(responseObject as! NSData, options: NSJSONReadingOptions.MutableContainers)
            //注册成功
            if resultDict["isSuccess"] as! Int == 1{
                self.alertWindow("成功", message: "注册成功!")
                self.presentViewController(LogInViewController(), animated: true, completion: nil)
            }
            else{
                self.alertWindow("错误", message: "注册失败!")
            }
        }) { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
                //失败回调
            print("网络调用失败:\(error)")
        }
//    }
//}
    }

    func tapped2(button:UIButton){
        self.presentViewController(LogInViewController(), animated: true, completion: nil)
    }
    
    func tapped3(button:UIButton){
        UserInfo.phoneNumber = "Visitor"
        UserInfo.nickName = "Visitor"
        self.presentViewController(RootTabBarController(), animated: true, completion: nil)
    }
    
    func submitAuthCode() -> Void{
        let authCode = txtVerifyCode.text
        let phoneNum = phoneText.text
        var resultMessage = ""
        self.VerifyCodeRight = false
        SMSSDK.commitVerificationCode(authCode, phoneNumber: phoneNum, zone: "86" ,
                                      result:{ (error: NSError!) -> Void in
                                        if(error == nil){
                                            resultMessage = "恭喜您，验证成功！"
                                            NSLog("验证成功")
                                            self.VerifyCodeRight = true
                                            
                                        }else{
                                            resultMessage = "很抱歉，验证失败！"
                                            NSLog("验证失败！" , error)
                                            self.VerifyCodeRight = false
                                            
                                        }
                                        self.alertWindow("验证结果", message: resultMessage)
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
