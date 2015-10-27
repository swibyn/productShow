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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = category1?.catName
        
        let catId = category1?.catId
        WebApi.GetProLeave2([jfpId : catId!], completedHandler: { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                self.categories = Categories(returnDic: json)
                
                if (self.categories!.status! == 1){
                    
                    self.collectionView?.reloadData()
                }else{
                    
                    let msgString = self.categories?.message
                    let alertView = UIAlertView(title: "Fail", message: msgString, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                }
                
                
            }
        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        label?.text =  "\(categories?.categoryAtIndex(indexPath.row)?.catName)"
        
        return cell
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
