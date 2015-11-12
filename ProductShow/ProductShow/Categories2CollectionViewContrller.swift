//
//  Categories2CollectionViewContrller.swift
//  ProductShow
//
//  Created by s on 15/10/27.
//  Copyright © 2015年 zhiwx. All rights reserved.
//

import UIKit

class Categories2CollectionViewController: UICollectionViewController {
    var category1: Category? //上一级的类目信息
    var categories: Categories?
    
    
    //MARK: view life
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = category1?.catName
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("\(self) \(__FUNCTION__)")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("\(self) \(__FUNCTION__)")
        GetProLeave2()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: function
    func GetProLeave2(){
        
        let catId = category1?.catId
        WebApi.GetProLeave2([jfpId : catId!], completedHandler: { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                self.categories = Categories(returnDic: json)
                
                if (self.categories!.status! == 1){
                    
                    self.collectionView?.reloadData()
                }else{
                    
                    let msgString = self.categories?.message
                    let alertView = UIAlertView(title: nil, message: msgString, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                }
                
                
            }
        })

    }
    
    // MARK: - collection view data source
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categories?.categoriesCount ?? 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        
        // Configure the cell...
        let label = cell.viewWithTag(100) as? UILabel
        
        label?.backgroundColor = categoryColor(indexPath.row)
//        label?.backgroundColor = mycolor[indexPath.row % mycolor.count]
        let catname = categories?.categoryAtIndex(indexPath.row)?.catName
        label?.text =  "\(catname!)"
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
            let size = self.collectionView?.bounds.size
            //            let width = self.collectionView?.bounds
            return  CGSize(width: (size!.width - 60)/2 ,height: 97)
            
    }

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let selectedIndexPath = self.collectionView?.indexPathForCell(sender as! UICollectionViewCell)
        let destVC: AnyObject = segue.destinationViewController
        let index = selectedIndexPath?.row
        destVC.setValue(self.categories?.categoryAtIndex(index!), forKey: "category2")
    }
    
    
}
