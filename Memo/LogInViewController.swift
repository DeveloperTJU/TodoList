import UIKit




class LogInViewController: UIViewController, UITextFieldDelegate, RequestClientDelegate {
    
    //用户密码输入框
    var txtUser:UITextField!
    var txtPwd:UITextField!
    var logIn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //获取屏幕尺寸
        let mainSize = self.view.bounds.size
        self.view.backgroundColor = .whiteColor()
        let img = UIImage(named:"background")
        let vImg = UIImageView(image: img)
        vImg.frame = CGRect(x:0,y:0,width:mainSize.width ,height:mainSize.height)
        self.view.sendSubviewToBack(vImg)
        self.view.addSubview(vImg)
      
        //登录框背景
        let vLogin = UIView(frame:CGRectMake(10, 190, mainSize.width - 20, 88))
        self.view.addSubview(vLogin)
        vLogin.addSubview(MyRect(frame: CGRectMake(0, 41, mainSize.width - 20, 3)))
        vLogin.layer.cornerRadius = 3
        vLogin.backgroundColor = .whiteColor()
        
        //用户名输入框
        txtUser = UITextField(frame:CGRectMake(0, 0, vLogin.frame.size.width , 44))
        txtUser.placeholder = "请输入用户名"
        txtUser.delegate = self
        txtUser.leftView = UIView(frame:CGRectMake(0, 0, 44, 44))
        txtUser.leftViewMode = UITextFieldViewMode.Always
        
        //用户名输入框左侧图标
        let imgUser =  UIImageView(frame:CGRectMake(11, 11, 22, 22))
        imgUser.image = UIImage(named:"灰手机")
        txtUser.leftView!.addSubview(imgUser)
        vLogin.addSubview(txtUser)
        
        //密码输入框
        txtPwd = UITextField(frame:CGRectMake(0, 44, vLogin.frame.size.width , 44))
        txtPwd.delegate = self
        txtPwd.placeholder = "请输入密码"
        txtPwd.secureTextEntry = true
        txtPwd.leftView = UIView(frame:CGRectMake(0, 0, 44, 44))
        txtPwd.leftViewMode = UITextFieldViewMode.Always
        
        //密码输入框左侧图标
        let imgPwd =  UIImageView(frame:CGRectMake(11, 11, 22, 22))
        imgPwd.image = UIImage(named:"灰锁")
        txtPwd.leftView!.addSubview(imgPwd)
        vLogin.addSubview(txtPwd)
    
        let button:UIButton = UIButton(type:.System)
        //设置按钮位置和大小
        button.frame = CGRectMake(10, 340, 100, 22)

        //设置按钮文字
        button.setTitle("立即注册", forState:UIControlState.Normal)
        button.tintColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
        button.addTarget(self,action:Selector("tapped:"),forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
        
        let button1:UIButton = UIButton(type:.System)
        //设置按钮位置和大小
        button1.frame = CGRectMake(10, 290, vLogin.frame.size.width , 44)
        button1.backgroundColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
        button1.tintColor = UIColor(red: 232/255, green: 208/255, blue: 120/255, alpha: 1)
        button1.layer.cornerRadius = 4
        //设置按钮文字
        button1.setTitle("登   录", forState:UIControlState.Normal)
        button1.addTarget(self,action:Selector("tapped1:"),forControlEvents: .TouchUpInside)
        self.view.addSubview(button1)
        
        let button2:UIButton = UIButton(type:.System)
        //设置按钮位置和大小
        button2.frame = CGRectMake(vLogin.frame.size.width-85, 340, 100, 22)
        button2.tintColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
        
        //设置按钮文字
        button2.setTitle("游客模式", forState:UIControlState.Normal)
        button2.addTarget(self,action:Selector("tapped2:"),forControlEvents: .TouchUpInside)
        self.view.addSubview(button2)
    }
    
    func alertWindow(title:String, message:String)  {
        let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "Back")
        alert.show()
    }
    
    func tapped(button:UIButton){
        self.presentViewController(PhoneNumberViewController(), animated: true, completion: nil)
    }
    
    func tapped1(button:UIButton){
        if txtUser.text! == "" {
            alertWindow("Error", message: "请输入用户名")
        }
        else if txtPwd.text! == "" {
            alertWindow("Error", message: "请输入密码")
        }
        else {
            UserInfo.phoneNumber = txtUser.text!
            let url:String = "todolist/index.php/Home/User/Login"
            let paramDict:Dictionary = ["user_phoneNumber":UserInfo.phoneNumber,"user_psw":txtPwd.text!.md5]
            RequestAPI.POST(url, body: paramDict, succeed: { (task:NSURLSessionDataTask!, responseObject:AnyObject?) -> Void in
                //成功回调
                let resultDict = try! NSJSONSerialization.JSONObjectWithData(responseObject as! NSData, options: NSJSONReadingOptions.MutableContainers)
                //登陆成功
                if resultDict["isSuccess"] as! Int == 1 {
                    UserInfo.UID = resultDict["UID"] as! String
                    UserInfo.phoneNumber = self.txtUser.text!
                    DatabaseService.sharedInstance.initDataTable()
                    DatabaseService.sharedInstance.updateLoginState(1)
                    //同步数据
                    RequestClient.sharedInstance.delegate = self
                    RequestAPI.SynchronizeTask(0)
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
        UserInfo.nickname = "Visitor"
        DatabaseService.sharedInstance.initDataTable()
        self.presentViewController(RootTabBarController(), animated: true, completion: nil)
    }
    
}

//登录框状态枚举
enum LoginShowType {
    case NONE
    case USER
    case PASS
}