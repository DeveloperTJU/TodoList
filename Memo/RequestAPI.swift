//
//  RequestAPI.swift
//  Memo
//
//  Created by zyf on 16/6/8.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit
//var dataBase:FMDatabase!
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
    
    class func SynchronizeTask(){
        let url = "todolist/index.php/Home/Task/SynchronizeTask"
        let a = DatabaseService.sharedInstance.selectLocalData()
        print(a)
        let paramDict = ["UID":UserInfo.UID, "TaskModel":a]
        RequestAPI.POST(url, body: paramDict, succeed: { (task:NSURLSessionDataTask!, responseObject:AnyObject?) -> Void in
            //成功回调
            let resultDict = try! NSJSONSerialization.JSONObjectWithData(responseObject as! NSData, options: NSJSONReadingOptions.MutableContainers)
            let arr = resultDict["taskModelArr"] as! NSArray
            for task in arr{
                let data = ItemModel(title: task["title"] as! String, content: task["content"] as! String, createTime: task["createtime"] as! String, lastEditTime: task["lastedittime"] as! String, alertTime: task["alerttime"] as! String, level: Int(task["level"] as! String)!, state: Int(task["state"] as! String)!)
                if !DatabaseService.sharedInstance.updateInDB(data){
                    DatabaseService.sharedInstance.insertInDB(data)
                }
            }
            UserInfo.nickName = resultDict["user_nickname"] as! String
            if !DatabaseService.sharedInstance.updateUser(1){
                DatabaseService.sharedInstance.insertUser(UserInfo.UID, phoneNumber: UserInfo.phoneNumber, nickName: UserInfo.nickName, isCurrentUser: 1)
            }
            DatabaseService.sharedInstance.clearDeletedData()
        }) { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
        }
    }
}