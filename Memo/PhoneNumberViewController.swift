//
//  PhoneNumberViewController.swift
//  hw2
//
//  Created by zyf on 16/5/29.
//  Copyright © 2016年 zyf. All rights reserved.
//

import UIKit

class PhoneNumberViewController: UIViewController ,UITextFieldDelegate{

    
    var txtPhoneNumber:UITextField!
    var txtPwd:UITextField!
    var txtVerifyCode:UITextField!
    var txtNickname:UITextField!
    var buttonVerifyCode:UIButton!
    var countdownTimer: NSTimer?
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTime:", userInfo: nil, repeats: true)
                remainingSeconds = 10
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
            }
        }
    }
    
    var remainingSeconds: Int = 0 {
        willSet {
            buttonVerifyCode.setTitle("\(newValue)秒后重新获取", forState: .Normal)
            if newValue <= 0 {
                buttonVerifyCode.enabled = true
                buttonVerifyCode.setTitle("重新获取验证码", forState: .Normal)
                isCounting = false
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        SMSSDK.registerApp("13497b5a4a530", withSecret: "5d4aa8cc0c6a64db874b7db0ad428360")
        self.view.backgroundColor = .whiteColor()
        let mainSize = UIScreen.mainScreen().bounds.size
        let img = UIImage(named:"background")
        let vImg = UIImageView(image: img)
        vImg.frame = CGRect(x:0,y:0,width:mainSize.width ,height:mainSize.height)
        self.view.sendSubviewToBack(vImg)
        self.view.addSubview(vImg)
        
        //添加注册框
        let vReg = UIView(frame:CGRectMake(10, 92, mainSize.width - 20, 176))
        self.view.addSubview(vReg)
        vReg.addSubview(MyRect(frame: CGRectMake(0, 41, mainSize.width - 20, 3)))
        vReg.addSubview(MyRect(frame: CGRectMake(0, 85, mainSize.width - 20, 3)))
        vReg.addSubview(MyRect(frame: CGRectMake(0, 129, mainSize.width - 20, 3)))
        vReg.layer.cornerRadius = 3
        vReg.backgroundColor = .whiteColor()
        
        //手机号输入框
        txtPhoneNumber = UITextField(frame:CGRectMake(0, 0, vReg.frame.size.width-122, 44))
        self.createTextField(txtPhoneNumber,isPasswordTextfield: false, hint: "手机号码")
        self.addImageToTextfield(txtPhoneNumber, imageName: "灰手机")
        vReg.addSubview(txtPhoneNumber)
        txtPhoneNumber.clearButtonMode = .WhileEditing
        txtPhoneNumber.keyboardType = UIKeyboardType.NumberPad
        
        //密码输入框
        txtPwd = UITextField(frame:CGRectMake(0, 132, vReg.frame.size.width , 44))
        self.createTextField(txtPwd,isPasswordTextfield: true,hint: "输入密码，至少六位")
        self.addImageToTextfield(txtPwd, imageName: "灰锁")
        vReg.addSubview(txtPwd)
        txtPwd.clearButtonMode = .WhileEditing
        
        //验证码输入框
        txtVerifyCode = UITextField(frame:CGRectMake(0, 44, vReg.frame.size.width , 44))
        self.createTextField(txtVerifyCode,isPasswordTextfield: false,hint: "请输入验证码")
        self.addImageToTextfield(txtVerifyCode, imageName: "灰锁")
        vReg.addSubview(txtVerifyCode)
        txtVerifyCode.clearButtonMode = .WhileEditing
        txtVerifyCode.keyboardType = UIKeyboardType.NumberPad
        
        //昵称输入框
        txtNickname = UITextField(frame:CGRectMake(0, 88, vReg.frame.size.width, 44))
        self.createTextField(txtNickname, isPasswordTextfield: false, hint: "请输入昵称")
        self.addImageToTextfield(txtNickname, imageName: "默认头像灰")
        vReg.addSubview(txtNickname)
        txtNickname.clearButtonMode = .WhileEditing
        
        self.buttonVerifyCode = UIButton(type: .Custom)
        //设置按钮位置和大小
        self.buttonVerifyCode.frame = CGRectMake(vReg.frame.size.width - 125, 7, 114, 31)
        self.buttonVerifyCode.tintColor = UIColor(red: 232/255, green: 208/255, blue: 120/255, alpha: 1)
        //设置按钮文字
        self.buttonVerifyCode.backgroundColor = UIColor(patternImage: UIImage(named: "发验证码框")!)
        self.buttonVerifyCode.setTitle("发送验证码", forState:.Normal)
        self.buttonVerifyCode.setTitleColor(UIColor(red: 232/255, green: 208/255, blue: 120/255, alpha: 1), forState: .Normal)
        self.buttonVerifyCode.addTarget(self, action:Selector("tapped:"),forControlEvents: .TouchUpInside)
        self.buttonVerifyCode.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 13.0)
        vReg.addSubview(self.buttonVerifyCode)
        
        let ButtonRegister:UIButton = UIButton(type:.System)
        //设置按钮位置和大小
        ButtonRegister.frame = CGRectMake(10, 280, vReg.frame.size.width , 44)
        ButtonRegister.backgroundColor = .grayColor()
        //设置按钮文字
        ButtonRegister.setTitle("注   册", forState:UIControlState.Normal)
        ButtonRegister.backgroundColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
        ButtonRegister.tintColor = UIColor(red: 232/255, green: 208/255, blue: 120/255, alpha: 1)
        ButtonRegister.addTarget(self, action:Selector("tapped1:"),forControlEvents: .TouchUpInside)
        ButtonRegister.layer.cornerRadius = 4
        self.view.addSubview(ButtonRegister)
        
        let buttonlogin:UIButton = UIButton(type:.System)
        //设置按钮位置和大小
        buttonlogin.frame = CGRectMake(10, 330, 100, 22)
        
        //设置按钮文字
        buttonlogin.setTitle("账号登录", forState:UIControlState.Normal)
        buttonlogin.tintColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
        buttonlogin.addTarget(self,action:Selector("tapped2:"),forControlEvents: .TouchUpInside)
        self.view.addSubview(buttonlogin)
        
        let buttonVisitor:UIButton = UIButton(type:.System)
        //设置按钮位置和大小
        buttonVisitor.frame = CGRectMake(vReg.frame.size.width-85, 330, 100, 22)

        //设置按钮文字
        buttonVisitor.setTitle("游客模式", forState:UIControlState.Normal)
        buttonVisitor.tintColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
        buttonVisitor.addTarget(self,action:Selector("tapped3:"),forControlEvents:.TouchUpInside)
        self.view.addSubview(buttonVisitor)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("hideKeyboard")))
        }
    func updateTime(timer: NSTimer) {
        // 计时开始时，逐秒减少remainingSeconds的值
        remainingSeconds -= 1
    }
    
    func hideKeyboard(){
        txtPhoneNumber.resignFirstResponder()
        txtPwd.resignFirstResponder()
        txtVerifyCode.resignFirstResponder()
        txtNickname.resignFirstResponder()
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
    func showAlert(message:String){
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "确定", style: .Cancel, handler: { (cancelAction) in
            if message == "上传数据失败"{
                self.navigationController?.popViewControllerAnimated(true)
            }
        })
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //发送验证码
    func tapped(button:UIButton){
        button.enabled = false
        let phoneNum = txtPhoneNumber.text
        SMSSDK.getVerificationCodeByMethod(SMSGetCodeMethodSMS, phoneNumber:phoneNum, zone: "86",customIdentifier: nil,result: {(error: NSError!) ->Void in
            if(error == nil){
                NSLog("发送成功")
                self.isCounting = true
            }else{
                self.showAlert("发送失败")
                print(error.debugDescription)
                button.enabled = true
            }
        })
    }
    
    //13207620165
    func tapped1(button:UIButton){
        button.enabled = false
        let authCode = txtVerifyCode.text
        let phoneNum = txtPhoneNumber.text
        if checkPassword(){
            SMSSDK.commitVerificationCode(authCode, phoneNumber: phoneNum, zone: "86", result:{ (error: NSError!) -> Void in
                if(error == nil){
                    NSLog("验证成功")
                    UserInfo.phoneNumber = self.txtPhoneNumber.text!
                    let url:String = "index.php/Home/User/SignUp"
                    let paramDict:Dictionary = ["user_phoneNumber": UserInfo.phoneNumber, "user_psw":self.txtPwd.text!.md5, "user_nickname":self.txtNickname.text!]
                    RequestAPI.POST(url, body: paramDict, succeed: { (task:NSURLSessionDataTask!, responseObject:AnyObject?) -> Void in
                        //成功回调
                        button.enabled = true
                        let resultDict = try! NSJSONSerialization.JSONObjectWithData(responseObject as! NSData, options: NSJSONReadingOptions.MutableContainers)
                        //注册成功
                        if resultDict["isSuccess"] as! Int == 1{
                            let loginVC = LogInViewController()
                            self.presentViewController(loginVC, animated: true, completion: {
                                let hud = MBProgressHUD.showHUDAddedTo(loginVC.view, animated: true)
                                hud.mode = MBProgressHUDMode.Text
                                hud.label.text = "注册成功"
                                hud.hideAnimated(true, afterDelay: 0.5)
                            })
                        }
                        else{
                            self.showAlert("账号已存在")
                        }
                    }) { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
                        //失败回调
                        button.enabled = true
                        print("网络调用失败:\(error)")
                        self.showAlert("网络连接失败")
                    }
                }else{
                    NSLog("验证失败！" , error)
                    self.showAlert("验证失败")
                    button.enabled = true
                }
            })
        }
    }

    func tapped2(button:UIButton){
        self.presentViewController(LogInViewController(), animated: true, completion: nil)
    }
    
    func tapped3(button:UIButton){
        UserInfo.phoneNumber = "Visitor"
        UserInfo.nickname = "游客"
        DatabaseService.sharedInstance.initDataTable()
        self.presentViewController(RootTabBarController(), animated: true, completion: nil)
    }
    
    func checkPassword() -> Bool  {
        if txtPwd.text == Optional(""){
            showAlert("密码为空")
            print("used")
            return false
        }
        else if txtPwd.text?.characters.count < 6{
            showAlert("密码至少是六位")
            return false
        }
        return true
    }
}
