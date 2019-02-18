# swift后台-Perfect

[![Swift 4.1](https://camo.githubusercontent.com/c10a9f743bfb7e0a70b21ddd7f9a903547919453/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f53776966742d342e312d6f72616e67652e7376673f7374796c653d666c6174) ](https://developer.apple.com/swift/)[![Platforms OS X | Linux](https://camo.githubusercontent.com/7e6601038fbe6d4d88dc05527ffa8b813a8dc6e6/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f506c6174666f726d732d4f53253230582532302537432532304c696e75782532302d6c69676874677261792e7376673f7374796c653d666c6174) ](https://developer.apple.com/swift/)[![License Apache](https://camo.githubusercontent.com/aeabbcb9ee3e70ec0f168e4b7bfa64a4d121fd5d/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f4c6963656e73652d4170616368652d6c69676874677265792e7376673f7374796c653d666c6174) ](http://perfect.org/licensing.html)[![PerfectlySoft Twitter](https://camo.githubusercontent.com/b92dffb83d678eaa723bf80b29570a7169f69cda/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f547769747465722d40506572666563746c79536f66742d626c75652e7376673f7374796c653d666c6174) ](http://twitter.com/PerfectlySoft)[![Slack Status](https://camo.githubusercontent.com/51c7e954e533595d97570648a600d3cea749f1b5/687474703a2f2f706572666563742e6c792f62616467652e737667)](http://perfect.ly/)

***
## 1. 介绍

> [swift后台介绍](https://academy.realm.io/cn/posts/slug-edward-jiang-server-side-swift/)

​	2015年底苹果开源swift，现在swift也可以在Linux（ubuntu）上运行了，所以提供了swift做为后台开发语言的前提，加之github上也有很多的swift框架，做为一名iOS开发客户端和服务端都是用同一种语言减少了学习成本，而且看起来也是很coooooooooooooooool的一件事。


|                    swift后台框架                    |                         github-start                         |           官网           |
| :-------------------------------------------------: | :----------------------------------------------------------: | :----------------------: |
|       [vapor](https://github.com/vapor/vapor)       | [<img src="http://thyrsi.com/t6/671/1550458667x2890202791.png" width="5%" height="5%" />13.5k ](https://github.com/vapor/vapor/stargazers) |   https://vapor.codes/   |
| [Perfect](https://github.com/PerfectlySoft/Perfect) | [<img src="http://thyrsi.com/t6/671/1550458667x2890202791.png" width="5%" height="5%" />12.8k](https://github.com/PerfectlySoft/Perfect/stargazers) | https://www.perfect.org/ |
|    [Kitura](https://github.com/IBM-Swift/Kitura)    | [<img src="http://thyrsi.com/t6/671/1550458667x2890202791.png" width="5%" height="5%" />6.5k](https://github.com/IBM-Swift/Kitura/stargazers) |  http://www.kitura.io/   |

***

### 1. 初始化

从github上clone一个模版工程

>```bash
> git clone https://github.com/PerfectlySoft/PerfectTemplate.git
>
> cd PerfectTemplate
>
> swift build
>
> .build/debug/PerfectTemplate
>```

可以在终端控制台中看到类似下面的内容：

> [INFO] Starting HTTP server localhost on 0.0.0.0:8181

服务器现在已经运行并等待连接。从浏览器打开[http://localhost:8181/](http://127.0.0.1:8181/) 可以看到欢迎信息。完整的源代码请参考[PerfectTemplate项目模板](https://github.com/PerfectlySoft/PerfectTemplate)。

在的终端命令行内输入：SPM能够创建一个Xcode项目

>```bash
>swift package generate-xcodeproj
>```

#### For example : 访问静态文件

把对应的静态文件放在Products目录下，浏览器输入地址：http://localhost:8181/文件名（http://localhost:8181/baymax.html）即可访问

***

### 2. 启动服务

```swift
// 启动配置
let confData = [
	"servers": [
		[
			"name":"localhost",
			"port":8181,
			"routes":[
				["method":"get", "uri":"/", "handler":handler],
                ["method":"get", "uri":"/crawler", "handler":handlerCrawler],
                ["method":"get", "uri":"/home", "handler":handlerHome],
                ["method":"post", "uri":"/videolist", "handler":handlerVideolist],
				["method":"get", "uri":"/**", "handler":PerfectHTTPServer.HTTPHandler.staticFiles,
				 "documentRoot":"./webroot",
				 "allowResponseFilters":true]
			],
			"filters":[
				[
				"type":"response",
				"priority":"high",
				"name":PerfectHTTPServer.HTTPFilter.contentCompression,
				]
			]
		]
	]
]


// 启动服务
do {
    try HTTPServer.launch(configurationData: confData)
} catch {
    fatalError("\(error)")
}
```

***

### 3. 添加路由

```swift
["method":"get", "uri":"/home", "handler":handlerHome]
```

***

### 4. 处理具体请求的handler

```Swift
func handlerHome(request: HTTPRequest, response: HTTPResponse) {
    let jsonString = MySQLOperation().selectHomeTabelData()

    response.setBody(string: jsonString!)
    response.completed()
}
```

***

### 5. 使用Swift Package Manager (SPM) 做依赖管理

clone下来的代码我们可以在Package.swift中添加自己需要的dependencies：

```swift
import PackageDescription
let package = Package(
	name: "PerfectTemplate",
	targets: [],
	dependencies: [
		.Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 3),
	]
)
```

也可以使用[Perfect Assistant](https://www.perfect.org/zh/assistant/)做依赖管理，[使用事例](https://www.bilibili.com/video/av12211388)

***

## 2. 应用

使用Perfect实现后台，swift实现客户端，设计了一个简单的dilidili程序。其中后台主要实现了爬虫爬取dilidili视频数据，操作MySQL的增删改查，客户端首页的请求，视频列表请求。客户端主要实现了使用swift实现数据请求，json解析，视频播放。

### 1. 爬虫 

#### 1. 添加爬虫的路由：
```swift
// 添加路由
["method":"get", "uri":"/crawler", "handler":handlerCrawler],
```
#### 2. 爬虫请求处理的handler： 

```swift
// handler
func handlerCrawler(request: HTTPRequest, response: HTTPResponse) {

    response.setHeader(.contentType, value: "text/html")

    let url = "http://www.dilidili.wang/watch3/62066/"

    response.appendBody(string: Crawler.requestData(url: url))

    response.completed()

}
```
#### 3. 结果解析，拿到每一集的视频地址，标题，index

```swift
// 解析HTML，返回vidoeURLArray, titleArray, indexArray
static func extendHTML(html:String) -> (vidoeURLArray:Array<String>, titleArray:Array<String>, indexArray:Array<String>) {
        var nextVideoArray : Array<String> = Array()
        var titleArray : Array<String> = Array()
        var indexArray : Array<String> = Array()
        
        let xDoc = HTMLDocument(fromSource: html)
        for item in (xDoc?.getElementsByTagName("div"))! {
            let itemAtt = item.getAttribute(name: "class")
            if itemAtt == "num con24 clear" {
                var nextVideo : String = ""
                var title : String = ""
                var index : String = ""
                
                let childNodes = item.childNodes
                for childItem in childNodes {
                    if childItem.nodeName == "a" {
                        nextVideo = (childItem.attributes?.getNamedItem(name: "href")?.nodeValue)!
                        title = (childItem.attributes?.getNamedItem(name: "title")?.nodeValue)!
                        index = childItem.nodeValue!
                        nextVideoArray.append(nextVideo)
                        titleArray.append(title)
                        indexArray.append(index)
                    }
                }
            }
        }
        
        var vidoeURLArray:Array<String> = Array()
        for i in 0..<nextVideoArray.count {
            do {
                let resultHTML:String = try CURLRequest(nextVideoArray[i]).perform().bodyString
                let str:NSString = resultHTML as NSString
                let videoURL1 = videoURL(videoURL: str)
                if videoURL1 != "NotFound" {
                    vidoeURLArray.append(videoURL1)
                }
            } catch {
                print("ERROR")
            }
        }
        return (vidoeURLArray, titleArray, indexArray)
    }
```

### 2. MySQL操作 

#### 1. 实现一个MySQLManager，用于连接MySQL 
```swift
class MySQLManager {
    var mysql : MySQL!
    static let shareInstance : MySQLManager = {
        let instance = MySQLManager()
        let testHost = "127.0.0.1"
        let testUser = "root"
        let testPassword = "dw123456"
        let testDB = "dilidili"
        instance.mysql = MySQL()
        let connected = instance.mysql.connect(host: testHost, user: testUser, password: testPassword, db: testDB)
        if connected {
            print("connectedSuccess")
        } else {
            print("connectedError")
        }
        
        guard connected else {
            // 验证一下连接是否成功
            print(instance.mysql.errorMessage())
            return instance
        }
        return instance
    }()
    private init(){}

}
```

#### 2. 存放爬取到的数据到MySQL中

```swift
	/// 插入数据到home表
    ///
    /// - Parameters:
    ///   - animeID: 动画id
    ///   - animeTitle: 动画标题
    ///   - animeImage: 动画封面图片地址
    ///   - vidoeURLArray: 动画每集播放地址
    ///   - titleArray: 动画每集标题
    ///   - indexArray: 动画每集集数
    /// - Returns: 插入数据是否成功
    func insertToDataBase(animeID:Int, animeTitle:String, animeImage:String, vidoeURLArray:Array<String>, titleArray:Array<String>, indexArray:Array<String>) -> Bool {
        let homeValues = "(\(animeID), '\(animeTitle)', '\(animeImage)')"
        let homeStatement = "insert into home (id, animateTitle, animateImage) values \(homeValues)"
        let isHomeSuccess = self.mysql.query(statement: homeStatement)
        if isHomeSuccess {
            print("insertHomeSuccess")
        } else {
            print("insertHomeError")
        }
        
        let headEmpty = indexArray.count - vidoeURLArray.count
        for i in 0..<indexArray.count {
            if i < indexArray.count - 1 && i < vidoeURLArray.count && i < titleArray.count && i < indexArray.count {
                let videoValues = "(\(animeID), '\(vidoeURLArray[i])', '\(titleArray[i+headEmpty])', '\(indexArray[i+headEmpty])')"
                let videoStatement = "insert into video (animateID, animateURL, animateName, animateIndex) values \(videoValues)"
                let isVideoSuccess = self.mysql.query(statement: videoStatement)
                if isVideoSuccess {
                    print("insertVideoSuccess")
                } else {
                    print("insertVideoError")
                }
            }
        }
        return isHomeSuccess
    }
```

#### 3. 取MySQL中的数据

```swift
 	/// 查询home表
    ///
    /// - Returns: 返回查询json结果
    func selectHomeTabelData() -> String? {
        let statement = "select * from home"
        let isHomeSelectSuccess = self.mysql.query(statement: statement)
        if isHomeSelectSuccess {
            // 在当前会话过程中保存查询结果
            let results = mysql.storeResults()!
            var array = [[String:String]]() //创建一个字典数组用于存储结果
            results.forEachRow { row in
                guard let id = row.first! else {//保存选项表的id名称字段，应该是所在行的第一列，所以是row[0].
                    return
                }
                var dic = [String:String]() //创建一个字典数于存储结果
                dic["id"] = "\(id)"
                dic["animateTitle"] = "\(row[1]!)"
                dic["animateImage"] = "\(row[2]!)"
                array.append(dic)
            }
            self.responseJson[ResultKey] = RequestResultSuccess
            self.responseJson[ResultListKey] = array
        } else {
            self.responseJson[ResultKey] = RequestResultFaile
            self.responseJson[ErrorMessageKey] = "查询失败"
        }
        guard let josn = try? responseJson.jsonEncodedString() else {
            return nil
        }
        return josn
    }
```

### 3. 实现客户端API

主要有两个API接口，查询首页信息和查询每集信息

#### 1. 添加首页和每集的路由

```swift
["method":"get", "uri":"/home", "handler":handlerHome],
["method":"post", "uri":"/videolist", "handler":handlerVideolist],
```

#### 2. handler

```swift
// 首页信息
func handlerHome(request: HTTPRequest, response: HTTPResponse) {
    let jsonString = MySQLOperation().selectHomeTabelData()

    response.setBody(string: jsonString!)
    response.completed()
}

// 每集信息
func handlerVideolist(request: HTTPRequest, response: HTTPResponse) {
    guard let animateID: String = request.param(name: "animateID") else {
        print("animateID为nil")
        return
    }
    let jsonString = MySQLOperation().selectVideoTabelData(animateID: animateID)
    
    response.setBody(string: jsonString!)
    response.completed()
}
```

#### 3. 查询首页数据和每集信息数据，并且返回json 

```swift
	/// 查询home表
    ///
    /// - Returns: 返回查询json结果
    func selectHomeTabelData() -> String? {
        let statement = "select * from home"
        let isHomeSelectSuccess = self.mysql.query(statement: statement)
        if isHomeSelectSuccess {
            // 在当前会话过程中保存查询结果
            let results = mysql.storeResults()!
            var array = [[String:String]]() //创建一个字典数组用于存储结果
            results.forEachRow { row in
                guard let id = row.first! else {//保存选项表的id名称字段，应该是所在行的第一列，所以是row[0].
                    return
                }
                var dic = [String:String]() //创建一个字典数于存储结果
                dic["id"] = "\(id)"
                dic["animateTitle"] = "\(row[1]!)"
                dic["animateImage"] = "\(row[2]!)"
                array.append(dic)
            }
            self.responseJson[ResultKey] = RequestResultSuccess
            self.responseJson[ResultListKey] = array
        } else {
            self.responseJson[ResultKey] = RequestResultFaile
            self.responseJson[ErrorMessageKey] = "查询失败"
        }
        guard let josn = try? responseJson.jsonEncodedString() else {// Dictionary转json
            return nil
        }
        return josn
    }
    
    
    /// 查询video的每集信息
    ///
    /// - Parameter animateID: 动画id
    /// - Returns: 返回查询json结果
    func selectVideoTabelData(animateID:String) -> String? {
        let videoValues = "('\(animateID)')"
        let statement = "select * from video where animateID=\(videoValues)"
        let isVideoSelect = self.mysql.query(statement: statement)
        if isVideoSelect {
            print("VideoSelectSuccess")
            // 在当前会话过程中保存查询结果
            let results = mysql.storeResults()!
            var array = [[String:String]]() //创建一个字典数组用于存储结果
            results.forEachRow { row in
                var dic = [String:String]() //创建一个字典数于存储结果
                dic["animateID"] = "\(row[1]!)"
                dic["animateURL"] = "\(row[2]!)"
                dic["animateName"] = "\(row[3]!)"
                dic["animateIndex"] = "\(row[4]!)"
                array.append(dic)
            }
            self.responseJson[ResultKey] = RequestResultSuccess
            self.responseJson[ResultListKey] = array
        } else {
            print("VideoSelectError")
            self.responseJson[ResultKey] = RequestResultFaile
            self.responseJson[ErrorMessageKey] = "查询失败"
        }
        guard let josn = try? responseJson.jsonEncodedString() else {// Dictionary转json
            return nil
        }
        return josn
    }
```

### 4. APNS

Apple Push Notification service。苹果推送通知服务

![APNS](/Users/yyinc/Downloads/apns.jpg)

#### 1. app向APNS 注册，系统询问是否允许通知，选择是以后系统向APNS发送请求 

```swift
let center = UNUserNotificationCenter.current()
center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
	print("Request permission for notifications: \(granted)")
	UIApplication.shared.registerForRemoteNotifications()
	center.delegate = self
}
```

#### 2. APNS返回一个device token，通过didRegisterForRemoteNotificationsWithDeviceToken获取device token（跟随设备，同一设备使用同一个device token） 

```Swift 
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    guard let deviceTokenUse:Data = deviceToken else {
            return
        }
}
```

#### 3. app 把获取到的device token传给自己的服务器

```swift
let hex = deviceTokenUse.hexString
        #if arch(i386) || arch(x86_64)
        let urlString = "http://127.0.0.1:8181/notification/add"
        #else
//        let urlString = "http://172.26.147.180:8181/notification/add"
        let urlString = "http://192.168.3.29:8181/notification/add"
//        let urlString = "http://172.26.83.6/notification/add"
        #endif
        let parameters:Dictionary = ["deviceId":hex]
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseString { (response) in
                print("response")
        }
```

#### 4. 当需要发送消息给app时候，自己的服务器根据收到的device token为依据发送消息给APNS

```swift
NotificationPusher(apnsTopic: notificationsTestId)
                    .pushAPNS(configurationName: notificationsTestId, deviceTokens: [array[i]], notificationItems: [.alertBody("Hello!"),.sound("default")]) { (responses) in
                        print("\(responses)")
}
```

#### 5. APNS发送一条消息给指定的app

### 5. 客户端实现

首页使用UICollectionView承载展示数据，使用Alamofire框架去请求数据（AFNetworking的swift版），使用代码+xib进行布局

```swift
// Alamofire发送请求首页数据
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
```

使用SnapKit（Masonry的swift版）进行视频区域的布局（当视频全屏的时候）

```swift
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
```

## 3. 其他

### 1. swift

Image Literal

### 2. git

可以尝试使用[git svn](https://git-scm.com/book/zh/v2/Git-%E4%B8%8E%E5%85%B6%E4%BB%96%E7%B3%BB%E7%BB%9F-%E4%BD%9C%E4%B8%BA%E5%AE%A2%E6%88%B7%E7%AB%AF%E7%9A%84-Git)

使用git clone 一个svn的项目

```bash
git svn clone svn地址 -s
```

```bash
git svn dcommit提交
```











