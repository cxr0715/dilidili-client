//
//  AppDelegate.swift
//  dilidili-client
//
//  Created by YYInc on 2018/4/24.
//  Copyright © 2018年 caoxuerui. All rights reserved.
//

import UIKit
import UserNotifications
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate{

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("Request permission for notifications: \(granted)")
            UIApplication.shared.registerForRemoteNotifications()
            center.delegate = self
        }
        
        self.window = UIWindow(frame:UIScreen.main.bounds)
        self.window?.rootViewController = MiniTabBarController()
        self.window?.makeKeyAndVisible()
        // Override point for customization after application launch.
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        guard let deviceTokenUse:Data = deviceToken else {
            return
        }
        let hex = deviceTokenUse.hexString
        #if arch(i386) || arch(x86_64)
        let urlString = "http://127.0.0.1:8181/notification/add"
        #else
        //            let urlString = "http://172.26.147.180:8181/notification/add"
                    let urlString = "http://192.168.3.29:8181/notification/add"
//        let urlString = "http://172.26.83.6/notification/add"
        #endif
        let parameters:Dictionary = ["deviceId":hex]
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseString { (response) in
                print("response")
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

// utility
extension UInt8 {
    var hexString: String {
        var s = ""
        let b = self >> 4
        s.append(String(UnicodeScalar(b > 9 ? b - 10 + 65 : b + 48)))
        let b2 = self & 0x0F
        s.append(String(UnicodeScalar(b2 > 9 ? b2 - 10 + 65 : b2 + 48)))
        return s
    }
}

extension Data {
    var hexString: String {
        guard count > 0 else {
            return ""
        }
        let deviceIdLen = count
        let deviceIdBytes = self.withUnsafeBytes {
            ptr in
            return UnsafeBufferPointer<UInt8>(start: ptr, count: self.count)
        }
        var hexStr = ""
        for n in 0..<deviceIdLen {
            let b = deviceIdBytes[n]
            hexStr.append(b.hexString)
        }
        return hexStr
    }
}

