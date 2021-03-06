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
typealias uploadBlock = (AFMultipartFormData!)->Void

class RequestAPI: NSObject {
    
    //upload picture
    class func UploadPicture(url:String!,body:AnyObject?,block:uploadBlock!,succeed:Succeed,failed:Failure)->Void
    {
        let mysucceed:Succeed = succeed
        let myfailure:Failure = failed
        RequestClient.sharedInstance.POST(url, parameters: body, constructingBodyWithBlock: { (data:AFMultipartFormData) in
            block(data)
            }, success: { (task:NSURLSessionDataTask, responseObject:AnyObject?) in
                mysucceed(task,responseObject)
            }) { (task:NSURLSessionDataTask?, error:NSError?) in
                myfailure(task,error)
        }
    }
    
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
        let url = "index.php/Home/Task/SynchronizeTask"
        let paramDict = ["UID":UserInfo.UID, "TaskModelArr":DatabaseService.sharedInstance.selectLocalData()]
        RequestAPI.POST(url, body: paramDict, succeed: { (task:NSURLSessionDataTask!, responseObject:AnyObject?) -> Void in
            let resultDict = try! NSJSONSerialization.JSONObjectWithData(responseObject as! NSData, options: NSJSONReadingOptions.MutableContainers)
            if resultDict["isSuccess"] as! Bool{
                var arr = resultDict["taskModelArr"]!["insert"] as! NSArray
                for task in arr{
                    let data = ItemModel(title: task["title"] as! String, content: task["content"] as! String, createTime: task["createtime"] as! String, lastEditTime: task["lastedittime"] as! String, timestamp: task["timestamp"] as! String, alertTime: task["alerttime"] as! String, level: Int(task["level"] as! String)!, state: Int(task["state"] as! String)!)
                    DatabaseService.sharedInstance.insertInDB(data)
                }
                arr = resultDict["taskModelArr"]!["update"] as! NSArray
                for task in arr{
                    let data = ItemModel(title: task["title"] as! String, content: task["content"] as! String, createTime: task["createtime"] as! String, lastEditTime: task["lastedittime"] as! String, timestamp: task["timestamp"] as! String, alertTime: task["alerttime"] as! String, level: Int(task["level"] as! String)!, state: Int(task["state"] as! String)!)
                    DatabaseService.sharedInstance.updateInDB(data)
                }
                let timeArr = resultDict["taskModelArr"]!["delete"] as! NSArray
                for createTime in timeArr{
                    DatabaseService.sharedInstance.deleteInDB(createTime as! String)
                }
                UserInfo.nickname = resultDict["user_nickname"] as! String
                DatabaseService.sharedInstance.refreshUser(UserInfo.UID, phoneNumber: UserInfo.phoneNumber, nickname: UserInfo.nickname, isCurrentUser: 1)
                DatabaseService.sharedInstance.clearDeletedData()
                switch afterEvent{
                case 0:
                    (RequestClient.sharedInstance.delegate as! LogInViewController).presentViewController(RootTabBarController(), animated: true, completion:{
                        (RequestClient.sharedInstance.delegate as! LogInViewController).indicator.stopAnimating()
                    })
                case 1:
                    UnfinishedVC.reloadDatabase() //随便调任何一个就可以同时刷新两个TableView
                    let hud = MBProgressHUD.showHUDAddedTo((RequestClient.sharedInstance.delegate as! BaseViewController).view, animated: true)
                    hud.mode = MBProgressHUDMode.Text
                    hud.label.text = "同步成功"
                    hud.hideAnimated(true, afterDelay: 0.5)
                    (RequestClient.sharedInstance.delegate as! BaseViewController).mainTableView.mj_header.endRefreshing()
                default:
                    break
                }
            }
            else{
                let alert = UIAlertController(title: "提示", message: "数据同步出错，请稍后重试", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "确定", style: .Cancel, handler: nil))
                switch afterEvent{
                case 0:
                    let rootTabBarVC = RootTabBarController()
                    (RequestClient.sharedInstance.delegate as! LogInViewController).presentViewController(rootTabBarVC, animated: true, completion: nil)
                    UnfinishedVC.presentViewController(alert, animated: true, completion: nil)
                case 1:
                    (RequestClient.sharedInstance.delegate as! UIViewController).presentViewController(alert, animated: true, completion: nil)
                default:
                    break
                }
            }
        }) { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
            print(error)
            let hud = MBProgressHUD.showHUDAddedTo((RequestClient.sharedInstance.delegate as! UIViewController).view, animated: true)
            hud.mode = MBProgressHUDMode.Text
            hud.label.text = "网络连接失败"
            hud.hideAnimated(true, afterDelay: 0.5)
        }
    }
}