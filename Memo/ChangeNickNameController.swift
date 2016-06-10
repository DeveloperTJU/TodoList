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
    var nickNameTextField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改昵称"
        self.setNickNameTextField()
        self.addLeftButtonItem()
        self.addRightButtonItem()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
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
    
    func updateDataNetWork(nickName:String) -> Bool{
        let url:String = "todolist/index.php/Home/User/ChangePassword"
        let paramDict:Dictionary = ["UID":UserInfo.UID, "user_newnickName":nickName]
        var isNickNameChanged = false
        RequestAPI.POST(url, body: paramDict, succeed: { (task:NSURLSessionDataTask!, responseObject:AnyObject?) -> Void in
            //成功回调
            print("success")
            let resultDict = try! NSJSONSerialization.JSONObjectWithData(responseObject as! NSData, options: NSJSONReadingOptions.MutableContainers)
            print("请求结果：\(resultDict)")
            isNickNameChanged = true
        }, failed: { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
            //失败回调
            print("网络调用失败:\(error)")
        })
        return isNickNameChanged
    }

    func finishChangeNickName(){
        let result = self.nickNameTextField.text! as String
        if result == "" || UserInfo.nickName == "" || result == UserInfo.nickName{
            self.navigationController?.popViewControllerAnimated(true)
        }else{
            if self.updateDataNetWork(result){
                //修改本地数据库
                //应该在Database封装一个updateUser方法，此处调用。
                let userDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                userDefault.setObject(result, forKey: "nickName")
            }
            else{
                //要提示用户的print()要换成MBProgressHud，用法参考BaseViewController。
                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                hud.mode = MBProgressHUDMode.Text
                hud.label.text = "上传数据失败，修改昵称失败!"
                hud.hideAnimated(true, afterDelay: 0.5)
            }
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

    //设置昵称输入框
    func setNickNameTextField(){
        let frame:CGRect = CGRectMake(10, 15, self.view.bounds.size.width-20,30)
        self.nickNameTextField = UITextField(frame: frame)
        self.nickNameTextField.borderStyle = .RoundedRect
        self.nickNameTextField.layer.borderWidth = 1.0
        self.nickNameTextField.becomeFirstResponder()
        self.nickNameTextField.text = UserInfo.nickName
        self.nickNameTextField.keyboardType = .Default
        self.view.addSubview(nickNameTextField)
    }
}
