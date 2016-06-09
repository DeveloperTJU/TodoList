//
//  MainTabBarController.swift
//  Memo
//
//  Created by hui on 16/5/18.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DatabaseService.sharedInstance.initDataTable()
        UnfinishedVC = UnfinishedViewController(title:"待办")
        FinishedVC = FinishedViewController(title:"完成")
        self.view.backgroundColor = .whiteColor()
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
        let images = ["book", "完成"]
        let imagesSelected = ["book选中", "完成选中"]
        for i in 0 ..< images.count{
            self.tabBar.backgroundColor = .whiteColor()
            self.tabBar.tintColor = UIColor(red: 236/255, green: 206/255, blue: 74/255, alpha: 1.0)
            self.tabBar.items![i].image = UIImage(named: images[i])
            self.tabBar.items![i].selectedImage = UIImage(named: imagesSelected[i])
        }
    }

}
