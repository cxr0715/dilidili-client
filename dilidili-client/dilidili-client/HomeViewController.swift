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
        self.title = "首页"
    }
    
    func loadData() {
        
    #if arch(i386) || arch(x86_64)
        let urlRequest = "http://127.0.0.1:8181/home"
    #else
//        let urlRequest = "http://172.26.147.180:8181/home"
        let urlRequest = "http://192.168.3.29:8181/home"
//        let urlRequest = "http://172.26.83.6/home"
    #endif
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
//        Alamofire.request(urlRequest, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
//            .responseJSON { (response) in
//                if let value = response.result.value {
//                    let json = JSON(value)
//                    if let dic = json.dictionary {
//                        let result = dic["result"]?.string
//                        if result == "SUCCESS" {
//                            self.dataSourceArray = json["list"].arrayObject! as Array
//                            self.collectionView?.reloadData()
//                        }
//                    }
//                }
//        }
    }
    
    func initCollectionView() {
        let defaultLayout = UICollectionViewFlowLayout()
        defaultLayout.scrollDirection = UICollectionViewScrollDirection.vertical//设置垂直显示
        defaultLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)//设置边距
        defaultLayout.itemSize = CGSize(width: kScreenWidth/2 - 20, height: kScreenWidth/2 - 20)
        defaultLayout.minimumLineSpacing = 10.0 //每个相邻的layout的上下间隔
        defaultLayout.minimumInteritemSpacing = 10.0 //每个相邻layout的左右间隔
        defaultLayout.headerReferenceSize = CGSize(width: 0, height: 0)
        defaultLayout.footerReferenceSize = CGSize(width: 0, height: 0)
        
        collectionView = UICollectionView(frame: CGRect(x:0, y:0, width:kScreenWidth, height:kScreenHeight), collectionViewLayout: defaultLayout)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
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
        let dic:Dictionary<String,String> = dataSourceArray[indexPath.row] as! Dictionary<String, String>
        let videoID = dic["id"]
        
        let videoPlayVC = VideoPlayViewController()
        videoPlayVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(videoPlayVC, animated: true)
        videoPlayVC.loadData(animateID: videoID!)
    }
    
    struct Platform {
        static let isSimulator: Bool = {
            var isSim = false
            #if arch(i386) || arch(x86_64)
            isSim = true
            #endif
            return isSim
        }()
    }
}
