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

protocol DataSyncObjectDelegate: NSObjectProtocol{
    func dataSyncObjectDidStopSync(dataSyncObject: DataSyncObject)
    func dataSyncObjectDidFinishedSync(dataSyncObject: DataSyncObject)
    func dataSyncObjectDidSyncNewData(dataSyncObject: DataSyncObject)
    func dataSyncSynStateDidChanged(dataSyncObject: DataSyncObject)
}

enum Synstate{
    case Init //初始状态
    case Synchronizing //同步中
    case Canceling //取消中，当前还有一个同步任务在执行中
    case Canceled //取消任务，当前不在同步
    case Finished //任务结束
}


class DataSyncObject: NSObject {
    //单例
    private static var _defaultObject: DataSyncObject?
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
    var synstate = Synstate.Init
    var lastSynstateChangedTime = NSDate()
    
    override init() {
        super.init()
        
        let DataSyncObjectDicDataOpt = NSUserDefaults.standardUserDefaults().objectForKey("DataSyncObjectDic") as? NSData
        var jsonOpt: AnyObject? = nil
        if let DataSyncObjectDicData = DataSyncObjectDicDataOpt{
            jsonOpt = try? NSJSONSerialization.JSONObjectWithData(DataSyncObjectDicData, options: NSJSONReadingOptions.MutableContainers)
        }
        
        if let json = jsonOpt{
            let DataSyncObjectDic = json as? NSMutableDictionary
            let urlArray = DataSyncObjectDic?.objectForKey("urlArray") as? NSMutableArray
            allUrl.urlArray = urlArray
            let productFilesDic = DataSyncObjectDic?.objectForKey("productFilesDic") as? NSDictionary
            allProFiles.returnDic = productFilesDic
            let currentSynIndexOpt = DataSyncObjectDic?.objectForKey("currentSynIndex") as? Int
            currentSynIndex = currentSynIndexOpt ?? 0
        }
    }
    
    func flush(){
        let saveDic = NSMutableDictionary()
        if allUrl.urlArray != nil{
            saveDic.setObject(allUrl.urlArray!, forKey: "urlArray")
        }
        if allProFiles.returnDic != nil{
            saveDic.setObject(allProFiles.returnDic!, forKey: "productFilesDic")
        }
        saveDic.setObject(currentSynIndex, forKey: "currentSynIndex")
        let saveDicData = try? NSJSONSerialization.dataWithJSONObject(saveDic, options: NSJSONWritingOptions())
        NSUserDefaults.standardUserDefaults().setObject(saveDicData, forKey: "DataSyncObjectDic")
    }
    
    var progress: Float{
        return Float(currentSynIndex) / Float(allUrl.urlCount + allProFiles.filesCount)
    }
    
    var processDescription: String{
        
        switch synstate{
        case .Init:
            return "wait for start"
        case .Synchronizing:
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
        case .Canceling:
            return "Canceling"
        case .Canceled:
            return "Canceled \(lastSynstateChangedTime.toString())"
        case .Finished:
            let syncFaileCount = allUrl.urlArrayWithSynced(false).count + allProFiles.filesWithSynced(false).count
            let syncSucceedCount = allUrl.urlCount + allProFiles.filesCount - syncFaileCount
            return "Finished (\(syncSucceedCount) Success, \(syncFaileCount) Failure)"
        }
    }
    
    func descriptionForSynced(synced: Bool?, terminator:String)->String{
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
        result.appendString("\(syncSucceedCount) Success, \(syncFaileCount) Failure \(terminator)")
        if urls?.count > 0{
            for (_,obj) in urls!.enumerate(){
                let url = obj as? CRMUrl
                if url != nil{
                    result.appendString("\(url!.SyncDescription) \(terminator)")
                }
            }
        }
        
        if files?.count > 0{
            for (_,obj) in files!.enumerate(){
                let file = obj as? ProductFile
                if file != nil{
                    result.appendString("\(file!.SyncDescription) \(terminator)")
                }
            }
        }
        return result as String
    }
    
//    var ready: Bool{
//        return (allUrl.urlArray != nil) && (allProFiles.files != nil)
//    }
    
    func cancel(){
        synstate = .Canceling
        delegate?.dataSyncSynStateDidChanged(self)
    }
    
    //会造成多线程同时下载多个任务，不过还好一般不会下载同一个任务
    func restart(){
        GetSyncInfo({ (succeed, response, data, error) -> Void in
            if succeed == true{
                self.synstate = .Synchronizing
                self.currentSynIndex = 0
                self.delegate?.dataSyncSynStateDidChanged(self)
                self.SynCrmUrl()
            }else{
                self.synstate = .Finished
                self.delegate?.dataSyncSynStateDidChanged(self)
                self.delegate?.dataSyncObjectDidFinishedSync(self)
            }
        })
        
    }
    
    func start(){
        switch synstate{
        case .Init:
//            currentSynIndex = 0 //曾经下载失败的先跳过
            self.synstate = .Synchronizing
            self.delegate?.dataSyncSynStateDidChanged(self)
            self.SynCrmUrl()
//            if (currentSynIndex > 0)&&(currentSynIndex < allUrl.urlCount + allProFiles.filesCount){
//                self.synstate = .Synchronizing
//                self.delegate?.dataSyncSynStateDidChanged(self)
//                self.SynCrmUrl()
//            }else{
//                restart()
//            }
        case .Synchronizing: break
            
        case .Canceling:
            synstate = .Synchronizing
            self.delegate?.dataSyncSynStateDidChanged(self)
        case .Canceled:
            synstate = .Synchronizing
            self.delegate?.dataSyncSynStateDidChanged(self)
            SynCrmUrl()
        case .Finished:
            synstate = .Synchronizing
            currentSynIndex = 0
            self.delegate?.dataSyncSynStateDidChanged(self)
            SynCrmUrl()
        }
    }
    
    func GetSyncInfo(completedHandler:((Bool?,NSURLResponse?,NSData?,NSError?)->Void)?){
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
    
    func GetAllUrl(completedHandler:((Bool?,NSURLResponse?,NSData?,NSError?)->Void)?){
        WebApi.GetAllUrl { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as? NSMutableArray
                self.allUrl.urlArray = json
                completedHandler?(true,response,data,error)
            }else{
                completedHandler?(false,response,data,error)
            }
        }
    }
    
    func GetAllProFiles(completedHandler:((Bool?,NSURLResponse?,NSData?,NSError?)->Void)?){
        WebApi.GetAllProFiles { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as? NSMutableDictionary
                self.allProFiles.returnDic = json
                completedHandler?(true,response,data,error)
            }else{
                completedHandler?(false,response,data,error)
            }
        }
    }
    
    
    //获取该同步的url并同步数据
    func SynCrmUrl(){
        if synstate == .Canceling{
            synstate = .Canceled
            lastSynstateChangedTime = NSDate()
            self.delegate?.dataSyncSynStateDidChanged(self)
            delegate?.dataSyncObjectDidStopSync(self)
            return
        }
        if synstate != .Synchronizing{
            return
        }
        
        if currentSynIndex < allUrl.urlCount{
            let crmUrl = allUrl.urlAtIndex(currentSynIndex)
            if crmUrl!.Synced{
                self.currentSynIndex++
//                self.performSelector(Selector("SynCrmUrl"))
                SynCrmUrl()
            }else{
                delegate?.dataSyncObjectDidSyncNewData(self)
                
                WebApi.GetUrl(crmUrl?.url, completedHandler: { (response, data, error) -> Void in
                    if WebApi.isHttpSucceed(response, data: data, error: error){
                        self.currentSynIndex++
                        crmUrl?.Synced = true
                        //self.performSelector(Selector("SynCrmUrl"))
                        self.SynCrmUrl()
                    }else{
                        self.currentSynIndex++
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
                self.currentSynIndex++
                productFile?.Synced = true
//                self.performSelector(Selector("SynCrmUrl"))
                self.SynCrmUrl()

            }else{
                delegate?.dataSyncObjectDidSyncNewData(self)
                WebApi.GetFile(filepath, completedHandler: { (response, data, error) -> Void in
                    if WebApi.isHttpSucceed(response, data: data, error: error){
                        self.currentSynIndex++
                        productFile?.Synced = true
//                        self.performSelector(Selector("SynCrmUrl"))
                        self.SynCrmUrl()

                    }else{
                        self.currentSynIndex++
                        productFile?.Synced = false
//                        self.performSelector(Selector("SynCrmUrl"))
                        self.SynCrmUrl()

                    }
                    self.flush()
                })
            }
        }else{
            synstate = .Finished
            lastSynstateChangedTime = NSDate()
            self.delegate?.dataSyncSynStateDidChanged(self)
            delegate?.dataSyncObjectDidFinishedSync(self)
        }
    }

}













