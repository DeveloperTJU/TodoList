//
//  ChangeNicknameController.swift
//  Memo
//
//  Created by tjise on 16/6/7.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

protocol ChangeNicknameDelegate{
    func setNewNickname(newNickname:String)
}

class ChangeNicknameController: UIViewController {

    var delegate:ChangeNicknameDelegate?
    var nicknameTextField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改昵称"
        self.setNicknameTextField()
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
        let rightBtn:UIBarButtonItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Plain, target: self, action: "updateNickname")
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    func backPersonalCenter(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func updateNickname() -> Void{
        let result = self.nicknameTextField.text! as String
        if result == "" || result == UserInfo.nickname{
            self.navigationController?.popViewControllerAnimated(true)
        }
        else{
            let url:String = "todolist/index.php/Home/User/ChangeNickname"
            let paramDict = ["UID":UserInfo.UID, "user_newNickname":result]
            RequestAPI.POST(url, body: paramDict, succeed: { (task:NSURLSessionDataTask!, responseObject:AnyObject?) -> Void in
                let resultDict = try! NSJSONSerialization.JSONObjectWithData(responseObject as! NSData, options: NSJSONReadingOptions.MutableContainers)
                if resultDict["isSuccess"] as! Int == 1 {
                    UserInfo.nickname = result
                    DatabaseService.sharedInstance.updateNickname()
                    //刷新界面显示的nickname
                }
                else{
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text
                    hud.label.text = "上传失败!"
                    hud.hideAnimated(true, afterDelay: 0.5)
                }
            }, failed: { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                hud.mode = MBProgressHUDMode.Text
                hud.label.text = "上传失败!"
                hud.hideAnimated(true, afterDelay: 0.5)
            })
        }
    }

    //设置昵称输入框
    func setNicknameTextField(){
        let frame:CGRect = CGRectMake(10, 15, self.view.bounds.size.width-20,30)
        self.nicknameTextField = UITextField(frame: frame)
        self.nicknameTextField.borderStyle = .RoundedRect
        self.nicknameTextField.layer.borderWidth = 1.0
        self.nicknameTextField.becomeFirstResponder()
        self.nicknameTextField.text = UserInfo.nickname
        self.nicknameTextField.keyboardType = .Default
        self.view.addSubview(nicknameTextField)
    }
}
