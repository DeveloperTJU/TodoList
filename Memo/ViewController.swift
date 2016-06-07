//
//  ViewController.swift
//  L008WebServiceDemo
//
//  Created by tjufe on 16/6/3.
//  Copyright © 2016年 tjufe. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    var dataBase:FMDatabase!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let baseURL = NSURL(string: "http://172.26.209.192/")
        let manager = AFHTTPSessionManager(baseURL: baseURL)
        let paramDict:Dictionary = ["UID":"76363ece3d879620e4e101ef74c65050","TaskModel":""]
        let url:String = "todolist/index.php/Home/Task/SynchronizeTask"
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
            let a = resultDict["taskModelArr"] as! NSArray
            print(a.count)
//            self.dataBase = DataBaseService.sharedInstance.getDataBase()
//            self.dataBase.open()
//            var sqlStr = "CREATE TABLE IF NOT EXISTS data_test(TITLE TEXT, CONTENT TEXT, CREATE_TIME TEXT, LAST_EDIT_TIME TEXT, ALERT_TIME TEXT, LEVEL INT, STATE INT, PRIMARY KEY(CREATE_TIME))"
//            self.dataBase.executeUpdate(sqlStr, withArgumentsInArray: [])
//             sqlStr = "INSERT INTO data_test VALUES (?, ?, ?, ?, ?, ?, ?)"
//            var i = 0
//            while (i < a.count){
//            self.dataBase.executeUpdate(sqlStr, withArgumentsInArray: [a[i]["title"] as! String, a[i]["content"] as! String, a[i]["createtime"] as! String, a[i]["lastedittime"] as! String, a[i]["alerttime"] as! String, Int(a[i]["level"] as! String)!, Int(a[i]["state"] as! String)!])
//                i++
//            }
//            var level = a[0]["level"] as! String
//            print(Int(level)! )
//            print(a[0])
////            var isSuccess = resultDict["isSuccess"] as! Int
////            print(isSuccess == 1)
//            print(resultDict["user_nickname"])
            
            }) { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
                //失败回调
                print("网络调用失败:\(error)")
        }
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

