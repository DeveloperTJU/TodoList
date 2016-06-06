//
//  ViewController.swift
//  L008WebServiceDemo
//
//  Created by tjufe on 16/6/3.
//  Copyright © 2016年 tjufe. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let baseURL = NSURL(string: "http://10.1.43.56/")
        let manager = AFHTTPSessionManager(baseURL: baseURL)
        let paramDict:Dictionary = ["UID":"700a0d94dd539543bad0d3a237ae53b5"]
        let url:String = "todolist/index.php/Home/Task//SynchronizeTask"
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
            
            print(a[0]["alerttime"])
            
            
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

