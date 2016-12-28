//
//  DataSyncObject.swift
//  ProductShow
//
//  Created by s on 15/12/10.
//  Copyright © 2015年 zhiwx. All rights reserved.
//
/* 用法


*/
import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


protocol DataSyncObjectDelegate: NSObjectProtocol{
    func dataSyncObjectDidStopSync(_ dataSyncObject: DataSyncObject)
    func dataSyncObjectDidFinishedSync(_ dataSyncObject: DataSyncObject)
    func dataSyncObjectDidSyncNewData(_ dataSyncObject: DataSyncObject)
    func dataSyncSynStateDidChanged(_ dataSyncObject: DataSyncObject)
}

enum Synstate{
    case `init` //初始状态
    case synchronizing //同步中
    case canceling //取消中，当前还有一个同步任务在执行中
    case canceled //取消任务，当前不在同步
    case finished //任务结束
}


class DataSyncObject: NSObject {
    //单例
    fileprivate static var _defaultObject: DataSyncObject?
    class func defaultObject()->DataSyncObject{
        if _defaultObject == nil{
            _defaultObject = DataSyncObject()
        }
        return _defaultObject!
    }
    //代理
    var delegate: DataSyncObjectDelegate?
    
    //MARK: 数据同步
    let allUrl = AllCRMUrl()
    let allProFiles = ProductFiles()
    var currentSynIndex = 0
    var synstate = Synstate.`init`
    var lastSynstateChangedTime = Date()
    
    override init() {
        super.init()
        
        let DataSyncObjectDicDataOpt = UserDefaults.standard.object(forKey: "DataSyncObjectDic") as? Data
        var jsonOpt: AnyObject? = nil
        if let DataSyncObjectDicData = DataSyncObjectDicDataOpt{
            jsonOpt = try! JSONSerialization.jsonObject(with: DataSyncObjectDicData, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject?
        }
        
        if let json = jsonOpt{
            let DataSyncObjectDic = json as? NSMutableDictionary
            let urlArray = DataSyncObjectDic?.object(forKey: "urlArray") as? NSMutableArray
            allUrl.urlArray = urlArray
            let productFilesDic = DataSyncObjectDic?.object(forKey: "productFilesDic") as? NSDictionary
            allProFiles.returnDic = productFilesDic
            let currentSynIndexOpt = DataSyncObjectDic?.object(forKey: "currentSynIndex") as? Int
            currentSynIndex = currentSynIndexOpt ?? 0
        }
    }
    
    func flush(){
        let saveDic = NSMutableDictionary()
        if allUrl.urlArray != nil{
            saveDic.setObject(allUrl.urlArray!, forKey: "urlArray" as NSCopying)
        }
        if allProFiles.returnDic != nil{
            saveDic.setObject(allProFiles.returnDic!, forKey: "productFilesDic" as NSCopying)
        }
        saveDic.setObject(currentSynIndex, forKey: "currentSynIndex" as NSCopying)
        let saveDicData = try? JSONSerialization.data(withJSONObject: saveDic, options: JSONSerialization.WritingOptions())
        UserDefaults.standard.set(saveDicData, forKey: "DataSyncObjectDic")
    }
    
    var progress: Float{
        return Float(currentSynIndex) / Float(allUrl.urlCount + allProFiles.filesCount)
    }
    
    var processDescription: String{
        
        switch synstate{
        case .`init`:
            return "wait for start"
        case .synchronizing:
            if currentSynIndex < allUrl.urlCount{
                return "Synchronize product data"
            }else if currentSynIndex - allUrl.urlCount < allProFiles.filesCount{
                let index = currentSynIndex - allUrl.urlCount
                let productFile = allProFiles.productFileAtIndex(index)
                let filepath = productFile?.filePath
                
                let urlStr = filepath?.URL?.absoluteString
                if urlStr != nil{
                    return "File downloading \(urlStr!)"
                }
                return "File downloading"
            }else{
                return "Sync Completed"
            }
        case .canceling:
            return "Canceling"
        case .canceled:
            return "Canceled \(lastSynstateChangedTime.toString())"
        case .finished:
            let syncFaileCount = allUrl.urlArrayWithSynced(false).count + allProFiles.filesWithSynced(false).count
            let syncSucceedCount = allUrl.urlCount + allProFiles.filesCount - syncFaileCount
            return "Finished (\(syncSucceedCount) Success, \(syncFaileCount) Failure)"
        }
    }
    
    func descriptionForSynced(_ synced: Bool?, terminator:String)->String{
        var urls: NSArray?
        var files: NSArray?
        if synced == nil{
            urls = allUrl.urlArray
            files = allProFiles.files
        }else if synced == true{
            urls = allUrl.urlArrayWithSynced(true)
            files = allProFiles.filesWithSynced(true)
        }else{
            urls = allUrl.urlArrayWithSynced(false)
            files = allProFiles.filesWithSynced(false)
        }
        
        let result = NSMutableString()
        let syncFaileCount = allUrl.urlArrayWithSynced(false).count + allProFiles.filesWithSynced(false).count
        let syncSucceedCount = allUrl.urlCount + allProFiles.filesCount - syncFaileCount
        result.append("\(syncSucceedCount) Success, \(syncFaileCount) Failure \(terminator)")
        if urls?.count > 0{
            for (_,obj) in urls!.enumerated(){
                let url = obj as? CRMUrl
                if url != nil{
                    result.append("\(url!.SyncDescription) \(terminator)")
                }
            }
        }
        
        if files?.count > 0{
            for (_,obj) in files!.enumerated(){
                let file = obj as? ProductFile
                if file != nil{
                    result.append("\(file!.SyncDescription) \(terminator)")
                }
            }
        }
        return result as String
    }
    
//    var ready: Bool{
//        return (allUrl.urlArray != nil) && (allProFiles.files != nil)
//    }
    
    func cancel(){
        synstate = .canceling
        delegate?.dataSyncSynStateDidChanged(self)
    }
    
    //会造成多线程同时下载多个任务，不过还好一般不会下载同一个任务
    func restart(){
        GetSyncInfo({ (succeed, response, data, error) -> Void in
            if succeed == true{
                self.synstate = .synchronizing
                self.currentSynIndex = 0
                self.delegate?.dataSyncSynStateDidChanged(self)
                self.SynCrmUrl()
            }else{
                self.synstate = .finished
                self.delegate?.dataSyncSynStateDidChanged(self)
                self.delegate?.dataSyncObjectDidFinishedSync(self)
            }
        })
        
    }
    
    func start(){
        switch synstate{
        case .init:
//            currentSynIndex = 0 //曾经下载失败的先跳过
            self.synstate = .synchronizing
            self.delegate?.dataSyncSynStateDidChanged(self)
            self.SynCrmUrl()
//            if (currentSynIndex > 0)&&(currentSynIndex < allUrl.urlCount + allProFiles.filesCount){
//                self.synstate = .Synchronizing
//                self.delegate?.dataSyncSynStateDidChanged(self)
//                self.SynCrmUrl()
//            }else{
//                restart()
//            }
        case .synchronizing: break
            
        case .canceling:
            synstate = .synchronizing
            self.delegate?.dataSyncSynStateDidChanged(self)
        case .canceled:
            synstate = .synchronizing
            self.delegate?.dataSyncSynStateDidChanged(self)
            SynCrmUrl()
        case .finished:
            synstate = .synchronizing
            currentSynIndex = 0
            self.delegate?.dataSyncSynStateDidChanged(self)
            SynCrmUrl()
        }
    }
    
    func GetSyncInfo(_ completedHandler:((Bool?,URLResponse?,Data?,NSError?)->Void)?){
        GetAllUrl({ (succeed, response, data, error) -> Void in
            if succeed == true{
                self.GetAllProFiles({ (succeed, response, data, error) -> Void in
                    if succeed == true{
                        completedHandler?(true,response,data,error)
                    }else{
                        completedHandler?(false,response,data,error)
                    }
                })
            }else{
                completedHandler?(false,response,data,error)
            }
        })
        
    }
    
    func GetAllUrl(_ completedHandler:((Bool?,URLResponse?,Data?,NSError?)->Void)?){
        WebApi.GetAllUrl { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSMutableArray
                self.allUrl.urlArray = json
                completedHandler?(true,response,data,error)
            }else{
                completedHandler?(false,response,data,error)
            }
        }
    }
    
    func GetAllProFiles(_ completedHandler:((Bool?,URLResponse?,Data?,NSError?)->Void)?){
        WebApi.GetAllProFiles { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSMutableDictionary
                self.allProFiles.returnDic = json
                completedHandler?(true,response,data,error)
            }else{
                completedHandler?(false,response,data,error)
            }
        }
    }
    
    
    //获取该同步的url并同步数据
    func SynCrmUrl(){
        if synstate == .canceling{
            synstate = .canceled
            lastSynstateChangedTime = Date()
            self.delegate?.dataSyncSynStateDidChanged(self)
            delegate?.dataSyncObjectDidStopSync(self)
            return
        }
        if synstate != .synchronizing{
            return
        }
        
        if currentSynIndex < allUrl.urlCount{
            let crmUrl = allUrl.urlAtIndex(currentSynIndex)
            if crmUrl!.Synced{
                self.currentSynIndex += 1
//                self.performSelector(Selector("SynCrmUrl"))
                SynCrmUrl()
            }else{
                delegate?.dataSyncObjectDidSyncNewData(self)
                
                WebApi.GetUrl(crmUrl?.url, completedHandler: { (response, data, error) -> Void in
                    if WebApi.isHttpSucceed(response, data: data, error: error){
                        self.currentSynIndex += 1
                        crmUrl?.Synced = true
                        //self.performSelector(Selector("SynCrmUrl"))
                        self.SynCrmUrl()
                    }else{
                        self.currentSynIndex += 1
                        crmUrl?.Synced = false
//                        self.performSelector(Selector("SynCrmUrl"))
                        self.SynCrmUrl()
                    }
                    self.flush()
                })
            }
        }else if currentSynIndex - allUrl.urlCount < allProFiles.filesCount{
            let index = currentSynIndex - allUrl.urlCount
            let productFile = allProFiles.productFileAtIndex(index)
            let filepath = productFile?.filePath
            
            if WebApi.fileExistsForRemote(filepath){
                self.currentSynIndex += 1
                productFile?.Synced = true
//                self.performSelector(Selector("SynCrmUrl"))
                self.SynCrmUrl()

            }else{
                delegate?.dataSyncObjectDidSyncNewData(self)
                WebApi.GetFile(filepath, completedHandler: { (response, data, error) -> Void in
                    if WebApi.isHttpSucceed(response, data: data, error: error){
                        self.currentSynIndex += 1
                        productFile?.Synced = true
//                        self.performSelector(Selector("SynCrmUrl"))
                        self.SynCrmUrl()

                    }else{
                        self.currentSynIndex += 1
                        productFile?.Synced = false
//                        self.performSelector(Selector("SynCrmUrl"))
                        self.SynCrmUrl()

                    }
                    self.flush()
                })
            }
        }else{
            synstate = .finished
            lastSynstateChangedTime = Date()
            self.delegate?.dataSyncSynStateDidChanged(self)
            delegate?.dataSyncObjectDidFinishedSync(self)
        }
    }

}













