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
        let mysucceed:Succeed = succeed
        let myfailure:Failure = failed
        RequestClient.sharedInstance.POST(url, parameters: body, success: { (task:NSURLSessionDataTask, responseObject:AnyObject?) -> Void in
            mysucceed(task,responseObject)
            
        }) { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
            myfailure(task,error)
        }
        
    }
    //向服务器同步数据
//    class func SynchronizeTask(url:String!,body:AnyObject?,succeed:Succeed,failed:Failure) {
//        let mysucceed:Succeed = succeed
//        let myfailure:Failure = failed
////        dataBase = DataBaseService.sharedInstance.getDataBase()
////        dataBase.open()
////        var dictArr = Dictionary<String, AnyObject>()
////        var sqlStr = "SELECT * FROM data_4e68b6e728333fcc4b606fc760658356"
////        let rs:FMResultSet = dataBase.executeQuery(sqlStr, withArgumentsInArray: [])
////        while rs.next(){
////            var data:NSDictionary = ["title": rs.stringForColumn("TITLE"), "content": rs.stringForColumn("CONTENT"), "createtime": rs.stringForColumn("CREATE_TIME"), "lastedittime": rs.stringForColumn("LAST_EDIT_TIME"), "alerttime": rs.stringForColumn("ALERT_TIME"), "level": rs.longForColumn("LEVEL"), "state": rs.longForColumn("STATE")]
////            dictArr["\(rs.stringForColumn("CREATE_TIME"))"] = data
////            
////        }
//        RequestClient.sharedInstance.POST(url, parameters: body, success: { (task:NSURLSessionDataTask, responseObject:AnyObject?) -> Void in
//            mysucceed(task,responseObject)
//            
//            
//        }) { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
//            myfailure(task,error)
//        }
//        
//    }
}