//
//  Customers.swift
//  ProductShow
//
//  Created by s on 15/10/22.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import Foundation


class Customer: NSObject{
    private var _customerDic: NSDictionary?
    
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
        return _customerDic?.objectForKey(jfcustId) as? Int
    }
    
    var custNo: String?{
        return _customerDic?.objectForKey(jfcustNo) as? String
    }
    
    var custName: String?{
        return _customerDic?.objectForKey(jfcustName) as? String
    }
    
    var shortName: String?{
        return _customerDic?.objectForKey(jfshortName) as? String
    }
    
    var state: Int?{
        return _customerDic?.objectForKey(jfstate) as? Int
    }
    
    
    var address: String?{
        return _customerDic?.objectForKey(jfaddress) as? String
    }
    
    var giveAddress: String?{
        return _customerDic?.objectForKey(jfgiveAddress) as? String
    }
    
    var areaId: Int?{
        return _customerDic?.objectForKey(jfareaId) as? Int
    }
    
    var area: String?{
        return _customerDic?.objectForKey(jfarea) as? String
    }
    
    var cityId: Int?{
        return _customerDic?.objectForKey(jfcityId) as? Int
    }
    
    var city: String?{
        return _customerDic?.objectForKey(jfcity) as? String
    }
    
    var linkman: String?{
        return _customerDic?.objectForKey(jflinkman) as? String
    }
    
    var tel: String?{
        return _customerDic?.objectForKey(jftel) as? String
    }
    
    var mobile: String?{
        return _customerDic?.objectForKey(jfmobile) as? String
    }
    
    var fax: String?{
        return _customerDic?.objectForKey(jffax) as? String
    }
    
    var bankName: String?{
        return _customerDic?.objectForKey(jfbankName) as? String
    }
    
    var accountNo: String?{
        return _customerDic?.objectForKey(jfaccountNo) as? String
    }
    
    var taxNo: String?{
        return _customerDic?.objectForKey(jftaxNo) as? String
    }
    
    var TaxRate: String?{
        return _customerDic?.objectForKey(jfTaxRate) as? String
    }
    
    var boss: String?{
        return _customerDic?.objectForKey(jfboss) as? String
    }
    
    var createDate: String?{
        return _customerDic?.objectForKey(jfcreateDate) as? String
    }
    
    var invoiceType: Int?{
        return _customerDic?.objectForKey(jfinvoiceType) as? Int
    }
    
    var receiptType: Int?{
        return _customerDic?.objectForKey(jfreceiptType) as? Int
    }
    
    var payCurrency: String?{
        return _customerDic?.objectForKey(jfpayCurrency) as? String
    }
    
    var payType: Int?{
        return _customerDic?.objectForKey(jfpayType) as? Int
    }
    
    var deptId: Int?{
        return _customerDic?.objectForKey(jfdeptId) as? Int
    }
    
    var saleId: Int?{
        return _customerDic?.objectForKey(jfsaleId) as? Int
    }
    
    var dept: String?{
        return _customerDic?.objectForKey(jfdept) as? String
    }
    
    var creditLine: Int?{
        return _customerDic?.objectForKey(jfcreditLine) as? Int
    }
    
    var memo: String?{
        return _customerDic?.objectForKey(jfmemo) as? String
    }
    
    func stringForKey(key: String)->String?{
        let objOpt = _customerDic?.objectForKey(key)
        if let obj = objOpt{
            return "\(obj)"
        }
        return nil
    }
}

class Customers: ReturnDic {
    
    private var customers: NSArray?{
        return data_dt
//        //用户信息
//        let data = _returnDic?.objectForKey(jfdata) as? NSDictionary
//        let dt = data?.objectForKey(jfdt) as? NSArray
//        return dt
    }
    
    var customersCount: Int{
        return customers?.count ?? 0
    }
    
    func customerAtIndex(index: Int)->Customer?{
        let customerDicOpt = customers?.objectAtIndex(index) as? NSDictionary
        if let customerDic = customerDicOpt{
            return Customer(customerDic: customerDic)
        }else{
            return nil
        }
        
    }
}




















