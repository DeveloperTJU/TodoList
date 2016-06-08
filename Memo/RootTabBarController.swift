//
//  MainTabBarController.swift
//  Memo
//
//  Created by hui on 16/5/18.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

struct UserInfoStruct {
    var nickName:String!
    var UID:String!
    var phoneNumber:String!
}

let UnfinishedVC:UnfinishedViewController = UnfinishedViewController(title:"待办")
let FinishedVC:FinishedViewController = FinishedViewController(title:"完成")
let UserVC:UserViewController = UserViewController()
let UserInfo = UserInfoStruct()

class RootTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.viewControllers = self.loadNavControllers([UnfinishedVC, FinishedVC])
        self.setUpTabBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadNavControllers(vcArr:[UIViewController])->[CustomNavController]{
        var navArr = [CustomNavController]()
        for i in 0 ..< vcArr.count{
            navArr.append(CustomNavController(rootViewController:vcArr[i]))
        }
        return navArr
    }
    
    func setUpTabBar(){
        let images = ["unfinished", "finished"]
        let imagesSelected = ["unfinished_selected", "finished_selected"]
        for i in 0 ..< images.count{
            self.tabBar.backgroundColor = UIColor.whiteColor()
            self.tabBar.tintColor = UIColor(red: 236/255, green: 206/255, blue: 74/255, alpha: 1.0)
            self.tabBar.items![i].image = RootTabBarController.compressImage(image: UIImage(named: images[i])!, toSize: CGSizeMake(20, 20))
            self.tabBar.items![i].selectedImage = RootTabBarController.compressImage(image: UIImage(named: imagesSelected[i])!, toSize: CGSizeMake(20, 20))

        }
    }

    static func compressImage(image image:UIImage, toSize size:CGSize)->UIImage{
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let compressImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return compressImage
    }

}
