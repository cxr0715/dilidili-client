//
//  VideoPlayViewController.swift
//  dilidili-client
//
//  Created by YYInc on 2018/4/25.
//  Copyright © 2018年 caoxuerui. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import BMPlayer

var videoPlayTableViewCellIdentifier:String = "VideoPlayTableViewCell"

class VideoPlayViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,BMPlayerDelegate {

    var tableView:UITableView?
    var videoArray:Array<Any> = []
    var player:BMPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.initView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initView() {
        self.player = BMPlayer()
        self.player!.delegate = self
        tableView = UITableView()
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView?.register(UINib(nibName: "VideoPlayTableViewCell",bundle: nil), forCellReuseIdentifier: videoPlayTableViewCellIdentifier)
        
        self.view.addSubview(tableView!)
        self.view.addSubview(player!)
        self.tableView!.snp.makeConstraints { (make) in
            make.top.equalTo(self.player!.snp.bottom)
            make.left.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.right.equalTo(self.view)
        }
        self.player!.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(kScreenWidth/16*9)
        }
    }
    
    func loadData(animateID:String) {
        #if (TARGET_IPHONE_SIMULATOR)
        // 模拟器
        let urlRequest = "http://127.0.0.1:8181/videolist"
        #else
        // 真机
        let urlRequest = "http://172.26.147.180:8181/videolist"
        #endif
        let parameters:Dictionary = ["animateID":animateID]
        
        Alamofire.request(urlRequest, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                if let value = response.result.value {
                    let json = JSON(value)
                    if let dic = json.dictionary {
                        let result = dic["result"]?.string
                        if result == "SUCCESS" {
                            self.videoArray = json["list"].arrayObject! as Array
                            self.tableView?.reloadData()
                            let dic1:Dictionary<String,String> = self.videoArray[0] as! Dictionary<String,String>
                            let nameString:String = dic1["animateIndex"]! + "：" + dic1["animateName"]!
                            let asset = BMPlayerResource(url: URL(string: dic1["animateURL"]!)!,
                                                         name: nameString)
                            self.player!.setVideo(resource: asset)
                        }
                    }
                }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:VideoPlayTableViewCell = tableView.dequeueReusableCell(withIdentifier: videoPlayTableViewCellIdentifier, for: indexPath) as! VideoPlayTableViewCell
        let dic:Dictionary<String,String> = self.videoArray[indexPath.row] as! Dictionary<String,String>
        
        let numberString = dic["animateIndex"]
        let titleString = dic["animateName"]
        cell.updateNumberAndTitleLabel(number: numberString!, title: titleString!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic1:Dictionary<String,String> = self.videoArray[indexPath.row] as! Dictionary<String,String>
        let nameString:String = dic1["animateIndex"]! + "：" + dic1["animateName"]!
        let asset = BMPlayerResource(url: URL(string: dic1["animateURL"]!)!,
                                     name: nameString)
        self.player!.setVideo(resource: asset)
    }
    
    // MARK:- BMPlayerDelegate example
    
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
        
    }
    
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        
    }
    
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
        
    }
    
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
        
    }
    
    func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
        player.snp.remakeConstraints { (make) in
            make.top.equalTo(self.view.snp.top)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            if isFullscreen {
                make.bottom.equalTo(self.view.snp.bottom)
            } else {
                make.height.equalTo(view.snp.width).multipliedBy(9.0/16.0).priority(500)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
