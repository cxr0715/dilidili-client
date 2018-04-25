//
//  HomeViewController.swift
//  dilidili-client
//
//  Created by YYInc on 2018/4/25.
//  Copyright © 2018年 caoxuerui. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

let kScreenWidth:CGFloat    = UIScreen.main.bounds.width
let kScreenHeight:CGFloat   = UIScreen.main.bounds.height
let cellIdentifier:String = "HomeViewCollectionCell"

class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var collectionView:UICollectionView?
    var dataSourceArray:Array<Any> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView()
        loadData()
    }
    
    func loadData() {
        let urlRequest = "http://127.0.0.1:8181/home"
        Alamofire.request(urlRequest, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                if let value = response.result.value {
                    let json = JSON(value)
                    if let dic = json.dictionary {
                        let result = dic["result"]?.string
                        if result == "SUCCESS" {
                            self.dataSourceArray = json["list"].arrayObject! as Array
                            self.collectionView?.reloadData()
                        }
                    }
                }
            }
    }
    
    func initCollectionView() {
        let defaultLayout = UICollectionViewFlowLayout()
        defaultLayout.scrollDirection = UICollectionViewScrollDirection.vertical//设置垂直显示
        defaultLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)//设置边距
        defaultLayout.itemSize = CGSize(width: kScreenWidth/2, height: kScreenWidth/2)
        defaultLayout.minimumLineSpacing = 0.0 //每个相邻的layout的上下间隔
        defaultLayout.minimumInteritemSpacing = 0.0 //每个相邻layout的左右间隔
        defaultLayout.headerReferenceSize = CGSize(width: 0, height: 0)
        defaultLayout.footerReferenceSize = CGSize(width: 0, height: 15)
        
        collectionView = UICollectionView(frame: CGRect(x:0, y:0, width:kScreenWidth, height:kScreenHeight), collectionViewLayout: defaultLayout)
        collectionView?.backgroundColor = UIColor.lightGray
        collectionView?.register(UINib(nibName: "HomeViewCollectionCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        self.view.addSubview(collectionView!)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSourceArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:HomeViewCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HomeViewCollectionCell
        let dic:Dictionary<String,String> = dataSourceArray[indexPath.row] as! Dictionary<String, String>
        let videoImage = dic["animateImage"]
        let videoTitle = dic["animateTitle"]
        cell.updateImageAndTitleCell(imageURL: videoImage!, title: videoTitle!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.section) 分区 ,第\(indexPath.row) 个元素")
        let dic:Dictionary<String,String> = dataSourceArray[indexPath.row] as! Dictionary<String, String>
        let videoID = dic["id"]
        
        let videoPlayVC = VideoPlayViewController()
        self.navigationController?.pushViewController(videoPlayVC, animated: true)
        videoPlayVC.loadData(animateID: videoID!)
    }
}
