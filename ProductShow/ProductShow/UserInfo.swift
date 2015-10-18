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

class UserInfo: NSObject {
    
    private static var _userInfo = UserInfo()
    class func defaultUserInfo()->UserInfo {
        return _userInfo
    }
    
    private var returnDic: NSDictionary?
    private var postDic: NSDictionary?
    
//    init(postDic: NSDictionary?, returnDic: NSDictionary?) {
//        self.postDic = postDic
//        self.returnDic = returnDic
//    }
    
    func setInfo(info: NSDictionary){
        returnDic = info
    }
    
    func setUser(info: NSDictionary){
        postDic = info
    }
    
    func signout(){
        returnDic = nil
        NSNotificationCenter.defaultCenter().postNotificationName(kUserSignOutNotification, object: nil)
    }
    
    func infoForKey(key: String)->AnyObject?{
        
        //用户信息
        let data = returnDic?.objectForKey(jfdata) as? NSDictionary
        let dt = data?.objectForKey(jfdt) as? NSArray
        let userinfo = dt?.objectAtIndex(0) as? NSDictionary
        let obj = userinfo?.objectForKey(key)
        return obj
        
    }
    
    var userName: String?{
        return postDic?.objectForKey(jfusername) as? String
    }
    
    var password: String?{
        return postDic?.objectForKey(jfpwd) as? String
    }
    
    var status: Int{
        return (returnDic?.objectForKey(jfstatus) as? Int) ?? 0
    }
    
    var uid: Int?{
        return self.infoForKey(jfuid) as? Int
    }
    
}


















