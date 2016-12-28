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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
                
                let json = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
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
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categories?.categoriesCount ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        // Configure the cell...
        let label = cell.viewWithTag(100) as? UILabel
        
        label?.backgroundColor = categoryColor(indexPath.row)
        
        let catname = categories?.categoryAtIndex(indexPath.row)?.catName
        label?.text =  "\(catname!)"
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize{
            let size = self.collectionView?.bounds.size
            //            let width = self.collectionView?.bounds
            return  CGSize(width: (size!.width - 60)/2 ,height: 97)
            
    }

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let selectedIndexPath = self.collectionView?.indexPath(for: sender as! UICollectionViewCell)
        let destVC = segue.destination
        let index = selectedIndexPath?.row
        let category = categories?.categoryAtIndex(index!)
        if (segue.identifier == "category2ToProducts"){

            let productsVc = destVC as! ProductsTableViewController
            productsVc.title = category?.catName
        
            let catId = category?.catId
            WebApi.GetProductsByCatId([jfcatId : catId!], completedHandler: { (response, data, error) -> Void in
                
                if WebApi.isHttpSucceed(response, data: data, error: error){
                    
                    let json = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    let products = Products(returnDic: json)
                    
                    productsVc.products = products
                }
            })
        }
    }
    
    
}
