//
//  ChangeNickNameController.swift
//  Memo
//
//  Created by tjise on 16/6/7.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

protocol ChangeNickNameDelegate{
    func setNewNickName(newNickName:String)
}

class ChangeNickNameController: UIViewController {

    var delegate:ChangeNickNameDelegate?
    var currentNickName:String!
    var nickNameTextField:UITextField!
    var isNickNameChanged:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改昵称"
        self.setNickNameTextField()
        self.addLeftButtonItem()
        self.addRightButtonItem()
        self.setBackGround()
    }
    
    //设置背景图
    func setBackGround(){
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background")!.drawInRect(CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
    }
    
    //设置返回按钮
    func addLeftButtonItem(){
        let leftBtn:UIBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "backPersonalCenter")
        self.navigationItem.leftBarButtonItem = leftBtn
    }
    
    //设置修改密码完成按钮
    func addRightButtonItem(){
        let rightBtn:UIBarButtonItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Plain, target: self, action: "finishChangeNickName")
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    func backPersonalCenter(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func updateDataNetWork(nickName:String){
        let baseURL = NSURL(string: "http://10.1.43.56/")
        let manager = AFHTTPSessionManager(baseURL: baseURL)
        let paramDict:Dictionary = ["UID":"","user_newNickName":nickName]
        let url:String = "todolist/index.php/Home/User/ChangePassword"
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
            self.isNickNameChanged = true
            
        }) { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
            //失败回调
            print("网络调用失败:\(error)")
            self.isNickNameChanged = false
        }
    }


    func finishChangeNickName(){
        let result = self.nickNameTextField.text! as String
        if result == "" || result == self.currentNickName{
            self.navigationController?.popViewControllerAnimated(true)
        }else{
            self.updateDataNetWork(result)
            if isNickNameChanged{
                //修改本地数据库
                self.delegate?.setNewNickName(result)
                self.navigationController?.popViewControllerAnimated(true)
                let userDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                userDefault.setObject(result, forKey: "nickName")
            }
            else{
                print("后台数据更新失败，修改昵称失败!!!")
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }

    //设置昵称输入框
    func setNickNameTextField(){
        let frame:CGRect = CGRectMake(10, 15, self.view.bounds.size.width-20,30)
        self.nickNameTextField = UITextField(frame: frame)
        self.nickNameTextField.borderStyle = UITextBorderStyle.RoundedRect
        self.nickNameTextField.layer.borderWidth = 1.0
        self.nickNameTextField.becomeFirstResponder()
        self.nickNameTextField.text = self.currentNickName
        self.nickNameTextField.keyboardType = UIKeyboardType.Default
        self.view.addSubview(nickNameTextField)
    }
}
