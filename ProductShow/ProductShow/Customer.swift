//
//  Customers.swift
//  ProductShow
//
//  Created by s on 15/10/22.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import Foundation


class Customer: NSObject{
    fileprivate var _customerDic: NSDictionary?
    
    init(customerDic: NSDictionary) {
        _customerDic = customerDic
    }
    
    override init(){
        
    }
    
    var customerDic: NSDictionary?{
        get{
            return _customerDic
        }
        set{
            _customerDic = newValue
        }
    }
    
    var custId: Int?{
        return _customerDic?.object(forKey: jfcustId) as? Int
    }
    
    var custNo: String?{
        return _customerDic?.object(forKey: jfcustNo) as? String
    }
    
    var custName: String?{
        return _customerDic?.object(forKey: jfcustName) as? String
    }
    
    var shortName: String?{
        return _customerDic?.object(forKey: jfshortName) as? String
    }
    
    var state: Int?{
        return _customerDic?.object(forKey: jfstate) as? Int
    }
    
    
    var address: String?{
        return _customerDic?.object(forKey: jfaddress) as? String
    }
    
    var giveAddress: String?{
        return _customerDic?.object(forKey: jfgiveAddress) as? String
    }
    
    var areaId: Int?{
        return _customerDic?.object(forKey: jfareaId) as? Int
    }
    
    var area: String?{
        return _customerDic?.object(forKey: jfarea) as? String
    }
    
    var cityId: Int?{
        return _customerDic?.object(forKey: jfcityId) as? Int
    }
    
    var city: String?{
        return _customerDic?.object(forKey: jfcity) as? String
    }
    
    var linkman: String?{
        return _customerDic?.object(forKey: jflinkman) as? String
    }
    
    var tel: String?{
        return _customerDic?.object(forKey: jftel) as? String
    }
    
    var mobile: String?{
        return _customerDic?.object(forKey: jfmobile) as? String
    }
    
    var fax: String?{
        return _customerDic?.object(forKey: jffax) as? String
    }
    
    var bankName: String?{
        return _customerDic?.object(forKey: jfbankName) as? String
    }
    
    var accountNo: String?{
        return _customerDic?.object(forKey: jfaccountNo) as? String
    }
    
    var taxNo: String?{
        return _customerDic?.object(forKey: jftaxNo) as? String
    }
    
    var TaxRate: String?{
        return _customerDic?.object(forKey: jfTaxRate) as? String
    }
    
    var boss: String?{
        return _customerDic?.object(forKey: jfboss) as? String
    }
    
    var createDate: String?{
        return _customerDic?.object(forKey: jfcreateDate) as? String
    }
    
    var invoiceType: Int?{
        return _customerDic?.object(forKey: jfinvoiceType) as? Int
    }
    
    var receiptType: Int?{
        return _customerDic?.object(forKey: jfreceiptType) as? Int
    }
    
    var payCurrency: String?{
        return _customerDic?.object(forKey: jfpayCurrency) as? String
    }
    
    var payType: Int?{
        return _customerDic?.object(forKey: jfpayType) as? Int
    }
    
    var deptId: Int?{
        return _customerDic?.object(forKey: jfdeptId) as? Int
    }
    
    var saleId: Int?{
        return _customerDic?.object(forKey: jfsaleId) as? Int
    }
    
    var dept: String?{
        return _customerDic?.object(forKey: jfdept) as? String
    }
    
    var mail: String?{
        return _customerDic?.object(forKey: jfmail) as? String
    }
    
    var creditLine: Int?{
        return _customerDic?.object(forKey: jfcreditLine) as? Int
    }
    
    var memo: String?{
        return _customerDic?.object(forKey: jfmemo) as? String
    }
    
    func stringForKey(_ key: String)->String?{
        let objOpt = _customerDic?.object(forKey: key)
        if let obj = objOpt{
            return "\(obj)"
        }
        return nil
    }
}

class Customers: ReturnDic {
    
    fileprivate var customers: NSArray?{
        return data_dt
//        //用户信息
//        let data = _returnDic?.objectForKey(jfdata) as? NSDictionary
//        let dt = data?.objectForKey(jfdt) as? NSArray
//        return dt
    }
    
    var customersCount: Int{
        return customers?.count ?? 0
    }
    
    func customerAtIndex(_ index: Int)->Customer?{
        let customerDicOpt = customers?.object(at: index) as? NSDictionary
        if let customerDic = customerDicOpt{
            return Customer(customerDic: customerDic)
        }else{
            return nil
        }
        
    }
}




















