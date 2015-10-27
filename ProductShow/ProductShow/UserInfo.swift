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
}
*/

let kUserSignOutNotification = "kUserSignOutNotification"

class Login: NSObject{
    private var _loginDic: NSDictionary?
    
    init(loginDic: NSDictionary) {
        _loginDic = loginDic
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
        return _loginDic?.objectForKey(jfusername) as? String
    }
    
    var pwd: String?{
        return _loginDic?.objectForKey(jfpwd) as? String
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

class UserInfo: ReturnDic {
    
    private static var _userInfo = UserInfo()
    class func defaultUserInfo()->UserInfo {
        return _userInfo
    }
    
    private var _postDic: NSDictionary?
    
    var PostDic: NSDictionary?{
        get{
            return _postDic
        }
        set{
            _postDic = newValue
        }
    }
    
    func signout(){
        _returnDic = nil
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: jfpwd)
        NSNotificationCenter.defaultCenter().postNotificationName(kUserSignOutNotification, object: nil)
    }
    
    //MARK: 发送的数据
    var login: Login?{
        let _login = Login()
        _login.loginDic = _postDic
        return _login
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


















