//
//  RequestAPI.swift
//  Memo
//
//  Created by zyf on 16/6/8.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

typealias Succeed = (NSURLSessionDataTask!,AnyObject!)->Void
typealias Failure = (NSURLSessionDataTask!,NSError!)->Void

class RequestAPI: NSObject {
    
    //普通post网络请求
    class func POST(url:String!,body:AnyObject?,succeed:Succeed,failed:Failure) {
        if UserInfo.phoneNumber == "Visitor"{
            return
        }
        let mysucceed:Succeed = succeed
        let myfailure:Failure = failed
        RequestClient.sharedInstance.POST(url, parameters: body, success: { (task:NSURLSessionDataTask, responseObject:AnyObject?) -> Void in
            mysucceed(task,responseObject)
        }) { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
            myfailure(task,error)
        }
    }
    
    class func SynchronizeTask(afterEvent:Int){
        let url = "todolist/index.php/Home/Task/SynchronizeTask"
        let paramDict = ["UID":UserInfo.UID, "TaskModel":DatabaseService.sharedInstance.selectLocalData()]
        RequestAPI.POST(url, body: paramDict, succeed: { (task:NSURLSessionDataTask!, responseObject:AnyObject?) -> Void in
            //成功回调
            let resultDict = try! NSJSONSerialization.JSONObjectWithData(responseObject as! NSData, options: NSJSONReadingOptions.MutableContainers)
            let arr = resultDict["taskModelArr"] as! NSArray
            for task in arr{
                let data = ItemModel(title: task["title"] as! String, content: task["content"] as! String, createTime: task["createtime"] as! String, lastEditTime: task["lastedittime"] as! String, alertTime: task["alerttime"] as! String, level: Int(task["level"] as! String)!, state: Int(task["state"] as! String)!)
                if !DatabaseService.sharedInstance.insertInDB(data){
                    DatabaseService.sharedInstance.updateInDB(data)
                }
            }
            UserInfo.nickname = resultDict["user_nickname"] as! String
            if !DatabaseService.sharedInstance.insertUser(UserInfo.UID, phoneNumber: UserInfo.phoneNumber, nickname: UserInfo.nickname, isCurrentUser: 1){
                DatabaseService.sharedInstance.updateNickname()
            }
            DatabaseService.sharedInstance.clearDeletedData()
            switch afterEvent{
            case 0:
                (RequestClient.sharedInstance.delegate as! LogInViewController).presentViewController(RootTabBarController(), animated: true, completion: nil)
            case 1:
                (RequestClient.sharedInstance.delegate as! BaseViewController).reloadDatabase()
                let hud = MBProgressHUD.showHUDAddedTo((RequestClient.sharedInstance.delegate as! BaseViewController).view, animated: true)
                hud.mode = MBProgressHUDMode.Text
                hud.label.text = "同步成功"
                hud.hideAnimated(true, afterDelay: 0.5)
            default:
                break
            }
        }) { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
            switch afterEvent{
            case 0:
                let hud = MBProgressHUD.showHUDAddedTo((RequestClient.sharedInstance.delegate as! LogInViewController).view, animated: true)
                hud.mode = MBProgressHUDMode.Text
                hud.label.text = "登录失败"
                hud.hideAnimated(true, afterDelay: 0.5)
            case 1:
                let hud = MBProgressHUD.showHUDAddedTo((RequestClient.sharedInstance.delegate as! BaseViewController).view, animated: true)
                hud.mode = MBProgressHUDMode.Text
                hud.label.text = "同步失败"
                hud.hideAnimated(true, afterDelay: 0.5)
            default:
                break
            }
        }
    }
}