import UIKit




class LogInViewController: UIViewController, UITextFieldDelegate {
    
    
    var dataBase:FMDatabase!
    //用户密码输入框
    var txtUser:UITextField!
    var txtPwd:UITextField!
    var logIn:UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //获取屏幕尺寸
        let mainSize = UIScreen.mainScreen().bounds.size
        self.view.backgroundColor = UIColor.whiteColor()
        let img = UIImage(named:"background")
        let vImg = UIImageView(image: img)
        vImg.frame = CGRect(x:0,y:0,width:mainSize.width ,height:mainSize.height)
        self.view.sendSubviewToBack(vImg)
        self.view.addSubview(vImg)
      
//        //登录框背景
        let vLogin =  UIView(frame:CGRectMake(15, 150, mainSize.width - 30, 88))
        vLogin.layer.borderWidth = 0.5
        vLogin.layer.borderColor = UIColor.lightGrayColor().CGColor
        vLogin.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(vLogin)
//
        
        //用户名输入框
        txtUser = UITextField(frame:CGRectMake(0, 0, vLogin.frame.size.width , 44))
        txtUser.placeholder = "请输入用户名"
        txtUser.delegate = self
        txtUser.layer.cornerRadius = 5
        txtUser.layer.borderColor = UIColor.lightGrayColor().CGColor
        txtUser.layer.borderWidth = 0.5
        txtUser.leftView = UIView(frame:CGRectMake(0, 0, 44, 44))
        txtUser.leftViewMode = UITextFieldViewMode.Always
        
        //用户名输入框左侧图标
        let imgUser =  UIImageView(frame:CGRectMake(11, 11, 22, 22))
        imgUser.image = UIImage(named:"iconfont-user")
        txtUser.leftView!.addSubview(imgUser)
        vLogin.addSubview(txtUser)
        
        //密码输入框
        txtPwd = UITextField(frame:CGRectMake(0, 44, vLogin.frame.size.width , 44))
        txtPwd.delegate = self
        txtPwd.placeholder = "请输入密码"
        txtPwd.layer.cornerRadius = 5
        txtPwd.layer.borderColor = UIColor.lightGrayColor().CGColor
        txtPwd.layer.borderWidth = 0.5
        txtPwd.secureTextEntry = true
        txtPwd.leftView = UIView(frame:CGRectMake(0, 0, 44, 44))
        txtPwd.leftViewMode = UITextFieldViewMode.Always
        
        //密码输入框左侧图标
        let imgPwd =  UIImageView(frame:CGRectMake(11, 11, 22, 22))
        imgPwd.image = UIImage(named:"iconfont-password")
        txtPwd.leftView!.addSubview(imgPwd)
        vLogin.addSubview(txtPwd)
    
        let button:UIButton = UIButton(type:.System)
        //设置按钮位置和大小
        button.frame=CGRectMake(vLogin.frame.size.width-85, 300, 100, 22)
        //button.backgroundColor = UIColor.blackColor()

        //设置按钮文字
        button.setTitle("立即注册", forState:UIControlState.Normal)
        button.tintColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
        button.addTarget(self,action:Selector("tapped:"),forControlEvents:.TouchUpInside)
        self.view.addSubview(button)
        
        let button1:UIButton = UIButton(type:.System)
        //设置按钮位置和大小
        button1.frame=CGRectMake(15, 250, vLogin.frame.size.width , 44)
        button1.backgroundColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
        button1.tintColor = UIColor(red: 232/255, green: 208/255, blue: 120/255, alpha: 1)
       //设置按钮文字
        button1.setTitle("登录", forState:UIControlState.Normal)
        button1.addTarget(self,action:Selector("tapped1:"),forControlEvents:.TouchUpInside)
        self.view.addSubview(button1)
        
        let button2:UIButton = UIButton(type:.System)
        //设置按钮位置和大小
        button2.frame=CGRectMake(15, 300, 100, 22)
        button2.tintColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
        //button2.backgroundColor = UIColor.blackColor()
        
        //设置按钮文字
        button2.setTitle("游客模式", forState:UIControlState.Normal)
        button2.addTarget(self,action:Selector("tapped2:"),forControlEvents:.TouchUpInside)
        self.view.addSubview(button2)
        
        

        
        
    
    }
    
    func alertWindow(title:String, message:String)  {
        let alert : UIAlertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "Back")
        alert.show()
    }
    
    func tapped(button:UIButton){
        
            let ab = PhoneNumberViewController()
            self.presentViewController(ab, animated: true, completion: nil)
            print("used")
        }
    
    
    func tapped1(button:UIButton){
        
        if txtUser.text! == "" {
            alertWindow("Error", message: "Username can't be null!")
        }
        else if txtPwd.text! == "" {
            alertWindow("Error", message: "Password can't be null!")
        }
        
        else {
            let baseURL = NSURL(string: "http://10.1.45.102/")
            let manager = AFHTTPSessionManager(baseURL: baseURL)
            let paramDict:Dictionary = ["user_phoneNumber":txtUser.text!,"user_psw":txtPwd.text!.md5]
            let url:String = "todolist/index.php/Home/User/Login"
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
                
                //print("请求结果：\(resultDict)")
                let LoginSuccess = resultDict["isSuccess"] as! Int
                //登陆成功
                if LoginSuccess == 1 {
                    UserInfo.phoneNumber = self.txtUser.text!
                    //同步数据
                    let baseURL = NSURL(string: "http://10.1.45.102/")
                    let manager = AFHTTPSessionManager(baseURL: baseURL)
                    let paramDict:Dictionary = ["UID":resultDict["UID"] as! String,"TaskModel":""]
                    let url:String = "todolist/index.php/Home/Task/SynchronizeTask"
                    let UID = resultDict["UID"] as! String
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
                        
                        self.dataBase = DatabaseService.sharedInstance.getDatabase()
                        self.dataBase.open()
                        var sqlStr = "CREATE TABLE IF NOT EXISTS data_\(UserInfo.phoneNumber.md5)(TITLE TEXT, CONTENT TEXT, CREATE_TIME TEXT, LAST_EDIT_TIME TEXT, ALERT_TIME TEXT, LEVEL INT, STATE INT, PRIMARY KEY(CREATE_TIME))"
                        self.dataBase.executeUpdate(sqlStr, withArgumentsInArray: [])
                        sqlStr = "INSERT INTO data_\(UserInfo.phoneNumber.md5) VALUES (?, ?, ?, ?, ?, ?, ?)"
                        var i = 0
                        while (i < a.count){
                            self.dataBase.executeUpdate(sqlStr, withArgumentsInArray: [a[i]["title"] as! String, a[i]["content"] as! String, a[i]["createtime"] as! String, a[i]["lastedittime"] as! String, a[i]["alerttime"] as! String, Int(a[i]["level"] as! String)!, Int(a[i]["state"] as! String)!])
                            i++
                        }
                        sqlStr = "INSERT INTO USER VALUES (?, ?, ?, ?)"
                        self.dataBase.executeUpdate(sqlStr, withArgumentsInArray: [UserInfo.phoneNumber.md5, UserInfo.phoneNumber,resultDict["user_nickname"] as! String,1])
                        UserInfo.nickName = resultDict["user_nickname"] as! String
                        UserInfo.UID = UID
                        self.presentViewController(RootTabBarController(), animated: true, completion: nil)
                    }) { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
                        //失败回调
                        print("网络调用失败:\(error)")
                    }
                }
                else{
                    self.alertWindow("错误", message: "用户名或密码错误")
                }
                
                
            }) { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
                //失败回调
                print("网络调用失败:\(error)")
            }
            
            
            
        }
        
        
}
    
    
    func tapped2(button:UIButton){
        
        UserInfo.phoneNumber = "Visitor"
        UnfinishedVC = UnfinishedViewController(title: "待办")
        FinishedVC = FinishedViewController(title: "完成")
        let rootVC = RootTabBarController()
        self.presentViewController(rootVC, animated: true, completion: nil)
    }
    
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//登录框状态枚举
enum LoginShowType {
    case NONE
    case USER
    case PASS
}