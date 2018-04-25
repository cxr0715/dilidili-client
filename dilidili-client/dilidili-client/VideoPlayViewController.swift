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

class VideoPlayViewController: UIViewController {

    var videoArray:Array<Any> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(animateID:String) {
        let urlRequest = "http://127.0.0.1:8181/videolist"
        let parameters:Dictionary = ["animateID":animateID]
        
        Alamofire.request(urlRequest, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                if let value = response.result.value {
                    let json = JSON(value)
                    if let dic = json.dictionary {
                        let result = dic["result"]?.string
                        if result == "SUCCESS" {
                            self.videoArray = json["list"].arrayObject! as Array
                            print(self.videoArray)
                        }
                    }
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
