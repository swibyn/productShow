//
//  File.swift
//  ProductShow
//
//  Created by s on 15/9/9.
//  Copyright (c) 2015年 gaozgao. All rights reserved.
//

import Foundation

//MARK:1. 发送设备编码
let jfeqNo = "eqNo" //设备编码，用于校验该设备是否有访问权限
let jfeqName = "eqName" //设备名称

let jfstatus = "status" //状态：校验成功时返回1，校验失败时返回0
let jfmessage = "message" //消息提示，执行成功时返回空字符串，执行失败时返回错误信息

//MARK:2. 登录校验：
let jfusername = "username" //用户名
let jfpwd = "pwd" //密码，需MD5加密
let jfauthcode = "authcode" //识别码

let jfuid = "uid"
let jfuname = "uname"
let jfmail = "mail"
let jfweixin = "weixin"
let jfqq = "qq"
let jfuserNo = "userNo"
let jfsex = "sex"
let jfrole = "role"
let jfdeptNo = "deptNo"

//MARK:3. 获取热门产品：
let jfproId = "proId" //产品编号
let jfproName = "proName" //产品名称
let jfcatId = "catId" //产品分类ID
let jfproSize = "proSize" //产品型号
let jfremark = "remark" //产品简介
let jforderIndex = "orderIndex" //排序顺序
let jfisHot = "isHot" //是否热门产品，是=1，否=0
let jfpromemo = "promemo" //详细信息
let jfproVer = "proVer" //产品版本号
let jfdata = "data"
let jfdt = "dt"
let jfimgUrl = "imgUrl"

//MARK:4. 获取一级产品分类
let jfcatName = "catName" //产品分类名称
let jfmemo = "memo" //备注
let jfcatNo = "catNo" //产品分类编号

//MARK:5. 获取二级产品分类
let jfpId = "pId" //一级产品分类ID

//MARK:6. 产品查询
//MARK:7. 根据产品ID获取产品数据
//MARK:8. 根据产品ID获取产品的图片地址和视频地址
let jffileType = "fileType" //文件类型，1=图片地址，2=视频地址
let jffilePath = "filePath" //文件url，注意：图片地址在应用时需手动补充前缀

//MARK:9. 获取客户数据
let jfcustId = "custId" //客户ID,为空时查询所有在用客户数据
let jfsaleId = "saleId"  //专属业务员ID，不为空时查询该业务员的所有客户数据
let jfcustNo = "custNo"  //代码
let jfcustName = "custName" //客户名称
let jfshortName = "shortName" //助记码
let jfstate = "state" //状态，0=使用，1=未使用，2=冻结
let jfaddress = "address" //公司地址
let jfgiveAddress = "giveAddress" //交货地址
let jfareaId = "areaId" //区域IDlet jf = "cityId = "城市ID
let jfcity = "city"	//城市名称
let jflinkman = "linkman"	//联系人
let jftel = "tel"	//电话
let jfmobile = "mobile"	//移动电话
let jffax = "fax"	//传真
let jfbankName = "bankName"	//开户银行
let jfaccountNo = "accountNo"	//银行帐号
let jftaxNo = "taxNo"	//税务登记号
let jfTaxRate = "TaxRate"	//增值税率
let jfboss = "boss"	//法人代表
let jfcreateDate = "createDate"	//创建时间
let jfinvoiceType = "invoiceType"	//开票方式
let jfreceiptType = "receiptType" //收款条件
let jfpayCurrency = "payCurrency"
let jfpayType = "payType"
let jfdeptId = "deptId"
let jfdept = "dept"
//let jfsaleId = "saleId"
let jfsaler = "saler"
let jfcreditLine = "creditLine"

//MARK:10. 获取客户关注产品
//MARK:11. 获取用户数据

//MARK:12. 获取系统公告
let jfnoticeId = "noticeId"
let jftitle = "title"
let jfcontents = "contents"
let jfreleaseDate = "releaseDate"
let jfisUse = "isUse"

//MARK:13. 写拜访日志
let jflogDate = "logDate"
let jflogContent = "logContent"

//MARK:14. 提交购物车及照片
let jfproIds = "proIds"
let jfimgPaths = "imgPaths"
//MARK:15. 提交图片
let jfurl = "url"

//MARK:



































