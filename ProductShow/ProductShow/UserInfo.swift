//
//  UserInfo.swift
//  ProductShow
//
//  Created by s on 15/10/17.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import Foundation

/*
postDic={
    username:""
    pwd:""
    UserState:1(LoginState)
}
*/


class LoginInfo: NSObject{
    private var _loginDic: NSDictionary?
    
    init(loginDic: NSDictionary) {
        _loginDic = loginDic
    }
    
    init(username: String, pwd: String) {
        _loginDic = [jfusername: username, jfpwd: pwd]
    }
    
    override init(){
        
    }
    
    var loginDic: NSDictionary?{
        get{
            return _loginDic
        }
        set{
            _loginDic = newValue
        }
    }
    
    var username: String?{
        get{
            return _loginDic?.objectForKey(jfusername) as? String
        }
    }
    
    var pwd: String?{
        get{
            return _loginDic?.objectForKey(jfpwd) as? String
        }
    }
}

class User: NSObject{
    private var _userDic: NSDictionary?
    
    init(userDic: NSDictionary) {
        _userDic = userDic
    }
    
    override init(){
        
    }
    
    var userDic: NSDictionary?{
        get{
            return _userDic
        }
        set{
            _userDic = newValue
        }
    }
    
    var uid: Int?{
        return _userDic?.objectForKey(jfuid) as? Int
    }
    
    var uname: String?{
        return _userDic?.objectForKey(jfuname) as? String
    }
    
    var tel: String?{
        return _userDic?.objectForKey(jftel) as? String
    }
    
    var mail: String?{
        return _userDic?.objectForKey(jfmail) as? String
    }
    
    var weixin: String?{
        return _userDic?.objectForKey(jfweixin) as? String
    }
    
    var qq: String?{
        return _userDic?.objectForKey(jfqq) as? String
    }
    
    var state: Int?{
        return _userDic?.objectForKey(jfstate) as? Int
    }
    
    var userNo: String?{
        return _userDic?.objectForKey(jfuserNo) as? String
    }
    
    var sex: Int?{
        return _userDic?.objectForKey(jfsex) as? Int
    }
    
    var deptId: Int?{
        return _userDic?.objectForKey(jfdeptId) as? Int
    }
    
    var dept: String?{
        return _userDic?.objectForKey(jfdept) as? String
    }
    
    var role: String?{
        return _userDic?.objectForKey(jfrole) as? String
    }
    
    var deptNo: String?{
        return _userDic?.objectForKey(jfdeptNo) as? String
    }
    
    var authCode: String?{
        return _userDic?.objectForKey(jfauthCode) as? String
    }
    
    func stringForKey(key: String)->String?{
        let objOpt = _userDic?.objectForKey(key)
        if let obj = objOpt{
            return "\(obj)"
        }
        return nil
    }
    
}

class UserInfoSaveKey{
//    static var state = "UserInfoSaveKey.state"
    static var loginDic = "UserInfoSaveKey.loginDic"
    static var returnDic = "UserInfoSaveKey.returnDic"
}

//class UserState{
//    static var Key = "UserState.Key"
//    static var SignedIn = "UserState.SignedIn"
//    static var SignedOut = "UserState.SignedOut"
//}

class UserInfo: ReturnDic {
    //单例
    private static var _userInfo: UserInfo?
    class func defaultUserInfo()->UserInfo {
        if _userInfo == nil{
            _userInfo = UserInfo()
            
            _userInfo?.readLocalLoginData()
        }
        return _userInfo!
    }
    
    //提交的信息
    private var _loginDic: NSDictionary?
    
    
    //状态 初始状态为“” 登录状态 注销状态
//    private var _state = ""
    //返回 0:未登录 1:已登录
    var state: Int{
        get{
            if _returnDic != nil{
                return 1
            }
            return 0
        }
    }
    //MARK: 发送的数据
    var loginInfo: LoginInfo?{
        get{
            if _loginDic != nil{
                return LoginInfo(loginDic: _loginDic!)
            }
            return nil
        }
        set{
            _loginDic = newValue?.loginDic
            save()
        }
        
    }
    //注销
    func signout(){
        _returnDic = nil
    }
    
    func readLocalLoginData(){
        
        let loginDicData = NSUserDefaults.standardUserDefaults().objectForKey(UserInfoSaveKey.loginDic) as? NSData
        if loginDicData != nil{
            let loginDic = try! NSJSONSerialization.JSONObjectWithData(loginDicData!, options: NSJSONReadingOptions.MutableContainers)
            _loginDic = loginDic as? NSDictionary
        }
        
    }
    
    func readLocalReturnData(){
        
        let returnDicData = NSUserDefaults.standardUserDefaults().objectForKey(UserInfoSaveKey.returnDic) as? NSData
        if returnDicData != nil{
            let returnDic = try! NSJSONSerialization.JSONObjectWithData(returnDicData!, options: NSJSONReadingOptions.MutableContainers)
            _returnDic = returnDic as? NSDictionary
        }
    }
    
    func save(){

        if _loginDic != nil{
        
            let data = try! NSJSONSerialization.dataWithJSONObject(_loginDic!, options: NSJSONWritingOptions())
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: UserInfoSaveKey.loginDic)
        }
        
        if _returnDic != nil{
            
            let data = try! NSJSONSerialization.dataWithJSONObject(_returnDic!, options: NSJSONWritingOptions())
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: UserInfoSaveKey.returnDic)
        }
    }
    
    
    var firstUser: User?{
        //用户信息
        let data = _returnDic?.objectForKey(jfdata) as? NSDictionary
        let dt = data?.objectForKey(jfdt) as? NSArray
        let firstUserDic = dt?.objectAtIndex(0) as? NSDictionary
        let user = User()
        user.userDic = firstUserDic
        return user
    }
    
}


















