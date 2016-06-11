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

class ChangeNicknameController: UIViewController,UITextFieldDelegate {

    var delegate:ChangeNicknameDelegate?
    var nicknameTextField:UITextField!
    var isNicknameChanged:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改昵称"
        self.setNicknameTextField()
        self.addLeftButtonItem()
        self.addRightButtonItem()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }
    
    //设置昵称输入框
    func setNicknameTextField(){
        let frame:CGRect = CGRectMake(10, 15, self.view.bounds.size.width-20,30)
        self.nicknameTextField = UITextField(frame: frame)
        self.nicknameTextField.borderStyle = .RoundedRect
        self.nicknameTextField.layer.borderWidth = 1.0
        self.nicknameTextField.becomeFirstResponder()
        self.nicknameTextField.placeholder = "请输入用户昵称"
        self.nicknameTextField.text = UserInfo.nickname
        self.nicknameTextField.keyboardType = .Default
        self.nicknameTextField.delegate = self
        self.nicknameTextField.leftView = UIView(frame:CGRectMake(0, 0, 44, 44))
        self.nicknameTextField.leftViewMode = UITextFieldViewMode.Always
        let imgUser =  UIImageView(frame:CGRectMake(11, 11, 22, 22))
        imgUser.image = UIImage(named:"灰手机")
        self.nicknameTextField.leftView!.addSubview(imgUser)
        self.view.addSubview(nicknameTextField)
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
    
    
    func updateDataNetWork(nickname:String){
        let url:String = "todolist/index.php/Home/User/ChangeNickname"
        let paramDict = ["UID":UserInfo.UID, "user_newNickname":nickname]
        RequestAPI.POST(url, body: paramDict, succeed: { (task:NSURLSessionDataTask!, responseObject:AnyObject?) -> Void in
            //成功回调
            let resultDict = try! NSJSONSerialization.JSONObjectWithData(responseObject as! NSData, options: NSJSONReadingOptions.MutableContainers)
            print("请求结果：\(resultDict)")
            self.isNicknameChanged = true
            
        }) { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
            //失败回调
            print("网络调用失败:\(error)")
            self.isNicknameChanged = false
        }
    }
    
    func updateNickname(){
        let reachability = Reachability.reachabilityForInternetConnection()
        let nickname = self.nicknameTextField.text! as String
        self.updateDataNetWork(nickname)
        if reachability!.isReachable(){
            self.showAlert("网络连接失败")
        }else if !isNicknameChanged{
            self.showAlert("修改昵称成功")
            UserInfo.nickname = nickname
            self.delegate?.setNewNickname(nickname)
        }else{
            self.showAlert("上传数据失败，修改昵称失败")
        }
    }

//    func updateNickname() -> Void{
//        let result = self.nicknameTextField.text! as String
//        let reachability = Reachability.reachabilityForInternetConnection()
//        if result == "" || result == UserInfo.nickname{
//            self.navigationController?.popViewControllerAnimated(true)
//        }
//        else if !reachability!.isReachable(){
//            self.showAlert("网络连接失败",nickName: "")
//        }
//        else{
//            let url:String = "todolist/index.php/Home/User/ChangeNickname"
//            let paramDict = ["UID":UserInfo.UID, "user_newNickname":result]
//            RequestAPI.POST(url, body: paramDict, succeed: { (task:NSURLSessionDataTask!, responseObject:AnyObject?) -> Void in
//                let resultDict = try! NSJSONSerialization.JSONObjectWithData(responseObject as! NSData, options: NSJSONReadingOptions.MutableContainers)
//                if resultDict["isSuccess"] as! Int == 1 {
//                    UserInfo.nickname = result
//                    DatabaseService.sharedInstance.updateNickname()
//                    //刷新界面显示的nickname
//                    self.showAlert("修改昵称成功", nickName: result)
//                }
//                else{
//                    self.showAlert("上传数据失败，修改昵称失败", nickName: "")
//                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                    hud.mode = MBProgressHUDMode.Text
//                    hud.label.text = "上传失败!"
//                    hud.hideAnimated(true, afterDelay: 0.5)
//                }
//            }, failed: { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
//                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                hud.mode = MBProgressHUDMode.Text
//                hud.label.text = "上传失败!"
//                hud.hideAnimated(true, afterDelay: 0.5)
//                self.showAlert("上传数据失败，修改昵称失败", nickName: "")
//            })
//        }
//    }
    
    func showAlert(message:String){
        let alert:UIAlertController = UIAlertController(title: "提示", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: { (cancelAction) in
            if message == "修改昵称成功"{
                self.navigationController?.popViewControllerAnimated(true)
            }else if message == "上传数据失败，修改昵称失败"{
                self.navigationController?.popViewControllerAnimated(true)
            }
        })
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }


}
