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
        let dictArr = DatabaseService.sharedInstance.selectLocalData()
        let paramDict = ["UID":"700a0d94dd539543bad0d3a237ae53b5", "TaskModelArr":dictArr]
        let url:String = "todolist/index.php/Home/Task/SynchronizeTask"
        RequestAPI.POST(url, body: paramDict, succeed: succeed, failed: failed)

    }
    func succeed(task:NSURLSessionDataTask!,responseObject:AnyObject!)->Void{
        print("oh my god  成功了+\(responseObject)")
        print("success")
        let resultDict = try! NSJSONSerialization.JSONObjectWithData(responseObject as! NSData, options: NSJSONReadingOptions.MutableContainers)
        print("请求结果：\(resultDict)")
    }
    
    func failed(task:NSURLSessionDataTask!,error:NSError!)->Void{
        print("oh shit 失败了")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

